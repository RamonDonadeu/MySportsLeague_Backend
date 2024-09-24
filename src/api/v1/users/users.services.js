import bcrypt from 'bcryptjs';
import logger from '../../../utils/logger.js';
import prisma from '../../../utils/prisma.js';

function getUserPassword(user_id) {
    return prisma.user.findUnique({
        where: {
            user_id
        }
    })
}

function findUserByEmail(email) {
    return prisma.user.findUnique({
        where: {
            email,
        },
        omit: { password: true },
    });
}

async function createPlayerUser(user) {
    return prisma.$transaction(async (transaction) => {
        try {
            // 1.- Create a new user of type PLAYER
            user.password = bcrypt.hashSync(user.password, 12);
            user = await transaction.user.create({
                data: {
                    ...user,
                    role: "PLAYER"
                },
            });
            // 2.- Create a new participant of type USER
            await transaction.player.create({
                data: {
                    user_id: user.user_id
                }
            })
            return user
        }
        catch (error) {
            logger(error)
            throw error
        }
    })
}

function findUserById(id) {
    return prisma.user.findUnique({
        omit: { password: true },
        where: {
            user_id: id
        },
    });
}

export {
    createPlayerUser, findUserByEmail,
    findUserById, getUserPassword
};
