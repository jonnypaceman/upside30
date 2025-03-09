-- Mine to Mill Reconciliation System
-- Seed Data Script: Period and Monthly Data
-- This script inserts seed data for the period and monthly data for January 2025

BEGIN;

-- Insert Period data for January 2025
INSERT INTO PeriodTbl (Year, Month, PeriodDesc, IsActive, IsClosed)
VALUES (2025, 1, 'January 2025', TRUE, FALSE);

-- Get the PeriodID for January 2025 and OperationID for KCGM
DO $$
DECLARE
    v_period_id INTEGER;
    v_operation_id INTEGER;
    v_upload_id INTEGER;
BEGIN
    SELECT PeriodID INTO v_period_id FROM PeriodTbl WHERE Year = 2025 AND Month = 1;
    SELECT OperationID INTO v_operation_id FROM OperationTbl WHERE OperationCode = 'KCGM';

    -- Insert Monthly Upload data
    INSERT INTO MonthlyUploadTbl (OperationID, PeriodID, UploadDate, UploadedBy, Status, Comments)
    VALUES (v_operation_id, v_period_id, CURRENT_TIMESTAMP, 'system', 'Validated', 'Initial seed data for testing')
    RETURNING UploadID INTO v_upload_id;

    -- Get IDs for ore sources, ore types, mine types, and stockpiles
    DECLARE
        -- Ore Source IDs
        v_fimiston_id INTEGER;
        v_underground_id INTEGER;
        v_other_id INTEGER;
        
        -- Ore Type IDs
        v_hg_id INTEGER;
        v_hh_id INTEGER;
        v_mh_id INTEGER;
        v_sg_id INTEGER;
        
        -- Mine Type IDs
        v_op_id INTEGER;
        v_ug_id INTEGER;
        v_hs_id INTEGER;
    BEGIN
        -- Get Ore Source IDs
        SELECT OreSourceID INTO v_fimiston_id FROM OreSourceTbl WHERE OreSourceCode = 'FIM' AND OperationID = v_operation_id;
        SELECT OreSourceID INTO v_underground_id FROM OreSourceTbl WHERE OreSourceCode = 'UG' AND OperationID = v_operation_id;
        SELECT OreSourceID INTO v_other_id FROM OreSourceTbl WHERE OreSourceCode = 'OTHER' AND OperationID = v_operation_id;
        
        -- Get Ore Type IDs
        SELECT OreTypeID INTO v_hg_id FROM OreTypeTbl WHERE OreTypeCode = 'HG' AND OperationID = v_operation_id;
        SELECT OreTypeID INTO v_hh_id FROM OreTypeTbl WHERE OreTypeCode = 'HH' AND OperationID = v_operation_id;
        SELECT OreTypeID INTO v_mh_id FROM OreTypeTbl WHERE OreTypeCode = 'MH' AND OperationID = v_operation_id;
        SELECT OreTypeID INTO v_sg_id FROM OreTypeTbl WHERE OreTypeCode = 'SG' AND OperationID = v_operation_id;
        
        -- Get Mine Type IDs
        SELECT MineTypeID INTO v_op_id FROM MineTypeTbl WHERE MineTypeCode = 'OP' AND OperationID = v_operation_id;
        SELECT MineTypeID INTO v_ug_id FROM MineTypeTbl WHERE MineTypeCode = 'UG' AND OperationID = v_operation_id;
        SELECT MineTypeID INTO v_hs_id FROM MineTypeTbl WHERE MineTypeCode = 'HS' AND OperationID = v_operation_id;

        -- Insert Satellite Stock data (sample entries)
        -- Underground Mines, HG, UG, PAD20_BAY1
        INSERT INTO SatelliteStockTbl (UploadID, OreSourceID, OreTypeID, MineTypeID, StockpileID, Tonnes, Grade, Ounces)
        SELECT 
            v_upload_id, 
            v_underground_id, 
            v_hg_id, 
            v_ug_id, 
            StockpileID, 
            3774, 
            0.884, 
            107.2618351
        FROM StockpileTbl 
        WHERE StockpileCode = 'PAD20_BAY1' AND OperationID = v_operation_id;

        -- Underground Mines, HG, UG, PAD20_BAY2
        INSERT INTO SatelliteStockTbl (UploadID, OreSourceID, OreTypeID, MineTypeID, StockpileID, Tonnes, Grade, Ounces)
        SELECT 
            v_upload_id, 
            v_underground_id, 
            v_hg_id, 
            v_ug_id, 
            StockpileID, 
            5570, 
            1.803, 
            322.8806241
        FROM StockpileTbl 
        WHERE StockpileCode = 'PAD20_BAY2' AND OperationID = v_operation_id;

        -- Fimiston, HH, HS, MORTY
        INSERT INTO SatelliteStockTbl (UploadID, OreSourceID, OreTypeID, MineTypeID, StockpileID, Tonnes, Grade, Ounces)
        SELECT 
            v_upload_id, 
            v_fimiston_id, 
            v_hh_id, 
            v_hs_id, 
            StockpileID, 
            2164379.9, 
            1.099932615, 
            76540.38353
        FROM StockpileTbl 
        WHERE StockpileCode = 'MORTY' AND OperationID = v_operation_id;

        -- Insert ROM Stock data (sample entries)
        -- Underground Mines, HG, UG, PAD12_BAY3
        INSERT INTO ROMStockTbl (UploadID, OreSourceID, OreTypeID, MineTypeID, StockpileID, Tonnes, Grade, Ounces)
        SELECT 
            v_upload_id, 
            v_underground_id, 
            v_hg_id, 
            v_ug_id, 
            StockpileID, 
            148.6185913, 
            1.529588013, 
            7.308675399
        FROM StockpileTbl 
        WHERE StockpileCode = 'PAD12_BAY3' AND OperationID = v_operation_id;

        -- Underground Mines, HG, UG, PAD12_BAY2_UG
        INSERT INTO ROMStockTbl (UploadID, OreSourceID, OreTypeID, MineTypeID, StockpileID, Tonnes, Grade, Ounces)
        SELECT 
            v_upload_id, 
            v_underground_id, 
            v_hg_id, 
            v_ug_id, 
            StockpileID, 
            1329, 
            1.78, 
            76.0564491
        FROM StockpileTbl 
        WHERE StockpileCode = 'PAD12_BAY2_UG' AND OperationID = v_operation_id;

        -- Insert CTG Stock data (sample entries)
        -- Underground Mines, HG, UG, CSI_OTG
        INSERT INTO CTGStockTbl (UploadID, OreSourceID, OreTypeID, MineTypeID, StockpileID, Tonnes, Grade, Ounces)
        SELECT 
            v_upload_id, 
            v_underground_id, 
            v_hg_id, 
            v_ug_id, 
            StockpileID, 
            8282.111607, 
            1.902006999, 
            506.4589514
        FROM StockpileTbl 
        WHERE StockpileCode = 'CSI_OTG' AND OperationID = v_operation_id;

        -- Fimiston, HG, OP, CSI_OTG
        INSERT INTO CTGStockTbl (UploadID, OreSourceID, OreTypeID, MineTypeID, StockpileID, Tonnes, Grade, Ounces)
        SELECT 
            v_upload_id, 
            v_fimiston_id, 
            v_hg_id, 
            v_op_id, 
            StockpileID, 
            12457.88839, 
            1.137506789, 
            455.6060636
        FROM StockpileTbl 
        WHERE StockpileCode = 'CSI_OTG' AND OperationID = v_operation_id;

        -- Insert COS Stock data (sample entries)
        -- Other, HH, HS, PRCOSP
        INSERT INTO COSStockTbl (UploadID, OreSourceID, OreTypeID, MineTypeID, StockpileID, Tonnes, Grade, Ounces)
        SELECT 
            v_upload_id, 
            v_other_id, 
            v_hh_id, 
            v_hs_id, 
            StockpileID, 
            39874, 
            1.633225041, 
            2093.759991
        FROM StockpileTbl 
        WHERE StockpileCode = 'PRCOSP' AND OperationID = v_operation_id;

        -- Fimiston, MH, HS, PRCOSP
        INSERT INTO COSStockTbl (UploadID, OreSourceID, OreTypeID, MineTypeID, StockpileID, Tonnes, Grade, Ounces)
        SELECT 
            v_upload_id, 
            v_fimiston_id, 
            v_mh_id, 
            v_hs_id, 
            StockpileID, 
            2907.241071, 
            1.137506789, 
            106.3227265
        FROM StockpileTbl 
        WHERE StockpileCode = 'PRCOSP' AND OperationID = v_operation_id;

        -- Insert SCT Stock data (sample entries)
        -- Other, HH, HS, CLEAN_SCAT_40
        INSERT INTO SCTStockTbl (UploadID, OreSourceID, OreTypeID, MineTypeID, StockpileID, Tonnes, Grade, Ounces)
        SELECT 
            v_upload_id, 
            v_other_id, 
            v_hh_id, 
            v_hs_id, 
            StockpileID, 
            332502, 
            0.98, 
            10476.38372
        FROM StockpileTbl 
        WHERE StockpileCode = 'CLEAN_SCAT_40' AND OperationID = v_operation_id;

        -- Underground Mines, HG, UG, CLEAN_SCAT_40
        INSERT INTO SCTStockTbl (UploadID, OreSourceID, OreTypeID, MineTypeID, StockpileID, Tonnes, Grade, Ounces)
        SELECT 
            v_upload_id, 
            v_underground_id, 
            v_hg_id, 
            v_ug_id, 
            StockpileID, 
            1064.764979, 
            1.90252454, 
            65.12910163
        FROM StockpileTbl 
        WHERE StockpileCode = 'CLEAN_SCAT_40' AND OperationID = v_operation_id;

        -- Insert Reconciliation Factors
        INSERT INTO ReconciliationFactorTbl (OperationID, PeriodID, FactorType, Value)
        VALUES 
            (v_operation_id, v_period_id, 'MineClaim', 0.95),
            (v_operation_id, v_period_id, 'MetalCall', 0.98);
    END;
END $$;

COMMIT; 