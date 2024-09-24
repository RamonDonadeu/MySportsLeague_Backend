/*
  Warnings:

  - You are about to drop the `teams_league_participating` table. If the table is not empty, all the data it contains will be lost.
  - Added the required column `player_league_participationLeague_id` to the `individual_league` table without a default value. This is not possible if the table is not empty.
  - Added the required column `player_league_participationPlayer_id` to the `individual_league` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "player_league_participation" DROP CONSTRAINT "player_league_participation_league_id_fkey";

-- DropForeignKey
ALTER TABLE "teams_league_participating" DROP CONSTRAINT "teams_league_participating_league_id_fkey";

-- AlterTable
ALTER TABLE "individual_league" ADD COLUMN     "player_league_participationLeague_id" TEXT NOT NULL,
ADD COLUMN     "player_league_participationPlayer_id" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "team" ADD COLUMN     "draws" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "losses" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "wins" INTEGER NOT NULL DEFAULT 0;

-- AlterTable
ALTER TABLE "team_league" ADD COLUMN     "allow_changes_in_team" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "maximum_team_participants" INTEGER,
ADD COLUMN     "minimum_team_participants" INTEGER;

-- DropTable
DROP TABLE "teams_league_participating";

-- AddForeignKey
ALTER TABLE "player_league_participation" ADD CONSTRAINT "player_league_participation_league_id_fkey" FOREIGN KEY ("league_id") REFERENCES "individual_league"("league_id") ON DELETE RESTRICT ON UPDATE CASCADE;
