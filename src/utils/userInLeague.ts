import prisma from "../../prisma";

function getUserInLeague(user_id: string, league_id: string) {
    return prisma.user_in_league.findUnique({
        where: {
            user_id_league_id: {
                user_id,
                league_id
            }
        }
    })
}

function getUsersInLeague(league_id: string) {
    return prisma.user_in_league.findMany({
        where: {
            league_id
        }
    })
}

export {
    getUserInLeague,
    getUsersInLeague
};
