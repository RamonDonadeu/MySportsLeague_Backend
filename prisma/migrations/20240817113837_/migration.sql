/*
  Warnings:

  - Added the required column `league_id` to the `team` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "team" ADD COLUMN     "league_id" TEXT NOT NULL;

-- CreateTable
CREATE TABLE "team_league" (
    "league_id" TEXT NOT NULL,

    CONSTRAINT "team_league_pkey" PRIMARY KEY ("league_id")
);

-- AddForeignKey
ALTER TABLE "team" ADD CONSTRAINT "team_league_id_fkey" FOREIGN KEY ("league_id") REFERENCES "team_league"("league_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "team_league" ADD CONSTRAINT "team_league_league_id_fkey" FOREIGN KEY ("league_id") REFERENCES "league"("league_id") ON DELETE RESTRICT ON UPDATE CASCADE;
