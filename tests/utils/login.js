
import supertest from 'supertest';
import app from '../../src/index.ts';

const testApi = supertest(app);
testApi.set({ 'Accept': getAccessToken(), 'Content-type': 'application/ json' });

async function login() {
    return await testApi.post('/api/v1/login').send({ email: "test@test.com", password: '1234' })
}

async function getAccessToken(res) {
    const res = await login()
    return res.body.accessToken
}

export {
    testApi
};
