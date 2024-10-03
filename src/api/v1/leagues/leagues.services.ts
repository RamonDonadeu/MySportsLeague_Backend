import prisma from "../../../../prisma";

function getLeagueById(id) {
    return prisma.league.findUnique({
        where: {
            league_id: id
        }
    })
}

export {
    getLeagueById
};
