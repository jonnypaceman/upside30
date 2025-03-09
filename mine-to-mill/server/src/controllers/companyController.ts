import { Request, Response } from 'express';
import Company from '../models/Company';

// Get all companies
export const getAllCompanies = async (req: Request, res: Response): Promise<void> => {
    try {
        const companies = await Company.findAll({
            order: [['code', 'ASC']]
        });

        res.status(200).json({
            status: 'success',
            results: companies.length,
            data: {
                companies
            }
        });
    } catch (error) {
        console.error('Error fetching companies:', error);
        res.status(500).json({
            status: 'error',
            message: 'Failed to fetch companies'
        });
    }
};

// Get company by ID
export const getCompanyById = async (req: Request, res: Response): Promise<void> => {
    try {
        const { id } = req.params;
        const company = await Company.findByPk(id);

        if (!company) {
            res.status(404).json({
                status: 'error',
                message: `Company with ID ${id} not found`
            });
            return;
        }

        res.status(200).json({
            status: 'success',
            data: {
                company
            }
        });
    } catch (error) {
        console.error(`Error fetching company with ID ${req.params.id}:`, error);
        res.status(500).json({
            status: 'error',
            message: 'Failed to fetch company'
        });
    }
};

// Create new company
export const createCompany = async (req: Request, res: Response): Promise<void> => {
    try {
        const { code, description, isActive } = req.body;

        // Check if company with the same code already exists
        const existingCompany = await Company.findOne({ where: { code } });
        if (existingCompany) {
            res.status(400).json({
                status: 'error',
                message: `Company with code ${code} already exists`
            });
            return;
        }

        const newCompany = await Company.create({
            code,
            description,
            isActive: isActive !== undefined ? isActive : true
        });

        res.status(201).json({
            status: 'success',
            data: {
                company: newCompany
            }
        });
    } catch (error) {
        console.error('Error creating company:', error);
        res.status(500).json({
            status: 'error',
            message: 'Failed to create company'
        });
    }
};

// Update company
export const updateCompany = async (req: Request, res: Response): Promise<void> => {
    try {
        const { id } = req.params;
        const { code, description, isActive } = req.body;

        const company = await Company.findByPk(id);
        if (!company) {
            res.status(404).json({
                status: 'error',
                message: `Company with ID ${id} not found`
            });
            return;
        }

        // Check if updated code already exists for another company
        if (code && code !== company.code) {
            const existingCompany = await Company.findOne({ where: { code } });
            if (existingCompany && existingCompany.id !== parseInt(id)) {
                res.status(400).json({
                    status: 'error',
                    message: `Company with code ${code} already exists`
                });
                return;
            }
        }

        // Update company
        await company.update({
            code: code || company.code,
            description: description || company.description,
            isActive: isActive !== undefined ? isActive : company.isActive
        });

        res.status(200).json({
            status: 'success',
            data: {
                company
            }
        });
    } catch (error) {
        console.error(`Error updating company with ID ${req.params.id}:`, error);
        res.status(500).json({
            status: 'error',
            message: 'Failed to update company'
        });
    }
};

// Delete company
export const deleteCompany = async (req: Request, res: Response): Promise<void> => {
    try {
        const { id } = req.params;

        const company = await Company.findByPk(id);
        if (!company) {
            res.status(404).json({
                status: 'error',
                message: `Company with ID ${id} not found`
            });
            return;
        }

        // Soft delete by setting isActive to false
        await company.update({ isActive: false });

        res.status(200).json({
            status: 'success',
            message: 'Company deactivated successfully'
        });
    } catch (error) {
        console.error(`Error deleting company with ID ${req.params.id}:`, error);
        res.status(500).json({
            status: 'error',
            message: 'Failed to delete company'
        });
    }
};
