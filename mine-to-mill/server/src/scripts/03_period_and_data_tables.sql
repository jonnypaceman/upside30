-- Mine to Mill Reconciliation System
-- Period and Data Tracking Tables
-- This script creates the period and data tracking tables for the Mine to Mill Reconciliation System.
-- These tables depend on the organization structure and reference tables created in previous scripts.

-- Drop tables if they exist (in reverse order of dependencies)
DROP TABLE IF EXISTS SCTStockTbl CASCADE;
DROP TABLE IF EXISTS COSStockTbl CASCADE;
DROP TABLE IF EXISTS CTGStockTbl CASCADE;
DROP TABLE IF EXISTS ROMStockTbl CASCADE;
DROP TABLE IF EXISTS SatelliteStockTbl CASCADE;
DROP TABLE IF EXISTS MonthlyUploadTbl CASCADE;
DROP TABLE IF EXISTS PeriodTbl CASCADE;

-- Create Period table
CREATE TABLE PeriodTbl (
    PeriodID SERIAL PRIMARY KEY,
    Year INTEGER NOT NULL,
    Month INTEGER NOT NULL CHECK (Month BETWEEN 1 AND 12),
    PeriodDesc VARCHAR(50) NOT NULL,
    IsActive BOOLEAN NOT NULL DEFAULT TRUE,
    IsClosed BOOLEAN NOT NULL DEFAULT FALSE,
    CreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_period_year_month UNIQUE (Year, Month)
);

-- Create indexes for Period table
CREATE INDEX idx_period_year_month ON PeriodTbl(Year, Month);
CREATE INDEX idx_period_active ON PeriodTbl(IsActive);
CREATE INDEX idx_period_closed ON PeriodTbl(IsClosed);

-- Create MonthlyUpload table
CREATE TABLE MonthlyUploadTbl (
    UploadID SERIAL PRIMARY KEY,
    OperationID INTEGER NOT NULL,
    PeriodID INTEGER NOT NULL,
    UploadDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UploadedBy VARCHAR(100) NOT NULL,
    Status VARCHAR(20) NOT NULL CHECK (Status IN ('Pending', 'Validated', 'Processed', 'Approved', 'Rejected')),
    Comments TEXT,
    CreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_upload_operation FOREIGN KEY (OperationID) REFERENCES OperationTbl(OperationID) ON DELETE CASCADE,
    CONSTRAINT fk_upload_period FOREIGN KEY (PeriodID) REFERENCES PeriodTbl(PeriodID) ON DELETE CASCADE,
    CONSTRAINT uq_upload_operation_period UNIQUE (OperationID, PeriodID)
);

-- Create indexes for MonthlyUpload table
CREATE INDEX idx_upload_operation ON MonthlyUploadTbl(OperationID);
CREATE INDEX idx_upload_period ON MonthlyUploadTbl(PeriodID);
CREATE INDEX idx_upload_status ON MonthlyUploadTbl(Status);
CREATE INDEX idx_upload_date ON MonthlyUploadTbl(UploadDate);

-- Create SatelliteStock table
CREATE TABLE SatelliteStockTbl (
    SatelliteStockID SERIAL PRIMARY KEY,
    UploadID INTEGER NOT NULL,
    OreSourceID INTEGER NOT NULL,
    OreTypeID INTEGER NOT NULL,
    MineTypeID INTEGER NOT NULL,
    StockpileID INTEGER NOT NULL,
    Tonnes DECIMAL(12, 2) NOT NULL,
    Grade DECIMAL(8, 4) NOT NULL,
    Ounces DECIMAL(12, 4) NOT NULL,
    CreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_satstock_upload FOREIGN KEY (UploadID) REFERENCES MonthlyUploadTbl(UploadID) ON DELETE CASCADE,
    CONSTRAINT fk_satstock_oresource FOREIGN KEY (OreSourceID) REFERENCES OreSourceTbl(OreSourceID) ON DELETE CASCADE,
    CONSTRAINT fk_satstock_oretype FOREIGN KEY (OreTypeID) REFERENCES OreTypeTbl(OreTypeID) ON DELETE CASCADE,
    CONSTRAINT fk_satstock_minetype FOREIGN KEY (MineTypeID) REFERENCES MineTypeTbl(MineTypeID) ON DELETE CASCADE,
    CONSTRAINT fk_satstock_stockpile FOREIGN KEY (StockpileID) REFERENCES StockpileTbl(StockpileID) ON DELETE CASCADE,
    CONSTRAINT check_satstock_stockpile_type CHECK (
        EXISTS (
            SELECT 1 FROM StockpileTbl 
            WHERE StockpileID = SatelliteStockTbl.StockpileID 
            AND NodeType = 'Satellite'
        )
    )
);

