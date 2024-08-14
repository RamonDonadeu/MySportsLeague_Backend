-- CreateEnum
CREATE TYPE "participant_type" AS ENUM ('USER', 'TEAM');

-- CreateEnum
CREATE TYPE "user_role" AS ENUM ('ORGANIZATION', 'PLAYER');

-- CreateEnum
CREATE TYPE "league_type" AS ENUM ('ELO', 'POINTS', 'SWISS', 'ROUND_ROBIN', 'SINGLE_KNOCKOUT', 'DOUBLE_KNOCKOUT', 'LOSER_BRACKET');

-- CreateEnum
CREATE TYPE "league_status" AS ENUM ('ACTIVE', 'FINISHED');

-- CreateEnum
CREATE TYPE "match_status" AS ENUM ('PENDING', 'FINISHED', 'CANCELLED');

-- CreateTable
CREATE TABLE "sport" (
    "sport_id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "minimum_team_size" INTEGER NOT NULL DEFAULT 1,
    "maximum_team_size" INTEGER,

    CONSTRAINT "sport_pkey" PRIMARY KEY ("sport_id")
);

-- CreateTable
CREATE TABLE "participant" (
    "participant_id" TEXT NOT NULL,
    "participant_type" "participant_type" NOT NULL,

    CONSTRAINT "participant_pkey" PRIMARY KEY ("participant_id")
);

-- CreateTable
CREATE TABLE "organization" (
    "organization_id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "organization_pkey" PRIMARY KEY ("organization_id")
);

-- CreateTable
CREATE TABLE "user" (
    "user_id" TEXT NOT NULL,
    "participant_id" TEXT NOT NULL,
    "organization_id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "name" TEXT,
    "password" TEXT NOT NULL,
    "role" "user_role" NOT NULL,

    CONSTRAINT "user_pkey" PRIMARY KEY ("user_id")
);

-- CreateTable
CREATE TABLE "team" (
    "team_id" TEXT NOT NULL,
    "team_name" TEXT NOT NULL,
    "sport_id" INTEGER NOT NULL
);

-- CreateTable
CREATE TABLE "team_members" (
    "user_id" TEXT NOT NULL,
    "team_id" TEXT NOT NULL,
    "is_team_owner" BOOLEAN NOT NULL,

    CONSTRAINT "team_members_pkey" PRIMARY KEY ("user_id","team_id")
);

-- CreateTable
CREATE TABLE "league" (
    "league_id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "is_team_based" BOOLEAN NOT NULL,
    "sport_id" INTEGER NOT NULL,
    "status" "league_status" NOT NULL,
    "organization_id" TEXT,
    "minimum_participants" INTEGER NOT NULL,
    "maximum_participants" INTEGER,
    "allow_changes_in_team" BOOLEAN NOT NULL,
    "type" "league_type" NOT NULL,
    "start_date" TIMESTAMP(3),
    "end_date" TIMESTAMP(3),
    "match_can_end_in_draw" BOOLEAN NOT NULL,
    "points_for_win" INTEGER,
    "points_for_draw" INTEGER,
    "points_for_loss" INTEGER,
    "private" BOOLEAN NOT NULL,
    "password" TEXT,

    CONSTRAINT "league_pkey" PRIMARY KEY ("league_id")
);

-- CreateTable
CREATE TABLE "league_members" (
    "participant_id" TEXT NOT NULL,
    "league_id" TEXT NOT NULL,
    "can_invite" BOOLEAN NOT NULL,
    "can_compete" BOOLEAN NOT NULL,
    "is_league_owner" BOOLEAN NOT NULL,

    CONSTRAINT "league_members_pkey" PRIMARY KEY ("participant_id","league_id")
);

-- CreateTable
CREATE TABLE "match" (
    "league_id" TEXT NOT NULL,
    "match_id" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "winner_id" TEXT,
    "draw" BOOLEAN,
    "status" "match_status" NOT NULL,
    "participant1_id" TEXT NOT NULL,
    "participant2_id" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "match_pkey" PRIMARY KEY ("match_id")
);

