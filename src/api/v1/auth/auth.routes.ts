import express, { NextFunction, Request, Response } from 'express';
import { login, refreshToken, register } from './auth.controller';

const router = express.Router();

router.post('/register', (req: Request, res: Response, next: NextFunction) => {
    register(req, res, next);
});

router.post('/login', (req: Request, res: Response, next: NextFunction) => {
    login(req, res, next);
});

router.post('/refresh-token', async (req: Request, res: Response, next: NextFunction) => {
    refreshToken(req, res, next);
});

export default router;