-- Create indexes for SatelliteStock table
CREATE INDEX idx_satstock_upload ON SatelliteStockTbl(UploadID);
CREATE INDEX idx_satstock_oresource ON SatelliteStockTbl(OreSourceID);
CREATE INDEX idx_satstock_oretype ON SatelliteStockTbl(OreTypeID);
CREATE INDEX idx_satstock_minetype ON SatelliteStockTbl(MineTypeID);
CREATE INDEX idx_satstock_stockpile ON SatelliteStockTbl(StockpileID);

-- Create ROMStock table
CREATE TABLE ROMStockTbl (
    ROMStockID SERIAL PRIMARY KEY,
    UploadID INTEGER NOT NULL,
    OreSourceID INTEGER NOT NULL,
    OreTypeID INTEGER NOT NULL,
    MineTypeID INTEGER NOT NULL,
    StockpileID INTEGER NOT NULL,
    Tonnes DECIMAL(12, 2) NOT NULL,
    Grade DECIMAL(8, 4) NOT NULL,
    Ounces DECIMAL(12, 4) NOT NULL,
    CreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_romstock_upload FOREIGN KEY (UploadID) REFERENCES MonthlyUploadTbl(UploadID) ON DELETE CASCADE,
    CONSTRAINT fk_romstock_oresource FOREIGN KEY (OreSourceID) REFERENCES OreSourceTbl(OreSourceID) ON DELETE CASCADE,
    CONSTRAINT fk_romstock_oretype FOREIGN KEY (OreTypeID) REFERENCES OreTypeTbl(OreTypeID) ON DELETE CASCADE,
    CONSTRAINT fk_romstock_minetype FOREIGN KEY (MineTypeID) REFERENCES MineTypeTbl(MineTypeID) ON DELETE CASCADE,
    CONSTRAINT fk_romstock_stockpile FOREIGN KEY (StockpileID) REFERENCES StockpileTbl(StockpileID) ON DELETE CASCADE,
    CONSTRAINT check_romstock_stockpile_type CHECK (
        EXISTS (
            SELECT 1 FROM StockpileTbl 
            WHERE StockpileID = ROMStockTbl.StockpileID 
            AND NodeType = 'ROM'
        )
    )
);

-- Create indexes for ROMStock table
CREATE INDEX idx_romstock_upload ON ROMStockTbl(UploadID);
CREATE INDEX idx_romstock_oresource ON ROMStockTbl(OreSourceID);
CREATE INDEX idx_romstock_oretype ON ROMStockTbl(OreTypeID);
CREATE INDEX idx_romstock_minetype ON ROMStockTbl(MineTypeID);
CREATE INDEX idx_romstock_stockpile ON ROMStockTbl(StockpileID);

