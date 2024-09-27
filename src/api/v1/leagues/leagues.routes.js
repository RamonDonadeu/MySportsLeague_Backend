import express from 'express';
import { isAuthenticated } from '../../../middlewares/auth.js';
import userHasLeagueAccess from '../../../middlewares/userHasLeagueAccess.js';

const router = express.Router()

router.get('/:id', isAuthenticated, userHasLeagueAccess, async (req, res, next) => {
})

router.put('/:id', isAuthenticated, async (req, res, next) => {
})

export default router