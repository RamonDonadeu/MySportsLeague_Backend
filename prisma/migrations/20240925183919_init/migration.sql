-- CreateEnum
CREATE TYPE "league_type" AS ENUM ('ELO', 'POINTS');

-- CreateEnum
CREATE TYPE "league_status" AS ENUM ('ACTIVE', 'FINISHED', 'NOT_STARTED');

-- CreateEnum
CREATE TYPE "match_status" AS ENUM ('PENDING', 'FINISHED', 'CANCELLED');

-- CreateTable
CREATE TABLE "refresh_token" (
    "id" TEXT NOT NULL,
    "hashed_token" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "revoked" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "refresh_token_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user" (
    "user_id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "surname" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_pkey" PRIMARY KEY ("user_id")
);

-- CreateTable
CREATE TABLE "user_in_team" (
    "user_id" TEXT NOT NULL,
    "team_id" TEXT NOT NULL,

    CONSTRAINT "user_in_team_pkey" PRIMARY KEY ("user_id","team_id")
);

-- CreateTable
CREATE TABLE "participant" (
    "participant_id" TEXT NOT NULL,

    CONSTRAINT "participant_pkey" PRIMARY KEY ("participant_id")
);

-- CreateTable
CREATE TABLE "team" (
    "team_id" TEXT NOT NULL,
    "team_name" TEXT NOT NULL,
    "team_owner_id" TEXT NOT NULL,
    "participant_id" TEXT NOT NULL,

    CONSTRAINT "team_pkey" PRIMARY KEY ("team_id")
);

-- CreateTable
CREATE TABLE "user_in_league" (
    "user_id" TEXT NOT NULL,
    "league_id" TEXT NOT NULL,

    CONSTRAINT "user_in_league_pkey" PRIMARY KEY ("user_id","league_id")
);

-- CreateTable
CREATE TABLE "league" (
    "league_id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "is_team_based" BOOLEAN NOT NULL DEFAULT false,
    "status" "league_status" NOT NULL DEFAULT 'NOT_STARTED',
    "maximum_participants" INTEGER,
    "allow_late_join" BOOLEAN NOT NULL DEFAULT true,
    "type" "league_type",
    "start_date" TIMESTAMP(3),
    "end_date" TIMESTAMP(3),
    "match_can_end_in_draw" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "league_pkey" PRIMARY KEY ("league_id")
);

-- CreateTable
CREATE TABLE "match" (
    "match_id" TEXT NOT NULL,
    "match_status" "match_status" NOT NULL,
    "visitor_participant_id" TEXT NOT NULL,
    "local_participant_id" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "winner_id" TEXT,
    "draw" BOOLEAN,

    CONSTRAINT "match_pkey" PRIMARY KEY ("match_id")
);

-- CreateTable
CREATE TABLE "_teamTouser" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "_leagueTomatch" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "_leagueTouser" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "refresh_token_id_key" ON "refresh_token"("id");

-- CreateIndex
CREATE UNIQUE INDEX "user_email_key" ON "user"("email");

-- CreateIndex
CREATE UNIQUE INDEX "_teamTouser_AB_unique" ON "_teamTouser"("A", "B");

-- CreateIndex
CREATE INDEX "_teamTouser_B_index" ON "_teamTouser"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_leagueTomatch_AB_unique" ON "_leagueTomatch"("A", "B");

-- CreateIndex
CREATE INDEX "_leagueTomatch_B_index" ON "_leagueTomatch"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_leagueTouser_AB_unique" ON "_leagueTouser"("A", "B");

-- CreateIndex
CREATE INDEX "_leagueTouser_B_index" ON "_leagueTouser"("B");

-- AddForeignKey
ALTER TABLE "refresh_token" ADD CONSTRAINT "refresh_token_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("user_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "team" ADD CONSTRAINT "team_team_owner_id_fkey" FOREIGN KEY ("team_owner_id") REFERENCES "user"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "team" ADD CONSTRAINT "team_participant_id_fkey" FOREIGN KEY ("participant_id") REFERENCES "participant"("participant_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "match" ADD CONSTRAINT "match_visitor_participant_id_fkey" FOREIGN KEY ("visitor_participant_id") REFERENCES "participant"("participant_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "match" ADD CONSTRAINT "match_local_participant_id_fkey" FOREIGN KEY ("local_participant_id") REFERENCES "participant"("participant_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "match" ADD CONSTRAINT "match_winner_id_fkey" FOREIGN KEY ("winner_id") REFERENCES "participant"("participant_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_teamTouser" ADD CONSTRAINT "_teamTouser_A_fkey" FOREIGN KEY ("A") REFERENCES "team"("team_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_teamTouser" ADD CONSTRAINT "_teamTouser_B_fkey" FOREIGN KEY ("B") REFERENCES "user"("user_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_leagueTomatch" ADD CONSTRAINT "_leagueTomatch_A_fkey" FOREIGN KEY ("A") REFERENCES "league"("league_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_leagueTomatch" ADD CONSTRAINT "_leagueTomatch_B_fkey" FOREIGN KEY ("B") REFERENCES "match"("match_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_leagueTouser" ADD CONSTRAINT "_leagueTouser_A_fkey" FOREIGN KEY ("A") REFERENCES "league"("league_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_leagueTouser" ADD CONSTRAINT "_leagueTouser_B_fkey" FOREIGN KEY ("B") REFERENCES "user"("user_id") ON DELETE CASCADE ON UPDATE CASCADE;