-- Create CTGStock table
CREATE TABLE CTGStockTbl (
    CTGStockID SERIAL PRIMARY KEY,
    UploadID INTEGER NOT NULL,
    OreSourceID INTEGER NOT NULL,
    OreTypeID INTEGER NOT NULL,
    MineTypeID INTEGER NOT NULL,
    StockpileID INTEGER NOT NULL,
    Tonnes DECIMAL(12, 2) NOT NULL,
    Grade DECIMAL(8, 4) NOT NULL,
    Ounces DECIMAL(12, 4) NOT NULL,
    CreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_ctgstock_upload FOREIGN KEY (UploadID) REFERENCES MonthlyUploadTbl(UploadID) ON DELETE CASCADE,
    CONSTRAINT fk_ctgstock_oresource FOREIGN KEY (OreSourceID) REFERENCES OreSourceTbl(OreSourceID) ON DELETE CASCADE,
    CONSTRAINT fk_ctgstock_oretype FOREIGN KEY (OreTypeID) REFERENCES OreTypeTbl(OreTypeID) ON DELETE CASCADE,
    CONSTRAINT fk_ctgstock_minetype FOREIGN KEY (MineTypeID) REFERENCES MineTypeTbl(MineTypeID) ON DELETE CASCADE,
    CONSTRAINT fk_ctgstock_stockpile FOREIGN KEY (StockpileID) REFERENCES StockpileTbl(StockpileID) ON DELETE CASCADE,
    CONSTRAINT check_ctgstock_stockpile_type CHECK (
        EXISTS (
            SELECT 1 FROM StockpileTbl 
            WHERE StockpileID = CTGStockTbl.StockpileID 
            AND NodeType = 'CTG'
        )
    )
);

-- Create indexes for CTGStock table
CREATE INDEX idx_ctgstock_upload ON CTGStockTbl(UploadID);
CREATE INDEX idx_ctgstock_oresource ON CTGStockTbl(OreSourceID);
CREATE INDEX idx_ctgstock_oretype ON CTGStockTbl(OreTypeID);
CREATE INDEX idx_ctgstock_minetype ON CTGStockTbl(MineTypeID);
CREATE INDEX idx_ctgstock_stockpile ON CTGStockTbl(StockpileID);

-- Create COSStock table
CREATE TABLE COSStockTbl (
    COSStockID SERIAL PRIMARY KEY,
    UploadID INTEGER NOT NULL,
    OreSourceID INTEGER NOT NULL,
    OreTypeID INTEGER NOT NULL,
    MineTypeID INTEGER NOT NULL,
    StockpileID INTEGER NOT NULL,
    Tonnes DECIMAL(12, 2) NOT NULL,
    Grade DECIMAL(8, 4) NOT NULL,
    Ounces DECIMAL(12, 4) NOT NULL,
    CreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_cosstock_upload FOREIGN KEY (UploadID) REFERENCES MonthlyUploadTbl(UploadID) ON DELETE CASCADE,
    CONSTRAINT fk_cosstock_oresource FOREIGN KEY (OreSourceID) REFERENCES OreSourceTbl(OreSourceID) ON DELETE CASCADE,
    CONSTRAINT fk_cosstock_oretype FOREIGN KEY (OreTypeID) REFERENCES OreTypeTbl(OreTypeID) ON DELETE CASCADE,
    CONSTRAINT fk_cosstock_minetype FOREIGN KEY (MineTypeID) REFERENCES MineTypeTbl(MineTypeID) ON DELETE CASCADE,
    CONSTRAINT fk_cosstock_stockpile FOREIGN KEY (StockpileID) REFERENCES StockpileTbl(StockpileID) ON DELETE CASCADE,
    CONSTRAINT check_cosstock_stockpile_type CHECK (
        EXISTS (
            SELECT 1 FROM StockpileTbl 
            WHERE StockpileID = COSStockTbl.StockpileID 
            AND NodeType = 'COS'
        )
    )
);

-- Create indexes for COSStock table
CREATE INDEX idx_cosstock_upload ON COSStockTbl(UploadID);
CREATE INDEX idx_cosstock_oresource ON COSStockTbl(OreSourceID);
CREATE INDEX idx_cosstock_oretype ON COSStockTbl(OreTypeID);
CREATE INDEX idx_cosstock_minetype ON COSStockTbl(MineTypeID);
CREATE INDEX idx_cosstock_stockpile ON COSStockTbl(StockpileID);

