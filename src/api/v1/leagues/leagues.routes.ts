import express from 'express';
import { isAuthenticated } from '../../../middlewares/auth';
import userHasLeagueAccess from '../../../middlewares/leagues/userHasLeagueAccess';
import userIsLeagueModerator from '../../../middlewares/leagues/userIsLeagueModerator';

const router = express.Router()

router.get('/:id', isAuthenticated, userHasLeagueAccess, async (req: Request, res: Response, next: NextFunction) => {
})

router.post('/:id', isAuthenticated, async (req: Request, res: Response, next: NextFunction) => {
})

router.put('/:id', isAuthenticated, userIsLeagueModerator, async (req: Request, res: Response, next: NextFunction) => {

})

export default router