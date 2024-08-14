import { hashToken } from '../../../utils/hashToken.js';
import prisma from '../../../utils/prisma.js';

// used when we create a refresh token.
function addRefreshTokenToWhitelist({ jti, refreshToken, user_id }) {
    return prisma.refresh_token.create({
        data: {
            id: jti,
            hashed_token: hashToken(refreshToken),
            user_id
        },
    });
}

// used to check if the token sent by the client is in the database.
function findRefreshTokenById(id) {
    return prisma.refresh_token.findUnique({
        where: {
            id,
        },
    });
}

// soft delete tokens after usage.
function deleteRefreshToken(id) {
    return prisma.refresh_token.update({
        where: {
            id,
        },
        data: {
            revoked: true
        }
    });
}

function revokeTokens(user_id) {
    return prisma.refresh_token.updateMany({
        where: {
            user_id
        },
        data: {
            revoked: true
        }
    });
}

export {
    addRefreshTokenToWhitelist, deleteRefreshToken, findRefreshTokenById, revokeTokens
};
