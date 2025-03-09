import { config as dotenvConfig } from 'dotenv';

// Load environment variables
dotenvConfig();

interface DatabaseConfig {
    host: string;
    port: number;
    username: string;
    password: string;
    database: string;
    dialect: 'postgres';
    logging: boolean;
}

interface Config {
    env: string;
    port: number;
    jwtSecret: string;
    jwtExpiresIn: string;
    database: DatabaseConfig;
    corsOrigin: string;
}

// Default configuration
const defaultConfig: Config = {
    env: process.env.NODE_ENV || 'development',
    port: parseInt(process.env.PORT || '5000', 10),
    jwtSecret: process.env.JWT_SECRET || 'your-secret-key',
    jwtExpiresIn: process.env.JWT_EXPIRES_IN || '1d',
    database: {
        host: process.env.DB_HOST || 'localhost',
        port: parseInt(process.env.DB_PORT || '5432', 10),
        username: process.env.DB_USERNAME || 'postgres',
        password: process.env.DB_PASSWORD || 'postgres',
        database: process.env.DB_NAME || 'mine_to_mill',
        dialect: 'postgres',
        logging: process.env.DB_LOGGING === 'true'
    },
    corsOrigin: process.env.CORS_ORIGIN || '*'
};

// Environment specific configurations
const configurations: { [key: string]: Partial<Config> } = {
    development: {
        database: {
            ...defaultConfig.database,
            logging: true
        }
    },
    test: {
        database: {
            ...defaultConfig.database,
            database: 'mine_to_mill_test'
        }
    },
    production: {
        jwtSecret: process.env.JWT_SECRET,
        database: {
            ...defaultConfig.database,
            logging: false
        },
        corsOrigin: process.env.CORS_ORIGIN
    }
};

// Merge default config with environment specific config
const envConfig = configurations[defaultConfig.env] || {};
const config: Config = {
    ...defaultConfig,
    ...envConfig,
    database: {
        ...defaultConfig.database,
        ...(envConfig.database || {})
    }
};

export default config;
