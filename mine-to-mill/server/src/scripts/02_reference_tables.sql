-- Mine to Mill Reconciliation System
-- Reference Tables
-- This script creates the reference tables for the Mine to Mill Reconciliation System.
-- These tables depend on the organization structure tables created in 01_organization_structure.sql.

-- Drop tables if they exist (in reverse order of dependencies)
DROP TABLE IF EXISTS StockpileTbl CASCADE;
DROP TABLE IF EXISTS MineZoneTbl CASCADE;
DROP TABLE IF EXISTS MineTbl CASCADE;
DROP TABLE IF EXISTS MineTypeTbl CASCADE;
DROP TABLE IF EXISTS OreTypeTbl CASCADE;
DROP TABLE IF EXISTS OreSourceTbl CASCADE;

-- Create OreSource table
CREATE TABLE OreSourceTbl (
    OreSourceID SERIAL PRIMARY KEY,
    OperationID INTEGER NOT NULL,
    OreSourceCode VARCHAR(10) NOT NULL,
    OreSourceDesc VARCHAR(100) NOT NULL,
    ActiveCheck BOOLEAN NOT NULL DEFAULT TRUE,
    CreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_oresource_operation FOREIGN KEY (OperationID) REFERENCES OperationTbl(OperationID) ON DELETE CASCADE,
    CONSTRAINT uq_oresource_code_operation UNIQUE (OreSourceCode, OperationID)
);

-- Create indexes for OreSource table
CREATE INDEX idx_oresource_operation ON OreSourceTbl(OperationID);
CREATE INDEX idx_oresource_code ON OreSourceTbl(OreSourceCode);

-- Create OreType table
CREATE TABLE OreTypeTbl (
    OreTypeID SERIAL PRIMARY KEY,
    OperationID INTEGER NOT NULL,
    OreTypeCode VARCHAR(10) NOT NULL,
    OreTypeDesc VARCHAR(100) NOT NULL,
    ActiveCheck BOOLEAN NOT NULL DEFAULT TRUE,
    CreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_oretype_operation FOREIGN KEY (OperationID) REFERENCES OperationTbl(OperationID) ON DELETE CASCADE,
    CONSTRAINT uq_oretype_code_operation UNIQUE (OreTypeCode, OperationID)
);

-- Create indexes for OreType table
CREATE INDEX idx_oretype_operation ON OreTypeTbl(OperationID);
CREATE INDEX idx_oretype_code ON OreTypeTbl(OreTypeCode);

-- Create MineType table
CREATE TABLE MineTypeTbl (
    MineTypeID SERIAL PRIMARY KEY,
    OperationID INTEGER NOT NULL,
    MineTypeCode VARCHAR(10) NOT NULL,
    MineTypeDesc VARCHAR(100) NOT NULL,
    ActiveCheck BOOLEAN NOT NULL DEFAULT TRUE,
    CreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_minetype_operation FOREIGN KEY (OperationID) REFERENCES OperationTbl(OperationID) ON DELETE CASCADE,
    CONSTRAINT uq_minetype_code_operation UNIQUE (MineTypeCode, OperationID)
);

-- Create indexes for MineType table
CREATE INDEX idx_minetype_operation ON MineTypeTbl(OperationID);
CREATE INDEX idx_minetype_code ON MineTypeTbl(MineTypeCode);

-- Create Mine table
CREATE TABLE MineTbl (
    MineID SERIAL PRIMARY KEY,
    OperationID INTEGER NOT NULL,
    OreSourceID INTEGER NOT NULL,
    MineCode VARCHAR(10) NOT NULL,
    MineDesc VARCHAR(100) NOT NULL,
    ActiveCheck BOOLEAN NOT NULL DEFAULT TRUE,
    CreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_mine_operation FOREIGN KEY (OperationID) REFERENCES OperationTbl(OperationID) ON DELETE CASCADE,
    CONSTRAINT fk_mine_oresource FOREIGN KEY (OreSourceID) REFERENCES OreSourceTbl(OreSourceID) ON DELETE CASCADE,
    CONSTRAINT uq_mine_code_operation UNIQUE (MineCode, OperationID)
);

