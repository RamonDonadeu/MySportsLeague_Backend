import prisma from "../../../utils/prisma.js";

function createParticipation(player, league) {
    return prisma.player_league_participation.create({
        data: {
            player_id: player.player_id,
            league_id: league.league_id,
        }
    })
}

export { createParticipation };
