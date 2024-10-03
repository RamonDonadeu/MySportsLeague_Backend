import { user } from '@prisma/client';
import jwt from 'jsonwebtoken';

function generateAccessToken(user: user) {
    return jwt.sign({ user_id: user.user_id }, process.env.JWT_ACCESS_SECRET as string, {
        expiresIn: process.env.ACCESS_TOKEN_EXPIRY,
    });
}

function generateRefreshToken(user: user, jti: string) {
    return jwt.sign({
        user_id: user.user_id,
        jti
    }, process.env.JWT_REFRESH_SECRET as string, {
        expiresIn: '8h',
    });
}

function generateTokens(user: user, jti: string) {
    const accessToken = generateAccessToken(user);
    const refreshToken = generateRefreshToken(user, jti);

    return {
        accessToken,
        refreshToken,
    };
}

export {
    generateAccessToken,
    generateRefreshToken,
    generateTokens
};