-- Create SCTStock table
CREATE TABLE SCTStockTbl (
    SCTStockID SERIAL PRIMARY KEY,
    UploadID INTEGER NOT NULL,
    OreSourceID INTEGER NOT NULL,
    OreTypeID INTEGER NOT NULL,
    MineTypeID INTEGER NOT NULL,
    StockpileID INTEGER NOT NULL,
    Tonnes DECIMAL(12, 2) NOT NULL,
    Grade DECIMAL(8, 4) NOT NULL,
    Ounces DECIMAL(12, 4) NOT NULL,
    CreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_sctstock_upload FOREIGN KEY (UploadID) REFERENCES MonthlyUploadTbl(UploadID) ON DELETE CASCADE,
    CONSTRAINT fk_sctstock_oresource FOREIGN KEY (OreSourceID) REFERENCES OreSourceTbl(OreSourceID) ON DELETE CASCADE,
    CONSTRAINT fk_sctstock_oretype FOREIGN KEY (OreTypeID) REFERENCES OreTypeTbl(OreTypeID) ON DELETE CASCADE,
    CONSTRAINT fk_sctstock_minetype FOREIGN KEY (MineTypeID) REFERENCES MineTypeTbl(MineTypeID) ON DELETE CASCADE,
    CONSTRAINT fk_sctstock_stockpile FOREIGN KEY (StockpileID) REFERENCES StockpileTbl(StockpileID) ON DELETE CASCADE,
    CONSTRAINT check_sctstock_stockpile_type CHECK (
        EXISTS (
            SELECT 1 FROM StockpileTbl 
            WHERE StockpileID = SCTStockTbl.StockpileID 
            AND NodeType = 'SCT'
        )
    )
);

-- Create indexes for SCTStock table
CREATE INDEX idx_sctstock_upload ON SCTStockTbl(UploadID);
CREATE INDEX idx_sctstock_oresource ON SCTStockTbl(OreSourceID);
CREATE INDEX idx_sctstock_oretype ON SCTStockTbl(OreTypeID);
CREATE INDEX idx_sctstock_minetype ON SCTStockTbl(MineTypeID);
CREATE INDEX idx_sctstock_stockpile ON SCTStockTbl(StockpileID);

-- Create ReconciliationFactor table
CREATE TABLE ReconciliationFactorTbl (
    ReconciliationFactorID SERIAL PRIMARY KEY,
    OperationID INTEGER NOT NULL,
    PeriodID INTEGER NOT NULL,
    FactorType VARCHAR(20) NOT NULL CHECK (FactorType IN ('MineClaim', 'MetalCall')),
    Value DECIMAL(8, 4) NOT NULL,
    CreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_factor_operation FOREIGN KEY (OperationID) REFERENCES OperationTbl(OperationID) ON DELETE CASCADE,
    CONSTRAINT fk_factor_period FOREIGN KEY (PeriodID) REFERENCES PeriodTbl(PeriodID) ON DELETE CASCADE,
    CONSTRAINT uq_factor_operation_period_type UNIQUE (OperationID, PeriodID, FactorType)
);

-- Create indexes for ReconciliationFactor table
CREATE INDEX idx_factor_operation ON ReconciliationFactorTbl(OperationID);
CREATE INDEX idx_factor_period ON ReconciliationFactorTbl(PeriodID);
CREATE INDEX idx_factor_type ON ReconciliationFactorTbl(FactorType);

