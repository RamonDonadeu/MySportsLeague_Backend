
import { getLeagueById } from '../models/leagueModel.js';
import getUserPayload from './getUserPayload.js';

const userHasLeagueAccess = async (req, res, next) => {
    const userId = getUserPayload(req).user_id;
    const leagueId = req.params.leagueId;

    try {
        const league = await getLeagueById(leagueId);

        if (league.members.includes(userId)) {
            // User is part of the league
            return next();
        } else {
            // User is not part of the league
            return res.status(403).json({ message: 'Forbidden: You are not a member of this league.' });
        }
    } catch (error) {
        return res.status(500).json({ message: 'Internal Server Error' });
    }
};

export default userHasLeagueAccess;