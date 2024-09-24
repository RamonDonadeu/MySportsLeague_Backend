-- CreateTable
CREATE TABLE "friendship" (
    "player_id" TEXT NOT NULL,
    "friend_id" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "friendship_pkey" PRIMARY KEY ("player_id","friend_id")
);

-- CreateTable
CREATE TABLE "friend_request" (
    "player_id" TEXT NOT NULL,
    "friend_id" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "friend_request_pkey" PRIMARY KEY ("player_id","friend_id")
);

-- AddForeignKey
ALTER TABLE "friendship" ADD CONSTRAINT "friendship_player_id_fkey" FOREIGN KEY ("player_id") REFERENCES "player"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "friendship" ADD CONSTRAINT "friendship_friend_id_fkey" FOREIGN KEY ("friend_id") REFERENCES "player"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "friend_request" ADD CONSTRAINT "friend_request_player_id_fkey" FOREIGN KEY ("player_id") REFERENCES "player"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "friend_request" ADD CONSTRAINT "friend_request_friend_id_fkey" FOREIGN KEY ("friend_id") REFERENCES "player"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;
