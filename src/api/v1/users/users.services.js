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

async function createUser(user) {
    return prisma.$transaction(async (transaction) => {
        try {
            user.password = bcrypt.hashSync(user.password, 12);
            return await transaction.user.create({
                data: {
                    ...user,
                },
            });            
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
    createUser, findUserByEmail,
    findUserById, getUserPassword
};
