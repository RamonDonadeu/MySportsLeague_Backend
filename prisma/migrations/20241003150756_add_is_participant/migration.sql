-- AlterTable
ALTER TABLE "user_in_league" ADD COLUMN     "is_league_moderator" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "is_league_participant" BOOLEAN NOT NULL DEFAULT false;
