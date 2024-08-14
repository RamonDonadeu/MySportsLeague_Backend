import express from 'express';
import v1 from './api/v1/index.js';
import v2 from './api/v2/index.js';

const app = express();
app.listen(3000, () => {
    console.log("Server running on port 3000");
});

app.use(express.json());
app.use('/api/v1', v1);
app.use('/api/v2', v2);
