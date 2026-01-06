import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import dotenv from 'dotenv';

// Load environment variables
dotenv.config();

const app = express();
const PORT = process.env.PORT || 4000;

// Middleware
app.use(helmet());
app.use(cors({
    origin: process.env.CORS_ORIGIN || 'http://localhost:4200',
    credentials: true
}));
app.use(express.json());

// Health check
app.get('/health', (req, res) => {
    res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// API routes
app.get('/api', (req, res) => {
    res.json({
        name: 'TrazaNet API',
        version: '0.1.0',
        endpoints: [
            'GET /health',
            'GET /api',
            'GET /api/animales',
            'POST /api/animales',
            'GET /api/lotes',
            'POST /api/lotes',
            'POST /api/sync'
        ]
    });
});

// TODO: Add routes
// import animalRoutes from './routes/animales';
// import loteRoutes from './routes/lotes';
// import syncRoutes from './routes/sync';
// app.use('/api/animales', animalRoutes);
// app.use('/api/lotes', loteRoutes);
// app.use('/api/sync', syncRoutes);

// Error handler
app.use((err: Error, req: express.Request, res: express.Response, next: express.NextFunction) => {
    console.error(err.stack);
    res.status(500).json({ error: 'Something went wrong!' });
});

// Start server
app.listen(PORT, () => {
    console.log(`🚀 TrazaNet API running on http://localhost:${PORT}`);
    console.log(`📝 Environment: ${process.env.NODE_ENV || 'development'}`);
});

export default app;
