import supertest from 'supertest';

import app from '../src/index.ts';

const api = supertest(app);

