-- Mine to Mill Reconciliation System
-- Organization Structure Tables
-- This script creates the core organization structure tables for the Mine to Mill Reconciliation System.

-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Drop tables if they exist (in reverse order of dependencies)
DROP TABLE IF EXISTS OperationTbl CASCADE;
DROP TABLE IF EXISTS RegionTbl CASCADE;
DROP TABLE IF EXISTS CompanyTbl CASCADE;

-- Create Company table
CREATE TABLE CompanyTbl (
    CompanyID SERIAL PRIMARY KEY,
    CompanyCode VARCHAR(10) NOT NULL UNIQUE,
    CompanyDesc VARCHAR(100) NOT NULL,
    ActiveCheck BOOLEAN NOT NULL DEFAULT TRUE,
    CreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Create index on CompanyCode for faster lookups
CREATE INDEX idx_company_code ON CompanyTbl(CompanyCode);

-- Create Region table
CREATE TABLE RegionTbl (
    RegionID SERIAL PRIMARY KEY,
    CompanyID INTEGER NOT NULL,
    RegionCode VARCHAR(10) NOT NULL,
    RegionDesc VARCHAR(100) NOT NULL,
    ActiveCheck BOOLEAN NOT NULL DEFAULT TRUE,
    CreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_region_company FOREIGN KEY (CompanyID) REFERENCES CompanyTbl(CompanyID) ON DELETE CASCADE,
    CONSTRAINT uq_region_code_company UNIQUE (RegionCode, CompanyID)
);

-- Create indexes for Region table
CREATE INDEX idx_region_company ON RegionTbl(CompanyID);
CREATE INDEX idx_region_code ON RegionTbl(RegionCode);

-- Create Operation table
CREATE TABLE OperationTbl (
    OperationID SERIAL PRIMARY KEY,
    CompanyID INTEGER NOT NULL,
    RegionID INTEGER NOT NULL,
    OperationCode VARCHAR(10) NOT NULL,
    OperationDesc VARCHAR(100) NOT NULL,
    ActiveCheck BOOLEAN NOT NULL DEFAULT TRUE,
    CreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_operation_company FOREIGN KEY (CompanyID) REFERENCES CompanyTbl(CompanyID) ON DELETE CASCADE,
    CONSTRAINT fk_operation_region FOREIGN KEY (RegionID) REFERENCES RegionTbl(RegionID) ON DELETE CASCADE,
    CONSTRAINT uq_operation_code_company UNIQUE (OperationCode, CompanyID)
);

-- Create indexes for Operation table
CREATE INDEX idx_operation_company ON OperationTbl(CompanyID);
CREATE INDEX idx_operation_region ON OperationTbl(RegionID);
CREATE INDEX idx_operation_code ON OperationTbl(OperationCode);

-- Create trigger function to update the UpdatedAt timestamp
CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.UpdatedAt = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers for each table to update the UpdatedAt timestamp
CREATE TRIGGER update_company_timestamp
BEFORE UPDATE ON CompanyTbl
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_region_timestamp
BEFORE UPDATE ON RegionTbl
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_operation_timestamp
BEFORE UPDATE ON OperationTbl
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Add comments to tables and columns for documentation
COMMENT ON TABLE CompanyTbl IS 'Mining companies in the Mine to Mill Reconciliation System';
COMMENT ON COLUMN CompanyTbl.CompanyID IS 'Primary key for the company';
COMMENT ON COLUMN CompanyTbl.CompanyCode IS 'Unique code for the company (max 10 chars)';
COMMENT ON COLUMN CompanyTbl.CompanyDesc IS 'Description of the company (max 100 chars)';
COMMENT ON COLUMN CompanyTbl.ActiveCheck IS 'Flag indicating if the company is active';

COMMENT ON TABLE RegionTbl IS 'Geographic regions within mining companies';
COMMENT ON COLUMN RegionTbl.RegionID IS 'Primary key for the region';
COMMENT ON COLUMN RegionTbl.CompanyID IS 'Foreign key to the company that owns this region';
COMMENT ON COLUMN RegionTbl.RegionCode IS 'Code for the region (max 10 chars, unique within company)';
COMMENT ON COLUMN RegionTbl.RegionDesc IS 'Description of the region (max 100 chars)';
COMMENT ON COLUMN RegionTbl.ActiveCheck IS 'Flag indicating if the region is active';

COMMENT ON TABLE OperationTbl IS 'Mining operations within regions';
COMMENT ON COLUMN OperationTbl.OperationID IS 'Primary key for the operation';
COMMENT ON COLUMN OperationTbl.CompanyID IS 'Foreign key to the company that owns this operation';
COMMENT ON COLUMN OperationTbl.RegionID IS 'Foreign key to the region where this operation is located';
COMMENT ON COLUMN OperationTbl.OperationCode IS 'Code for the operation (max 10 chars, unique within company)';
COMMENT ON COLUMN OperationTbl.OperationDesc IS 'Description of the operation (max 100 chars)';
COMMENT ON COLUMN OperationTbl.ActiveCheck IS 'Flag indicating if the operation is active';

-- End of script 