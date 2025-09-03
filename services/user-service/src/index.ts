import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'express-morgan';
import userRoutes from './routes/user.routes';

const app = express();
const port = Number(process.env.PORT || 3001);

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(morgan('dev'));

// Device ID middleware
app.use((req, res, next) => {
  const deviceId = req.headers['x-device-id'] as string || 'unknown';
  req.headers['x-device-id'] = deviceId;
  next();
});

// Routes
app.use('/users', userRoutes);

// Health check endpoint
app.get('/health', (req, res) => {
    const deviceId = req.headers['x-device-id'] as string || 'unknown';
    res.json({ 
        success: true, 
        service: 'user-service', 
        deviceId,
        timestamp: new Date().toISOString() 
    });
});

// Root endpoint
app.get('/', (req, res) => {
    const deviceId = req.headers['x-device-id'] as string || 'unknown';
    res.json({
        success: true,
        message: 'TUTUU MARKET User Service API',
        version: '1.0.0',
        deviceId,
        endpoints: {
            health: '/health',
            users: '/users',
            register: '/users/register',
            login: '/users/login',
            profile: '/users/profile'
        }
    });
});

// Error handling middleware
app.use((err: any, req: express.Request, res: express.Response, next: express.NextFunction) => {
    const deviceId = req.headers['x-device-id'] as string || 'unknown';
    console.error('Error:', err);
    
    res.status(500).json({
        success: false,
        message: 'Внутренняя ошибка сервера',
        deviceId
    });
});

// 404 handler
app.use('*', (req, res) => {
    const deviceId = req.headers['x-device-id'] as string || 'unknown';
    res.status(404).json({
        success: false,
        message: 'Маршрут не найден',
        deviceId,
        requestedUrl: req.originalUrl
    });
});

app.listen(port, () => {
    console.log(`🚀 user-service запущен на порту ${port}`);
    console.log(`📱 Device ID tracking: включен`);
    console.log(`🔐 JWT аутентификация: готова`);
    console.log(`👥 Пользователи: /users/*`);
});


