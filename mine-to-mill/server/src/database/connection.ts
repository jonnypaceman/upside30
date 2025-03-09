import { Sequelize } from 'sequelize';
import config from '../config/config';

// Create Sequelize instance
const sequelize = new Sequelize({
    host: config.database.host,
    port: config.database.port,
    username: config.database.username,
    password: config.database.password,
    database: config.database.database,
    dialect: config.database.dialect,
    logging: config.database.logging ? console.log : false,
    pool: {
        max: 5,
        min: 0,
        acquire: 30000,
        idle: 10000
    }
});

// Test database connection
export const testConnection = async (): Promise<void> => {
    try {
        await sequelize.authenticate();
        console.log('Database connection has been established successfully.');
    } catch (error) {
        console.error('Unable to connect to the database:', error);
        throw error;
    }
};

export default sequelize;
