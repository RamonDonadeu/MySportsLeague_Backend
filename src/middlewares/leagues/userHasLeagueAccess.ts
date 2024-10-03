
import getUserPayload from '../../utils/getUserPayload';
import { getUserInLeague } from '../../utils/userInLeague';

const userHasLeagueAccess = async (req: Request, res: Response, next: NextFunction) => {
    const userId = getUserPayload(req).user_id;
    const leagueId = req.params.leagueId;

    try {
        const userInLeague = await getUserInLeague(userId, leagueId);

        if (userInLeague) {
            // User is a league participant
            return next();
        }
        else {
            // User is not a league participant
            return res.status(403).json({ message: 'Forbidden: You are not a league participant.' });
        }
    } catch (error) {
        return res.status(500).json({ message: 'Internal Server Error' });
    }
};

export default userHasLeagueAccess;