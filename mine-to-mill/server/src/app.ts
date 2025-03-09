import express, { Application, Request, Response, NextFunction } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import { config } from 'dotenv';
import { testConnection } from './database/connection';
import { notFound, errorHandler } from './middleware/errorHandler';
import models, { sequelize } from './models';

// Import routes
import companyRoutes from './routes/companyRoutes';

// Load environment variables
config();

// Create Express application
const app: Application = express();

// Middleware
app.use(helmet()); // Security headers
app.use(cors()); // Enable CORS
app.use(express.json()); // Parse JSON bodies
app.use(express.urlencoded({ extended: true })); // Parse URL-encoded bodies
app.use(morgan('dev')); // HTTP request logger

// Test database connection and sync models
if (process.env.NODE_ENV !== 'test') {
    testConnection()
        .then(() => {
            console.log('Database connection established');
            // Sync models with database
            return sequelize.sync({ alter: process.env.NODE_ENV === 'development' });
        })
        .then(() => {
            console.log('Database models synchronized');
        })
        .catch(err => console.error('Database initialization failed:', err));
}

// Health check route
app.get('/health', (req: Request, res: Response) => {
    res.status(200).json({
        status: 'ok',
        message: 'Mine to Mill Reconciliation API is running',
        timestamp: new Date().toISOString(),
        environment: process.env.NODE_ENV || 'development'
    });
});

// API routes
app.use('/api/v1/companies', companyRoutes);

// 404 handler
app.use(notFound);

// Error handler
app.use(errorHandler);

export default app;
