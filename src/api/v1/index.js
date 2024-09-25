import express from 'express'
import auth from './auth/auth.routes.js'
import user from './users/users.routes.js'

const router = express.Router()
router.use('/auth', auth)
router.use('/user', user)

export default router