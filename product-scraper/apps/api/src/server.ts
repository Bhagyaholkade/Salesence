import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import pinoHttp from 'pino-http';
import health from './routes/health';
import analyze from './routes/analyze';
import { errorHandler, notFoundHandler } from './lib/error';
import { logger } from './lib/logger';
import { config } from '@scraper/scraper-core';

const app = express();
app.use(helmet());
app.use(cors({
  origin: (origin, callback) => {
    const allowedOrigins = [
      'https://salesence-frontend.netlify.app',
      'http://localhost:5173',
      'http://localhost:3000'
    ];
    
    // Allow requests with no origin (like mobile apps or curl)
    if (!origin) return callback(null, true);
    
    // Allow any Netlify subdomain
    if (origin.endsWith('.netlify.app')) return callback(null, true);
    
    // Allow specific origins
    if (allowedOrigins.includes(origin)) return callback(null, true);
    
    callback(new Error('Not allowed by CORS'));
  },
  credentials: true
}));
app.use(express.json());
app.use(pinoHttp({ logger }));

app.use('/health', health);
app.use('/analyze', analyze);

app.use(notFoundHandler);
app.use(errorHandler);

app.listen(config.port, ()=> logger.info(`API on :${config.port}`));
