import bcrypt from 'bcryptjs';
import prisma from '../../../utils/prisma.js';

function findUserByEmail(email) {
    return prisma.user.findUnique({
        where: {
            email,
        },
    });
}

function createUserByEmailAndPassword(user) {
    user.password = bcrypt.hashSync(user.password, 12);
    return prisma.user.create({
        data: {
            ...user,
            role: "PLAYER"
        },
    });
}

function findUserById(id) {
    return prisma.user.findUnique({
        where: {
            user_id: id
        },
    });
}

export {
    createUserByEmailAndPassword, findUserByEmail,
    findUserById
};
