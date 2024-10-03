import { user } from '@prisma/client';
import bcrypt from 'bcryptjs';
import prisma from '../../../../prisma';
import logger from '../../../utils/logger';

function getUserWithPassword(user_id: string) {
    return prisma.user.findUnique({
        where: {
            user_id
        }
    })

}

function findUserByEmail(email: string) {
    return prisma.user.findUnique({
        where: {
            email,
        },
        omit: { password: true },
    });
}

async function createUser(user: { email: string, password: string, name: string, surname: string }) {
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

async function updateUser(user: user) {
    return prisma.user.update({
        where: {
            user_id: user.user_id
        },
        data: {
            name: user.name,
            surname: user.surname,
            email: user.email
        }
    })
}

function findUserById(id: string) {
    return prisma.user.findUnique({
        omit: { password: true },
        where: {
            user_id: id
        },
    });
}

export {
    createUser, findUserByEmail,
    findUserById, getUserWithPassword, updateUser
};
