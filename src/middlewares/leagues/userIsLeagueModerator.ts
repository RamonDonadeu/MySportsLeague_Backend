
import { getUserInLeague } from '../../utils/userInLeague';
import getUserPayload from './getUserPayload';

const userIsLeagueModerator = async (req: Request, res: Response, next: NextFunction) => {
    const userId = getUserPayload(req: Request).user_id;
    const leagueId = req.params.leagueId;

    try {
        const userInLeague = await getUserInLeague(userId, leagueId);

        if (userInLeague.is_league_moderator) {
            // User is a league moderator
            return next();
        } else {
            // User is not a league moderator
            return res.status(403).json({ message: 'Forbidden: You are not a league moderator.' });
        }
    } catch (error) {
        return res.status(500).json({ message: 'Internal Server Error' });
    }
};

export default userIsLeagueModerator;