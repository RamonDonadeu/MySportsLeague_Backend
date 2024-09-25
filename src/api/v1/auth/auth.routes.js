import express from 'express';
import { login, refreshToken, register } from './auth.controller.js';

const router = express.Router();

router.post('/register', async (req, res, next) => {
    register(req, res, next);
});

// router.post('/register-organization', async (req, res, next) => {
//     registerOrganization(req, res, next);
// });

router.post('/login', async (req, res, next) => {
    login(req, res, next);
});

router.post('/refresh-token', async (req, res, next) => {
    refreshToken(req, res, next);
}
)


export default router;