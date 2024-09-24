import express from 'express';
import { isAuthenticated } from '../../../middlewares/auth.js';
import createValidations from "../../../validators/v1/league/create.js";
import { createLeagueController, getLeagueController } from './league.controller.js';

const router = express.Router()

router.post('/create', isAuthenticated, createValidations, async (req, res, next) => {
    createLeagueController(req, res)
})

router.get('/:league_id', isAuthenticated, async (req, res, next) => {
    getLeagueController(req, res)
})

export default router