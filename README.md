# MySportsLeague_Backend

## How to run the project

### Local
docker-compose up local

## How to create a migration

* Update the schema in `prisma/schema.prisma`
* Run `npx prisma migrate dev --name <name>`

## Create a new user

* Update script.js with the desired user data
* npx ts-node script.js