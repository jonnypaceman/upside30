import { body, param, ValidationChain, validationResult } from 'express-validator';
import { Request, Response, NextFunction } from 'express';

// Validate company creation/update
export const validateCompany: ValidationChain[] = [
    body('code')
        .notEmpty().withMessage('Company code is required')
        .isString().withMessage('Company code must be a string')
        .isLength({ min: 1, max: 10 }).withMessage('Company code must be between 1 and 10 characters'),

    body('description')
        .notEmpty().withMessage('Company description is required')
        .isString().withMessage('Company description must be a string')
        .isLength({ min: 1, max: 100 }).withMessage('Company description must be between 1 and 100 characters'),

    body('isActive')
        .optional()
        .isBoolean().withMessage('isActive must be a boolean value')
];

// Validate company ID parameter
export const validateCompanyId: ValidationChain[] = [
    param('id')
        .notEmpty().withMessage('Company ID is required')
        .isInt().withMessage('Company ID must be an integer')
];

// Middleware to check for validation errors
export const checkValidationErrors = (req: Request, res: Response, next: NextFunction): void => {
    const errors = validationResult(req);

    // Check for validation errors
    if (!errors.isEmpty()) {
        res.status(400).json({
            status: 'error',
            message: 'Validation failed',
            errors: errors.array()
        });
        return;
    }

    next();
};
