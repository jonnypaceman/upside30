import { Model, DataTypes, Optional } from 'sequelize';
import sequelize from '../database/connection';

// Company attributes interface
interface CompanyAttributes {
    id: number;
    code: string;
    description: string;
    isActive: boolean;
    createdAt: Date;
    updatedAt: Date;
}

// Company creation attributes interface (optional fields for creation)
interface CompanyCreationAttributes extends Optional<CompanyAttributes, 'id' | 'createdAt' | 'updatedAt'> { }

// Company model class
class Company extends Model<CompanyAttributes, CompanyCreationAttributes> implements CompanyAttributes {
    public id!: number;
    public code!: string;
    public description!: string;
    public isActive!: boolean;
    public createdAt!: Date;
    public updatedAt!: Date;

    // Define associations
    public static associate(models: any): void {
        // Company has many Regions
        // Company.hasMany(models.Region, { foreignKey: 'companyId', as: 'regions' });

        // Company has many Operations
        // Company.hasMany(models.Operation, { foreignKey: 'companyId', as: 'operations' });
    }
}

// Initialize Company model
Company.init(
    {
        id: {
            type: DataTypes.INTEGER,
            autoIncrement: true,
            primaryKey: true,
        },
        code: {
            type: DataTypes.STRING(10),
            allowNull: false,
            unique: true,
            validate: {
                notEmpty: true,
                len: [1, 10],
            },
        },
        description: {
            type: DataTypes.STRING(100),
            allowNull: false,
            validate: {
                notEmpty: true,
                len: [1, 100],
            },
        },
        isActive: {
            type: DataTypes.BOOLEAN,
            allowNull: false,
            defaultValue: true,
        },
        createdAt: {
            type: DataTypes.DATE,
            allowNull: false,
            defaultValue: DataTypes.NOW,
        },
        updatedAt: {
            type: DataTypes.DATE,
            allowNull: false,
            defaultValue: DataTypes.NOW,
        },
    },
    {
        sequelize,
        modelName: 'Company',
        tableName: 'companies',
        timestamps: true,
    }
);

export default Company;
