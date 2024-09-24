import jwt from 'jsonwebtoken';

function generateAccessToken(user) {
    return jwt.sign({ user_id: user.user_id }, process.env.JWT_ACCESS_SECRET, {
        expiresIn: process.env.ACCESS_TOKEN_EXPIRY,
    });
}

function generateRefreshToken(user, jti) {
    return jwt.sign({
        user_id: user.user_id,
        jti
    }, process.env.JWT_REFRESH_SECRET, {
        expiresIn: '8h',
    });
}

function generateTokens(user, jti) {
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
