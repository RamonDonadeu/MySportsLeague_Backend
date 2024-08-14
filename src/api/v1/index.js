import express from 'express'
import auth from './auth/auth.routes.js'

const router = express.Router()
router.use('/auth', auth)

export default router