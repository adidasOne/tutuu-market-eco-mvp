import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';

const app = express();
const port = Number(process.env.PORT || 3002);

app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(morgan('dev'));

app.get('/health', (_req, res) => {
    res.json({ success: true, service: 'catalog-service', deviceId: process.env.DEVICE_ID || 'unknown', timestamp: new Date().toISOString() });
});

app.listen(port, () => {
    // eslint-disable-next-line no-console
    console.log(`catalog-service listening on port ${port}`);
});


