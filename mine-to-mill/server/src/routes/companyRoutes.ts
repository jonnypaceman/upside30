import express from 'express';
import {
    getAllCompanies,
    getCompanyById,
    createCompany,
    updateCompany,
    deleteCompany
} from '../controllers/companyController';
import {
    validateCompany,
    validateCompanyId,
    checkValidationErrors
} from '../middleware/validators/companyValidator';

const router = express.Router();

// GET /api/v1/companies - Get all companies
router.get('/', getAllCompanies);

// GET /api/v1/companies/:id - Get company by ID
router.get('/:id', validateCompanyId, checkValidationErrors, getCompanyById);

// POST /api/v1/companies - Create new company
router.post('/', validateCompany, checkValidationErrors, createCompany);

// PUT /api/v1/companies/:id - Update company
router.put('/:id', [...validateCompanyId, ...validateCompany], checkValidationErrors, updateCompany);

// DELETE /api/v1/companies/:id - Delete company (soft delete)
router.delete('/:id', validateCompanyId, checkValidationErrors, deleteCompany);

export default router;
