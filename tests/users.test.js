import { testApi } from "./utils/login"

const userToCreate = {
    email: 'user@test.com',
    name: 'test',
    surname: 'test',
    password: '1234'
}



describe('Users tests', () => {


    it('Create user', async () => {
        it('Not passing email', async () => {
            const response = await testApi.post('/api/v1/user').send({ name: userToCreate.name, surname: userToCreate.surname, password: userToCreate.password })
            expect(response.status).toBe(400)
        })
        it('Not passing password', async () => {
            const response = await testApi.post('/api/v1/user').send({ email: userToCreate.email, name: userToCreate.name, surname: userToCreate.surname })
            expect(response.status).toBe(400)
        })
        it('Not passing name', async () => {
            const response = await testApi.post('/api/v1/user').send({ email: userToCreate.email, password: userToCreate.password, surname: userToCreate.surname })
            expect(response.status).toBe(400)
        })
        it('Not passing surname', async () => {
            const response = await testApi.post('/api/v1/user').send({ email: userToCreate.email, password: userToCreate.password, name: userToCreate.name })
            expect(response.status).toBe(400)
        })
        it('Passing all fields', async () => {
            const response = await testApi.post('/api/v1/user').send(userToCreate)
            expect(response.status).toBe(201)
        })
    })
})