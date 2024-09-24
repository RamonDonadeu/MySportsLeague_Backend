import prisma from "../../../utils/prisma.js";

function createIndividualLeague(league) {
    return prisma.$transaction(async (transaction) => {
        try {
            const newLeague = await transaction.league.create({
                data: {
                    is_team_based: false,
                    ...league
                }
            })
            await transaction.individual_league.create({
                data: {
                    league_id: newLeague.league_id
                }
            })
        } catch (error) {
            throw error
        }
    })
}

function createTeamLeague(league) {
    return prisma.$transaction(async (transaction) => {
        try {
            const newLeague = transaction.league.create({
                data: {
                    is_team_based: true,
                    ...league
                }
            })
            transaction.team_league.create({
                data: {
                    league_id: newLeague.league_id
                }
            })
        } catch (error) {
            throw error
        }
    })
}


function getLeague(league_id) {
    return prisma.league.findUnique({
        where: {
            league_id: league_id
        }
    })
}

export { createIndividualLeague, createTeamLeague, getLeague };

