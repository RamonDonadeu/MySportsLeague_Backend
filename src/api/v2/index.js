import express from 'express'

const router = express.Router()

router.get('/', (req, res) => {
    res.json({ message: 'Hello from v2' })
}
)

export default router