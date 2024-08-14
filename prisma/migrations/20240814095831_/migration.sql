/*
  Warnings:

  - You are about to drop the column `organization_id` on the `user` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[user_id]` on the table `participant` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `user_id` to the `participant` table without a default value. This is not possible if the table is not empty.
  - Added the required column `updated_at` to the `user` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "user" DROP CONSTRAINT "user_participant_id_fkey";

-- DropIndex
DROP INDEX "user_organization_id_key";

-- AlterTable
ALTER TABLE "participant" ADD COLUMN     "user_id" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "user" DROP COLUMN "organization_id",
ADD COLUMN     "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "updated_at" TIMESTAMP(3) NOT NULL;

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

-- CreateIndex
CREATE UNIQUE INDEX "refresh_token_id_key" ON "refresh_token"("id");

-- CreateIndex
CREATE UNIQUE INDEX "participant_user_id_key" ON "participant"("user_id");

-- AddForeignKey
ALTER TABLE "participant" ADD CONSTRAINT "participant_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "refresh_token" ADD CONSTRAINT "refresh_token_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("user_id") ON DELETE CASCADE ON UPDATE CASCADE;
