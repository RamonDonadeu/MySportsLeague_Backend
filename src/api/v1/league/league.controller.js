import logger from "../../../utils/logger.js";
import { createLeague, getLeague } from "./league.services.js";

async function createLeagueController(req, res) {
    try {
        const league = {
            name: req.body.name,
            private: req.body.private,
            owner_id: req.payload.user_id
        }
        const newLeague = await createLeague(league)
        res.send(newLeague)
    }
    catch (err) {
        logger(err)
        res.status(500).send('Internal Server Error');
    }
}

async function getLeagueController(req, res) {
    const { league_id } = req.params;

    const league = await getLeague(league_id);
    if (!league) {
        return res.status(404).send('League not found');
    }
    if (league.private && league.owner_id !== req.payload.user_id) {
        return res.status(403).send('Unauthorized');
    }

    res.send(league);
}

export { createLeagueController, getLeagueController };
