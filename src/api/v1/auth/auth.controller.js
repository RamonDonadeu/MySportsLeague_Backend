import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { v4 } from 'uuid';
import { hashToken } from '../../../utils/hashToken.js';
import { generateTokens } from '../../../utils/jwt.js';
import logger from '../../../utils/logger.js';
import { createPlayerUser, findUserByEmail, findUserById, getUserPassword } from '../users/users.services.js';
import { addRefreshTokenToWhitelist, deleteRefreshToken, findRefreshTokenById } from './auth.services.js';


const uuidv4 = v4
async function registerPlayer(req, res, next) {
    try {
        const { email, password, name, surname } = req.body;
        if (!email || !password || !name || !surname) {
            res.status(400).send('Missing Fields.');
            return;
        }

        const existingUser = await findUserByEmail(email);

        if (existingUser) {
            res.status(400).send('Email already in use.');
            return
        }

        const user = await createPlayerUser({ email, password, name, surname });
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

async function login(req, res, next) {
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
        const { password: hashedPassword } = await getUserPassword(existingUser.user_id)

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

async function refreshToken(req, res, next) {
    try {
        const { refreshToken } = req.body;
        if (!refreshToken) {
            res.status(400).send('refreshTokenMissing');
            return;
        }
        const payload = jwt.verify(refreshToken, process.env.JWT_REFRESH_SECRET);
        const savedRefreshToken = await findRefreshTokenById(payload.jti);

        if (!savedRefreshToken || savedRefreshToken.revoked === true) {
            res.sendStatus(401)
            return
        }

        const hashedToken = hashToken(refreshToken);
        if (hashedToken !== savedRefreshToken.hashed_token) {
            res.sendStatus(401);
            return
        }
        const user = await findUserById(payload.user_id);

        if (!user) {
            res.sendStatus(401);
            return
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

export { login, refreshToken, registerPlayer };

