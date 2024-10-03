import { user } from '@prisma/client';
import bcrypt from 'bcryptjs';
import { NextFunction, Request, Response } from 'express';
import jwt from 'jsonwebtoken';
import { v4 } from 'uuid';
import { hashToken } from '../../../utils/hashToken';
import { generateTokens } from '../../../utils/jwt';
import logger from '../../../utils/logger';
import { createUser, findUserByEmail, findUserById, getUserWithPassword } from '../users/users.services';
import { addRefreshTokenToWhitelist, deleteRefreshToken, findRefreshTokenById } from './auth.services';

declare module "jsonwebtoken" {
    export interface JwtPayload {
        user_id: string;
    }
}

const uuidv4 = v4;
async function register(req: Request, res: Response, next: NextFunction) {
    try {
        const { email, password, name, surname } = req.body as unknown as { email: string, password: string, name: string, surname: string };
        if (!email || !password || !name || !surname) {

            res.status(400).send('Missing Fields.');
            return;
        }

        const existingUser = await findUserByEmail(email);

        if (existingUser) {
            res.status(400).send('Email already in use.');
            return
        }

        const user = await createUser({ email, password, name, surname });
        const jti = uuidv4();
        const { accessToken, refreshToken } = generateTokens(user, jti);
        await addRefreshTokenToWhitelist({ jti, refreshToken, user_id: user.user_id });
        res.status(201).json({
            accessToken,
            refreshToken,
        });
    } catch (err) {
        logger(err);
        res.status(500).send('Internal server error.');
    }
}

async function login(req: Request, res: Response, next: NextFunction) {
    try {
        const { email, password } = req.body;
        if (!email || !password) {
            res.status(400).send('emailOrPasswordMissing');
            return;
        }

        const existingUser = await findUserByEmail(email);

        if (!existingUser) {
            res.status(404).send('wrongUserOrPassword');
            return
        }
        const { password: hashedPassword } = await getUserWithPassword(existingUser.user_id) as user

        const validPassword = await bcrypt.compare(password, hashedPassword);
        if (!validPassword) {
            res.status(401).send('wrongUserOrPassword');
            return;
        }

        const jti = uuidv4();
        const { accessToken, refreshToken } = generateTokens(existingUser, jti);
        await addRefreshTokenToWhitelist({ jti, refreshToken, user_id: existingUser.user_id });

        res.json({
            accessToken,
            refreshToken
        });
    } catch (err) {
        logger(err);

        res.status(500).send('Internal server error.');
    }
}

async function refreshToken(req: Request, res: Response, next: NextFunction) {
    try {
        const { refreshToken } = req.body;
        if (!refreshToken) {
            res.status(400).send('refreshTokenMissing');
            return;
        }
        const payload = jwt.verify(refreshToken, process.env.JWT_REFRESH_SECRET ? process.env.JWT_REFRESH_SECRET : '');
        const refreshTokenJti = typeof payload !== 'string' && 'jti' in payload ? payload.jti : null;

        if (!refreshTokenJti) {
            res.sendStatus(401);
            return;
        }

        const savedRefreshToken = await findRefreshTokenById(refreshTokenJti);

        if (!savedRefreshToken || savedRefreshToken.revoked === true) {
            res.sendStatus(401)
            return
        }

        const userId = typeof payload !== 'string' && 'user_id' in payload ? payload.user_id : null;

        if (!userId) {
            res.sendStatus(401);
            return;
        }

        const hashedToken = hashToken(refreshToken);
        if (hashedToken !== savedRefreshToken.hashed_token) {
            res.sendStatus(401);
            return;
        }

        const user = await findUserById(userId as string);

        if (!user) {
            res.sendStatus(401);
            return;
        }

        await deleteRefreshToken(savedRefreshToken.id);
        const jti = uuidv4();
        const { accessToken, refreshToken: newRefreshToken } = generateTokens(user, jti);
        await addRefreshTokenToWhitelist({ jti, refreshToken: newRefreshToken, user_id: user.user_id });

        res.json({
            accessToken,
            refreshToken: newRefreshToken
        });
    } catch (err) {
        logger(err);
        res.status(500).send('Internal server error.');
    }
}

export { login, refreshToken, register };

