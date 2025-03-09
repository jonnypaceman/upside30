import sequelize from '../database/connection';
import Company from './Company';

// Initialize models
const models = {
    Company
};

// Set up associations
Object.values(models).forEach((model: any) => {
    if (model.associate) {
        model.associate(models);
    }
});

// Export models and sequelize instance
export { sequelize };
export default models;
