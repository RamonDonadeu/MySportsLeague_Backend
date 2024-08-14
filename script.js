
async function main() {
    await prisma.user.deleteMany({})
    const user = await prisma.user.create({
        data: {
            email: 'test@test.com',
            name: 'Alice',
            password: '123',
            role: 'PLAYER',
        }
    }
    )
    console.log(user)
}

main()
    .catch(e => {
        console.error(e)
    })