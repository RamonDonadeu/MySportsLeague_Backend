import express from 'express';
import { isAuthenticated } from '../../../middlewares/auth';
import { getUserById, updateUserController } from './users.controller';

const router = express.Router()

router.get('/:id', isAuthenticated, async (req: Request, res: Response, next: NextFunction) => {
    getUserById(req: Request, res: Response)
})

router.put('/:id', isAuthenticated, async (req: Request, res: Response, next: NextFunction) => {
    updateUserController(req: Request, res: Response)
})

export default router