import express from 'express';
import { v4 } from 'uuid';
import { generateTokens } from '../../../utils/jwt.js';
import { createUserByEmailAndPassword, findUserByEmail } from '../users/users.services.js';
import { addRefreshTokenToWhitelist } from './auth.services.js';

const uuidv4 = v4;
const router = express.Router();

router.post('/register', async (req, res, next) => {
    try {
        const { email, password } = req.body;
        if (!email || !password) {
            res.status(400).send('You must provide an email and a password.');
            return
        }

        const existingUser = await findUserByEmail(email);

        if (existingUser) {
            res.status(400);
            throw new Error('Email already in use.');
        }

        const user = await createUserByEmailAndPassword({ email, password });
        const jti = uuidv4();
        const { accessToken, refreshToken } = generateTokens(user, jti);
        await addRefreshTokenToWhitelist({ jti, refreshToken, user_id: user.user_id });

        res.json({
            accessToken,
            refreshToken,
        });
    } catch (err) {
        res.status(err.status || 500).send(err.message || 'Internal server error.');
    }
});

router.post('/login', async (req, res, next) => {
    try {
        const { email, password } = req.body;
        if (!email || !password) {
            res.status(400);
            throw new Error('You must provide an email and a password.');
        }

        const existingUser = await findUserByEmail(email);

        if (!existingUser) {
            res.status(403);
            throw new Error('Invalid login credentials.');
        }

        const validPassword = await bcrypt.compare(password, existingUser.password);
        if (!validPassword) {
            res.status(403);
            throw new Error('Invalid login credentials.');
        }

        const jti = uuidv4();
        const { accessToken, refreshToken } = generateTokens(existingUser, jti);
        await addRefreshTokenToWhitelist({ jti, refreshToken, user_id: existingUser.id });

        res.json({
            accessToken,
            refreshToken
        });
    } catch (err) {
        next(err);
    }
});

export default router;