-- CreateTable
CREATE TABLE "friends" (
    "user_id" TEXT NOT NULL,
    "friend_id" TEXT NOT NULL,

    CONSTRAINT "friends_pkey" PRIMARY KEY ("user_id","friend_id")
);

-- CreateTable
CREATE TABLE "friend_requests" (
    "user_id" TEXT NOT NULL,
    "friend_id" TEXT NOT NULL,

    CONSTRAINT "friend_requests_pkey" PRIMARY KEY ("user_id","friend_id")
);

-- CreateTable
CREATE TABLE "league_invites" (
    "league_id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,

    CONSTRAINT "league_invites_pkey" PRIMARY KEY ("league_id","user_id")
);

-- CreateTable
CREATE TABLE "league_request" (
    "league_id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,

    CONSTRAINT "league_request_pkey" PRIMARY KEY ("league_id","user_id")
);

-- CreateTable
CREATE TABLE "team_invites" (
    "team_id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,

    CONSTRAINT "team_invites_pkey" PRIMARY KEY ("team_id","user_id")
);

-- CreateIndex
CREATE UNIQUE INDEX "organization_user_id_key" ON "organization"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "user_participant_id_key" ON "user"("participant_id");

-- CreateIndex
CREATE UNIQUE INDEX "user_organization_id_key" ON "user"("organization_id");

-- CreateIndex
CREATE UNIQUE INDEX "user_email_key" ON "user"("email");

-- CreateIndex
CREATE UNIQUE INDEX "team_team_id_key" ON "team"("team_id");

-- AddForeignKey
ALTER TABLE "organization" ADD CONSTRAINT "organization_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user" ADD CONSTRAINT "user_participant_id_fkey" FOREIGN KEY ("participant_id") REFERENCES "participant"("participant_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "team" ADD CONSTRAINT "team_team_id_fkey" FOREIGN KEY ("team_id") REFERENCES "participant"("participant_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "team" ADD CONSTRAINT "team_sport_id_fkey" FOREIGN KEY ("sport_id") REFERENCES "sport"("sport_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "team_members" ADD CONSTRAINT "team_members_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "team_members" ADD CONSTRAINT "team_members_team_id_fkey" FOREIGN KEY ("team_id") REFERENCES "team"("team_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "league" ADD CONSTRAINT "league_sport_id_fkey" FOREIGN KEY ("sport_id") REFERENCES "sport"("sport_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "league" ADD CONSTRAINT "league_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organization"("organization_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "league_members" ADD CONSTRAINT "league_members_participant_id_fkey" FOREIGN KEY ("participant_id") REFERENCES "participant"("participant_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "league_members" ADD CONSTRAINT "league_members_league_id_fkey" FOREIGN KEY ("league_id") REFERENCES "league"("league_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "match" ADD CONSTRAINT "match_league_id_fkey" FOREIGN KEY ("league_id") REFERENCES "league"("league_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "match" ADD CONSTRAINT "match_winner_id_fkey" FOREIGN KEY ("winner_id") REFERENCES "participant"("participant_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "match" ADD CONSTRAINT "match_participant1_id_fkey" FOREIGN KEY ("participant1_id") REFERENCES "participant"("participant_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "match" ADD CONSTRAINT "match_participant2_id_fkey" FOREIGN KEY ("participant2_id") REFERENCES "participant"("participant_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "friends" ADD CONSTRAINT "friends_friend_id_fkey" FOREIGN KEY ("friend_id") REFERENCES "user"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "friend_requests" ADD CONSTRAINT "friend_requests_friend_id_fkey" FOREIGN KEY ("friend_id") REFERENCES "user"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "league_invites" ADD CONSTRAINT "league_invites_league_id_fkey" FOREIGN KEY ("league_id") REFERENCES "league"("league_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "league_invites" ADD CONSTRAINT "league_invites_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "league_request" ADD CONSTRAINT "league_request_league_id_fkey" FOREIGN KEY ("league_id") REFERENCES "league"("league_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "league_request" ADD CONSTRAINT "league_request_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "team_invites" ADD CONSTRAINT "team_invites_team_id_fkey" FOREIGN KEY ("team_id") REFERENCES "team"("team_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "team_invites" ADD CONSTRAINT "team_invites_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;
