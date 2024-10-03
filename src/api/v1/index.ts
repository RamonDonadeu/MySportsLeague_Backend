import express from 'express'
import auth from './auth/auth.routes'
import user from './users/users.routes'

const router = express.Router()
router.use('/auth', auth)
router.use('/user', user)

export default router