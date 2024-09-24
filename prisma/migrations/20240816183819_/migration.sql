-- CreateEnum
CREATE TYPE "user_role" AS ENUM ('ORGANIZATION', 'PLAYER');

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
    "role" "user_role" NOT NULL,

    CONSTRAINT "user_pkey" PRIMARY KEY ("user_id")
);

-- CreateTable
CREATE TABLE "player" (
    "user_id" TEXT NOT NULL,

    CONSTRAINT "player_pkey" PRIMARY KEY ("user_id")
);

-- CreateTable
CREATE TABLE "organization" (
    "organization_id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "owner_id" TEXT NOT NULL,

    CONSTRAINT "organization_pkey" PRIMARY KEY ("organization_id")
);

-- CreateTable
CREATE TABLE "team" (
    "team_id" TEXT NOT NULL,
    "team_name" TEXT NOT NULL,
    "team_owner_id" TEXT NOT NULL,
    "can_compete" BOOLEAN NOT NULL DEFAULT false,
    "points" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "team_pkey" PRIMARY KEY ("team_id")
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
    "points_for_win" INTEGER,
    "points_for_draw" INTEGER,
    "points_for_loss" INTEGER,
    "private" BOOLEAN NOT NULL,
    "password" TEXT,
    "owner_id" TEXT NOT NULL,

    CONSTRAINT "league_pkey" PRIMARY KEY ("league_id")
);

-- CreateTable
CREATE TABLE "teams_league_participating" (
    "league_id" TEXT NOT NULL,
    "minimum_team_participants" INTEGER,
    "maximum_team_participants" INTEGER,
    "allow_changes_in_team" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "teams_league_participating_pkey" PRIMARY KEY ("league_id")
);

-- CreateTable
CREATE TABLE "individual_league" (
    "league_id" TEXT NOT NULL,

    CONSTRAINT "individual_league_pkey" PRIMARY KEY ("league_id")
);

-- CreateTable
CREATE TABLE "player_league_participation" (
    "league_id" TEXT NOT NULL,
    "player_id" TEXT NOT NULL,
    "points" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "player_league_participation_pkey" PRIMARY KEY ("league_id","player_id")
);

-- CreateTable
CREATE TABLE "match" (
    "league_id" TEXT NOT NULL,
    "match_id" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "draw" BOOLEAN,
    "status" "match_status" NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "match_pkey" PRIMARY KEY ("match_id")
);

-- CreateTable
CREATE TABLE "team_match" (
    "match_id" TEXT NOT NULL,
    "local_team_id" TEXT NOT NULL,
    "visitor_team_id" TEXT NOT NULL,
    "winner_id" TEXT,
    "team_winner_id" TEXT,

    CONSTRAINT "team_match_pkey" PRIMARY KEY ("match_id")
);

-- CreateTable
CREATE TABLE "individual_match" (
    "match_id" TEXT NOT NULL,
    "winner_id" TEXT NOT NULL,
    "local_player_id" TEXT NOT NULL,
    "visitor_player_id" TEXT NOT NULL,

    CONSTRAINT "individual_match_pkey" PRIMARY KEY ("match_id")
);

-- CreateTable
CREATE TABLE "_playerToteam" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "refresh_token_id_key" ON "refresh_token"("id");

-- CreateIndex
CREATE UNIQUE INDEX "user_email_key" ON "user"("email");

-- CreateIndex
CREATE UNIQUE INDEX "player_user_id_key" ON "player"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "team_team_id_key" ON "team"("team_id");

-- CreateIndex
CREATE UNIQUE INDEX "_playerToteam_AB_unique" ON "_playerToteam"("A", "B");

-- CreateIndex
CREATE INDEX "_playerToteam_B_index" ON "_playerToteam"("B");

-- AddForeignKey
ALTER TABLE "refresh_token" ADD CONSTRAINT "refresh_token_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("user_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "player" ADD CONSTRAINT "player_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "organization" ADD CONSTRAINT "organization_owner_id_fkey" FOREIGN KEY ("owner_id") REFERENCES "user"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "team" ADD CONSTRAINT "team_team_owner_id_fkey" FOREIGN KEY ("team_owner_id") REFERENCES "player"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "league" ADD CONSTRAINT "league_owner_id_fkey" FOREIGN KEY ("owner_id") REFERENCES "user"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "teams_league_participating" ADD CONSTRAINT "teams_league_participating_league_id_fkey" FOREIGN KEY ("league_id") REFERENCES "league"("league_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "individual_league" ADD CONSTRAINT "individual_league_league_id_fkey" FOREIGN KEY ("league_id") REFERENCES "league"("league_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "player_league_participation" ADD CONSTRAINT "player_league_participation_league_id_fkey" FOREIGN KEY ("league_id") REFERENCES "league"("league_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "player_league_participation" ADD CONSTRAINT "player_league_participation_player_id_fkey" FOREIGN KEY ("player_id") REFERENCES "player"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "match" ADD CONSTRAINT "match_league_id_fkey" FOREIGN KEY ("league_id") REFERENCES "league"("league_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "team_match" ADD CONSTRAINT "team_match_match_id_fkey" FOREIGN KEY ("match_id") REFERENCES "match"("match_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "team_match" ADD CONSTRAINT "team_match_local_team_id_fkey" FOREIGN KEY ("local_team_id") REFERENCES "team"("team_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "team_match" ADD CONSTRAINT "team_match_visitor_team_id_fkey" FOREIGN KEY ("visitor_team_id") REFERENCES "team"("team_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "team_match" ADD CONSTRAINT "team_match_winner_id_fkey" FOREIGN KEY ("winner_id") REFERENCES "team"("team_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "individual_match" ADD CONSTRAINT "individual_match_match_id_fkey" FOREIGN KEY ("match_id") REFERENCES "match"("match_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "individual_match" ADD CONSTRAINT "individual_match_winner_id_fkey" FOREIGN KEY ("winner_id") REFERENCES "player"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "individual_match" ADD CONSTRAINT "individual_match_local_player_id_fkey" FOREIGN KEY ("local_player_id") REFERENCES "player"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "individual_match" ADD CONSTRAINT "individual_match_visitor_player_id_fkey" FOREIGN KEY ("visitor_player_id") REFERENCES "player"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_playerToteam" ADD CONSTRAINT "_playerToteam_A_fkey" FOREIGN KEY ("A") REFERENCES "player"("user_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_playerToteam" ADD CONSTRAINT "_playerToteam_B_fkey" FOREIGN KEY ("B") REFERENCES "team"("team_id") ON DELETE CASCADE ON UPDATE CASCADE;