-- Create triggers for each table to update the UpdatedAt timestamp
CREATE TRIGGER update_period_timestamp
BEFORE UPDATE ON PeriodTbl
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_upload_timestamp
BEFORE UPDATE ON MonthlyUploadTbl
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_satstock_timestamp
BEFORE UPDATE ON SatelliteStockTbl
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_romstock_timestamp
BEFORE UPDATE ON ROMStockTbl
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_ctgstock_timestamp
BEFORE UPDATE ON CTGStockTbl
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_cosstock_timestamp
BEFORE UPDATE ON COSStockTbl
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_sctstock_timestamp
BEFORE UPDATE ON SCTStockTbl
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_factor_timestamp
BEFORE UPDATE ON ReconciliationFactorTbl
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Add comments to tables and columns for documentation
COMMENT ON TABLE PeriodTbl IS 'Time periods for data tracking (monthly)';
COMMENT ON COLUMN PeriodTbl.PeriodID IS 'Primary key for the period';
COMMENT ON COLUMN PeriodTbl.Year IS 'Year of the period';
COMMENT ON COLUMN PeriodTbl.Month IS 'Month of the period (1-12)';
COMMENT ON COLUMN PeriodTbl.PeriodDesc IS 'Description of the period (e.g., "January 2024")';
COMMENT ON COLUMN PeriodTbl.IsActive IS 'Flag indicating if the period is active for data entry';
COMMENT ON COLUMN PeriodTbl.IsClosed IS 'Flag indicating if the period is closed for editing';

COMMENT ON TABLE MonthlyUploadTbl IS 'Monthly data uploads for each operation';
COMMENT ON COLUMN MonthlyUploadTbl.UploadID IS 'Primary key for the upload';
COMMENT ON COLUMN MonthlyUploadTbl.OperationID IS 'Foreign key to the operation this upload belongs to';
COMMENT ON COLUMN MonthlyUploadTbl.PeriodID IS 'Foreign key to the period this upload belongs to';
COMMENT ON COLUMN MonthlyUploadTbl.UploadDate IS 'Date and time of the upload';
COMMENT ON COLUMN MonthlyUploadTbl.UploadedBy IS 'User who performed the upload';
COMMENT ON COLUMN MonthlyUploadTbl.Status IS 'Status of the upload (Pending, Validated, Processed, Approved, Rejected)';
COMMENT ON COLUMN MonthlyUploadTbl.Comments IS 'Optional comments about the upload';

COMMENT ON TABLE SatelliteStockTbl IS 'Satellite stockpile data for monthly uploads';
COMMENT ON COLUMN SatelliteStockTbl.SatelliteStockID IS 'Primary key for the satellite stockpile data';
COMMENT ON COLUMN SatelliteStockTbl.UploadID IS 'Foreign key to the monthly upload';
COMMENT ON COLUMN SatelliteStockTbl.OreSourceID IS 'Foreign key to the ore source';
COMMENT ON COLUMN SatelliteStockTbl.OreTypeID IS 'Foreign key to the ore type';
COMMENT ON COLUMN SatelliteStockTbl.MineTypeID IS 'Foreign key to the mine type';
COMMENT ON COLUMN SatelliteStockTbl.StockpileID IS 'Foreign key to the stockpile';
COMMENT ON COLUMN SatelliteStockTbl.Tonnes IS 'Tonnage of material in the stockpile';
COMMENT ON COLUMN SatelliteStockTbl.Grade IS 'Grade of material in the stockpile';
COMMENT ON COLUMN SatelliteStockTbl.Ounces IS 'Ounces of gold in the stockpile';

COMMENT ON TABLE ROMStockTbl IS 'ROM stockpile data for monthly uploads';
COMMENT ON COLUMN ROMStockTbl.ROMStockID IS 'Primary key for the ROM stockpile data';
COMMENT ON COLUMN ROMStockTbl.UploadID IS 'Foreign key to the monthly upload';
COMMENT ON COLUMN ROMStockTbl.OreSourceID IS 'Foreign key to the ore source';
COMMENT ON COLUMN ROMStockTbl.OreTypeID IS 'Foreign key to the ore type';
COMMENT ON COLUMN ROMStockTbl.MineTypeID IS 'Foreign key to the mine type';
COMMENT ON COLUMN ROMStockTbl.StockpileID IS 'Foreign key to the stockpile';
COMMENT ON COLUMN ROMStockTbl.Tonnes IS 'Tonnage of material in the stockpile';
COMMENT ON COLUMN ROMStockTbl.Grade IS 'Grade of material in the stockpile';
COMMENT ON COLUMN ROMStockTbl.Ounces IS 'Ounces of gold in the stockpile';