-- Create indexes for Mine table
CREATE INDEX idx_mine_operation ON MineTbl(OperationID);
CREATE INDEX idx_mine_oresource ON MineTbl(OreSourceID);
CREATE INDEX idx_mine_code ON MineTbl(MineCode);

-- Create MineZone table
CREATE TABLE MineZoneTbl (
    MineZoneID SERIAL PRIMARY KEY,
    OperationID INTEGER NOT NULL,
    MineID INTEGER NOT NULL,
    MineZoneCode VARCHAR(10) NOT NULL,
    MineZoneDesc VARCHAR(100) NOT NULL,
    ActiveCheck BOOLEAN NOT NULL DEFAULT TRUE,
    CreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_minezone_operation FOREIGN KEY (OperationID) REFERENCES OperationTbl(OperationID) ON DELETE CASCADE,
    CONSTRAINT fk_minezone_mine FOREIGN KEY (MineID) REFERENCES MineTbl(MineID) ON DELETE CASCADE,
    CONSTRAINT uq_minezone_code_mine UNIQUE (MineZoneCode, MineID)
);

-- Create indexes for MineZone table
CREATE INDEX idx_minezone_operation ON MineZoneTbl(OperationID);
CREATE INDEX idx_minezone_mine ON MineZoneTbl(MineID);
CREATE INDEX idx_minezone_code ON MineZoneTbl(MineZoneCode);

-- Create Stockpile table
CREATE TABLE StockpileTbl (
    StockpileID SERIAL PRIMARY KEY,
    OperationID INTEGER NOT NULL,
    StockpileCode VARCHAR(10) NOT NULL,
    StockpileDesc VARCHAR(100) NOT NULL,
    NodeType VARCHAR(20) NOT NULL CHECK (NodeType IN ('ROM', 'Satellite', 'CTG', 'COS', 'SCT')),
    ActiveCheck BOOLEAN NOT NULL DEFAULT TRUE,
    CreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_stockpile_operation FOREIGN KEY (OperationID) REFERENCES OperationTbl(OperationID) ON DELETE CASCADE,
    CONSTRAINT uq_stockpile_code_operation UNIQUE (StockpileCode, OperationID)
);

-- Create indexes for Stockpile table
CREATE INDEX idx_stockpile_operation ON StockpileTbl(OperationID);
CREATE INDEX idx_stockpile_code ON StockpileTbl(StockpileCode);
CREATE INDEX idx_stockpile_nodetype ON StockpileTbl(NodeType);

-- Create triggers for each table to update the UpdatedAt timestamp
CREATE TRIGGER update_oresource_timestamp
BEFORE UPDATE ON OreSourceTbl
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_oretype_timestamp
BEFORE UPDATE ON OreTypeTbl
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_minetype_timestamp
BEFORE UPDATE ON MineTypeTbl
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_mine_timestamp
BEFORE UPDATE ON MineTbl
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_minezone_timestamp
BEFORE UPDATE ON MineZoneTbl
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_stockpile_timestamp
BEFORE UPDATE ON StockpileTbl
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Add comments to tables and columns for documentation
COMMENT ON TABLE OreSourceTbl IS 'Sources of ore in the mining operation';
COMMENT ON COLUMN OreSourceTbl.OreSourceID IS 'Primary key for the ore source';
COMMENT ON COLUMN OreSourceTbl.OperationID IS 'Foreign key to the operation this ore source belongs to';
COMMENT ON COLUMN OreSourceTbl.OreSourceCode IS 'Code for the ore source (max 10 chars, unique within operation)';
COMMENT ON COLUMN OreSourceTbl.OreSourceDesc IS 'Description of the ore source (max 100 chars)';
COMMENT ON COLUMN OreSourceTbl.ActiveCheck IS 'Flag indicating if the ore source is active';

