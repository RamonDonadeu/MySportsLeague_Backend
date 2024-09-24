import express from 'express'
import auth from './auth/auth.routes.js'
import league from './league/league.routes.js'
import user from './users/users.routes.js'

const router = express.Router()
router.use('/auth', auth)
router.use('/user', user)
router.use('/league', league)

export default router