COMMENT ON TABLE CTGStockTbl IS 'CTG stockpile data for monthly uploads';
COMMENT ON COLUMN CTGStockTbl.CTGStockID IS 'Primary key for the CTG stockpile data';
COMMENT ON COLUMN CTGStockTbl.UploadID IS 'Foreign key to the monthly upload';
COMMENT ON COLUMN CTGStockTbl.OreSourceID IS 'Foreign key to the ore source';
COMMENT ON COLUMN CTGStockTbl.OreTypeID IS 'Foreign key to the ore type';
COMMENT ON COLUMN CTGStockTbl.MineTypeID IS 'Foreign key to the mine type';
COMMENT ON COLUMN CTGStockTbl.StockpileID IS 'Foreign key to the stockpile';
COMMENT ON COLUMN CTGStockTbl.Tonnes IS 'Tonnage of material in the stockpile';
COMMENT ON COLUMN CTGStockTbl.Grade IS 'Grade of material in the stockpile';
COMMENT ON COLUMN CTGStockTbl.Ounces IS 'Ounces of gold in the stockpile';

COMMENT ON TABLE COSStockTbl IS 'COS stockpile data for monthly uploads';
COMMENT ON COLUMN COSStockTbl.COSStockID IS 'Primary key for the COS stockpile data';
COMMENT ON COLUMN COSStockTbl.UploadID IS 'Foreign key to the monthly upload';
COMMENT ON COLUMN COSStockTbl.OreSourceID IS 'Foreign key to the ore source';
COMMENT ON COLUMN COSStockTbl.OreTypeID IS 'Foreign key to the ore type';
COMMENT ON COLUMN COSStockTbl.MineTypeID IS 'Foreign key to the mine type';
COMMENT ON COLUMN COSStockTbl.StockpileID IS 'Foreign key to the stockpile';
COMMENT ON COLUMN COSStockTbl.Tonnes IS 'Tonnage of material in the stockpile';
COMMENT ON COLUMN COSStockTbl.Grade IS 'Grade of material in the stockpile';
COMMENT ON COLUMN COSStockTbl.Ounces IS 'Ounces of gold in the stockpile';

COMMENT ON TABLE SCTStockTbl IS 'SCT stockpile data for monthly uploads';
COMMENT ON COLUMN SCTStockTbl.SCTStockID IS 'Primary key for the SCT stockpile data';
COMMENT ON COLUMN SCTStockTbl.UploadID IS 'Foreign key to the monthly upload';
COMMENT ON COLUMN SCTStockTbl.OreSourceID IS 'Foreign key to the ore source';
COMMENT ON COLUMN SCTStockTbl.OreTypeID IS 'Foreign key to the ore type';
COMMENT ON COLUMN SCTStockTbl.MineTypeID IS 'Foreign key to the mine type';
COMMENT ON COLUMN SCTStockTbl.StockpileID IS 'Foreign key to the stockpile';
COMMENT ON COLUMN SCTStockTbl.Tonnes IS 'Tonnage of material in the stockpile';
COMMENT ON COLUMN SCTStockTbl.Grade IS 'Grade of material in the stockpile';
COMMENT ON COLUMN SCTStockTbl.Ounces IS 'Ounces of gold in the stockpile';

COMMENT ON TABLE ReconciliationFactorTbl IS 'Reconciliation factors for each operation and period';
COMMENT ON COLUMN ReconciliationFactorTbl.ReconciliationFactorID IS 'Primary key for the reconciliation factor';
COMMENT ON COLUMN ReconciliationFactorTbl.OperationID IS 'Foreign key to the operation';
COMMENT ON COLUMN ReconciliationFactorTbl.PeriodID IS 'Foreign key to the period';
COMMENT ON COLUMN ReconciliationFactorTbl.FactorType IS 'Type of reconciliation factor (MineClaim, MetalCall)';
COMMENT ON COLUMN ReconciliationFactorTbl.Value IS 'Value of the reconciliation factor';

-- End of script 