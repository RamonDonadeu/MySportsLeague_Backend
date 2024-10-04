import express, { NextFunction, Request, Response } from 'express';
import { isAuthenticated } from '../../../middlewares/auth';
import { getUserById, updateUserController } from './users.controller';

const router = express.Router()

router.get('/:id', isAuthenticated, async (req: Request, res: Response, next: NextFunction) => {
    getUserById(req, res)
})

router.put('/:id', isAuthenticated, async (req: Request, res: Response, next: NextFunction) => {
    updateUserController(req, res)
})

export default router