COMMENT ON TABLE OreTypeTbl IS 'Types of ore in the mining operation';
COMMENT ON COLUMN OreTypeTbl.OreTypeID IS 'Primary key for the ore type';
COMMENT ON COLUMN OreTypeTbl.OperationID IS 'Foreign key to the operation this ore type belongs to';
COMMENT ON COLUMN OreTypeTbl.OreTypeCode IS 'Code for the ore type (max 10 chars, unique within operation)';
COMMENT ON COLUMN OreTypeTbl.OreTypeDesc IS 'Description of the ore type (max 100 chars)';
COMMENT ON COLUMN OreTypeTbl.ActiveCheck IS 'Flag indicating if the ore type is active';

COMMENT ON TABLE MineTypeTbl IS 'Types of mines in the mining operation';
COMMENT ON COLUMN MineTypeTbl.MineTypeID IS 'Primary key for the mine type';
COMMENT ON COLUMN MineTypeTbl.OperationID IS 'Foreign key to the operation this mine type belongs to';
COMMENT ON COLUMN MineTypeTbl.MineTypeCode IS 'Code for the mine type (max 10 chars, unique within operation)';
COMMENT ON COLUMN MineTypeTbl.MineTypeDesc IS 'Description of the mine type (max 100 chars)';
COMMENT ON COLUMN MineTypeTbl.ActiveCheck IS 'Flag indicating if the mine type is active';

COMMENT ON TABLE MineTbl IS 'Mines in the mining operation';
COMMENT ON COLUMN MineTbl.MineID IS 'Primary key for the mine';
COMMENT ON COLUMN MineTbl.OperationID IS 'Foreign key to the operation this mine belongs to';
COMMENT ON COLUMN MineTbl.OreSourceID IS 'Foreign key to the ore source of this mine';
COMMENT ON COLUMN MineTbl.MineCode IS 'Code for the mine (max 10 chars, unique within operation)';
COMMENT ON COLUMN MineTbl.MineDesc IS 'Description of the mine (max 100 chars)';
COMMENT ON COLUMN MineTbl.ActiveCheck IS 'Flag indicating if the mine is active';

COMMENT ON TABLE MineZoneTbl IS 'Zones within mines';
COMMENT ON COLUMN MineZoneTbl.MineZoneID IS 'Primary key for the mine zone';
COMMENT ON COLUMN MineZoneTbl.OperationID IS 'Foreign key to the operation this mine zone belongs to';
COMMENT ON COLUMN MineZoneTbl.MineID IS 'Foreign key to the mine this zone belongs to';
COMMENT ON COLUMN MineZoneTbl.MineZoneCode IS 'Code for the mine zone (max 10 chars, unique within mine)';
COMMENT ON COLUMN MineZoneTbl.MineZoneDesc IS 'Description of the mine zone (max 100 chars)';
COMMENT ON COLUMN MineZoneTbl.ActiveCheck IS 'Flag indicating if the mine zone is active';

COMMENT ON TABLE StockpileTbl IS 'Stockpiles in the mining operation';
COMMENT ON COLUMN StockpileTbl.StockpileID IS 'Primary key for the stockpile';
COMMENT ON COLUMN StockpileTbl.OperationID IS 'Foreign key to the operation this stockpile belongs to';
COMMENT ON COLUMN StockpileTbl.StockpileCode IS 'Code for the stockpile (max 10 chars, unique within operation)';
COMMENT ON COLUMN StockpileTbl.StockpileDesc IS 'Description of the stockpile (max 100 chars)';
COMMENT ON COLUMN StockpileTbl.NodeType IS 'Type of stockpile node (ROM, Satellite, CTG, COS, SCT)';
COMMENT ON COLUMN StockpileTbl.ActiveCheck IS 'Flag indicating if the stockpile is active';

-- End of script 