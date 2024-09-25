import express from 'express';
import { isAuthenticated } from '../../../middlewares/auth.js';
import { getUserById } from './users.controller.js';

const router = express.Router()

router.get('/:id', isAuthenticated, async (req, res, next) => {
    getUserById(req, res)
})

export default router