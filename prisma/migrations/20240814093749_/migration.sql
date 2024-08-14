-- DropForeignKey
ALTER TABLE "user" DROP CONSTRAINT "user_participant_id_fkey";

-- AlterTable
ALTER TABLE "user" ALTER COLUMN "participant_id" DROP NOT NULL,
ALTER COLUMN "organization_id" DROP NOT NULL;

-- AddForeignKey
ALTER TABLE "user" ADD CONSTRAINT "user_participant_id_fkey" FOREIGN KEY ("participant_id") REFERENCES "participant"("participant_id") ON DELETE SET NULL ON UPDATE CASCADE;
