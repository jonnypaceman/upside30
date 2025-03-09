-- Mine to Mill Reconciliation System
-- Seed Data Script: Reference Tables
-- This script inserts seed data for the reference tables based on the KCGM operation

BEGIN;

    -- Get the OperationID for KCGM
    DO $$
    DECLARE
    v_operation_id INTEGER;
BEGIN
    SELECT OperationID
    INTO v_operation_id
    FROM OperationTbl
    WHERE OperationCode = 'KCGM';

    -- Insert Ore Source data
    INSERT INTO OreSourceTbl
        (OperationID, OreSourceCode, OreSourceDesc, ActiveCheck)
    VALUES
        (v_operation_id, 'FIM', 'Fimiston', TRUE),
        (v_operation_id, 'UG', 'Underground Mines', TRUE),
        (v_operation_id, 'OTHER', 'Other', TRUE);

    -- Insert Ore Type data
    INSERT INTO OreTypeTbl
        (OperationID, OreTypeCode, OreTypeDesc, ActiveCheck)
    VALUES
        (v_operation_id, 'HG', 'High Grade', TRUE),
        (v_operation_id, 'HH', 'High-High Grade', TRUE),
        (v_operation_id, 'MH', 'Medium-High Grade', TRUE),
        (v_operation_id, 'SG', 'Sub Grade', TRUE);

    -- Insert Mine Type data
    INSERT INTO MineTypeTbl
        (OperationID, MineTypeCode, MineTypeDesc, ActiveCheck)
    VALUES
        (v_operation_id, 'OP', 'Open Pit', TRUE),
        (v_operation_id, 'UG', 'Underground', TRUE),
        (v_operation_id, 'HS', 'Historical Stockpile', TRUE);

    -- Get OreSourceID for Fimiston and Underground
    DECLARE
        v_fimiston_id INTEGER;
v_underground_id INTEGER;
        v_other_id INTEGER;
BEGIN
    SELECT OreSourceID
    INTO v_fimiston_id
    FROM OreSourceTbl
    WHERE OreSourceCode = 'FIM' AND OperationID = v_operation_id;
    SELECT OreSourceID
    INTO v_underground_id
    FROM OreSourceTbl
    WHERE OreSourceCode = 'UG' AND OperationID = v_operation_id;
    SELECT OreSourceID
    INTO v_other_id
    FROM OreSourceTbl
    WHERE OreSourceCode = 'OTHER' AND OperationID = v_operation_id;

    -- Insert Mine data
    INSERT INTO MineTbl
        (OperationID, OreSourceID, MineCode, MineDesc, ActiveCheck)
    VALUES
        (v_operation_id, v_fimiston_id, 'FIMOP', 'Fimiston Open Pit', TRUE),
        (v_operation_id, v_underground_id, 'MTCUG', 'Mount Charlotte Underground', TRUE),
        (v_operation_id, v_underground_id, 'FIMUG', 'Fimiston Underground', TRUE);

    -- Get MineID for Fimiston Open Pit
    DECLARE
            v_fimiston_op_id INTEGER;
v_mtc_ug_id INTEGER;
            v_fimiston_ug_id INTEGER;
BEGIN
    SELECT MineID
    INTO v_fimiston_op_id
    FROM MineTbl
    WHERE MineCode = 'FIMOP' AND OperationID = v_operation_id;
    SELECT MineID
    INTO v_mtc_ug_id
    FROM MineTbl
    WHERE MineCode = 'MTCUG' AND OperationID = v_operation_id;
    SELECT MineID
    INTO v_fimiston_ug_id
    FROM MineTbl
    WHERE MineCode = 'FIMUG' AND OperationID = v_operation_id;

    -- Insert Mine Zone data
    INSERT INTO MineZoneTbl
        (OperationID, MineID, MineZoneCode, MineZoneDesc, ActiveCheck)
    VALUES
        (v_operation_id, v_fimiston_op_id, 'OBH1', 'Oroya Brownhill 1', TRUE),
        (v_operation_id, v_fimiston_op_id, 'GtB', 'Golden Pike', TRUE),
        (v_operation_id, v_fimiston_op_id, 'GP', 'Golden Pike', TRUE),
        (v_operation_id, v_mtc_ug_id, 'MTC', 'Mount Charlotte', TRUE),
        (v_operation_id, v_mtc_ug_id, 'HS', 'Historical Stopes', TRUE),
        (v_operation_id, v_mtc_ug_id, 'FP', 'Flanagan Pit', TRUE),
        (v_operation_id, v_mtc_ug_id, 'LWS', 'Lower Western Stopes', TRUE),
        (v_operation_id, v_mtc_ug_id, 'ROB2', 'Reward Orebody 2', TRUE),
        (v_operation_id, v_mtc_ug_id, 'NOB', 'Northern Orebody', TRUE),
        (v_operation_id, v_mtc_ug_id, 'MTF', 'Mount Charlotte Fault', TRUE),
        (v_operation_id, v_fimiston_ug_id, 'FIM', 'Fimiston', TRUE),
        (v_operation_id, v_fimiston_ug_id, 'GP', 'Golden Pike', TRUE);
END;
END;

-- Insert Stockpile data
-- Satellite Stockpiles
INSERT INTO StockpileTbl
    (OperationID, StockpileCode, StockpileDesc, NodeType, ActiveCheck)
VALUES
    (v_operation_id, 'PAD20_BAY1', 'Pad 20 Bay 1', 'Satellite', TRUE),
    (v_operation_id, 'PAD20_BAY2', 'Pad 20 Bay 2', 'Satellite', TRUE),
    (v_operation_id, 'MORTY', 'Morty Stockpile', 'Satellite', TRUE),
    (v_operation_id, 'DODDS', 'Dodds Stockpile', 'Satellite', TRUE),
    (v_operation_id, 'MENDINIDI', 'Mendinidi Stockpile', 'Satellite', TRUE),
    (v_operation_id, 'TSG8', 'TSG8 Stockpile', 'Satellite', TRUE),
    (v_operation_id, 'DM85', 'DM85 Stockpile', 'Satellite', TRUE),
    (v_operation_id, 'SM8', 'SM8 Stockpile', 'Satellite', TRUE),
    (v_operation_id, 'SM6', 'SM6 Stockpile', 'Satellite', TRUE),
    (v_operation_id, 'SM4', 'SM4 Stockpile', 'Satellite', TRUE),
    (v_operation_id, 'SM3', 'SM3 Stockpile', 'Satellite', TRUE),
    (v_operation_id, 'SM_SG', 'SM Subgrade Stockpile', 'Satellite', TRUE),
    (v_operation_id, 'SM_FINES_50MM', 'SM Fines 50MM Stockpile', 'Satellite', TRUE),
    (v_operation_id, 'SM_TAILS', 'SM Tails Stockpile', 'Satellite', TRUE),
    (v_operation_id, 'MS3', 'MS3 Stockpile', 'Satellite', TRUE),
    (v_operation_id, 'P3DEADLODE_M', 'P3 Deadlode M Stockpile', 'Satellite', TRUE),
    (v_operation_id, 'TS2_SUBGRADE', 'TS2 Subgrade Stockpile', 'Satellite', TRUE),
    (v_operation_id, 'TS2', 'TS2 Stockpile', 'Satellite', TRUE),
    (v_operation_id, 'PRDEADLODE', 'PR Deadlode Stockpile', 'Satellite', TRUE),
    (v_operation_id, 'DM6', 'DM6 Stockpile', 'Satellite', TRUE),
    (v_operation_id, 'DM_10', 'DM 10 Stockpile', 'Satellite', TRUE),
    (v_operation_id, 'SG9', 'SG9 Stockpile', 'Satellite', TRUE),
    (v_operation_id, 'DM_5', 'DM 5 Stockpile', 'Satellite', TRUE),
    (v_operation_id, 'DM_6', 'DM 6 Stockpile', 'Satellite', TRUE),
    (v_operation_id, 'DM5_5', 'DM5.5 Stockpile', 'Satellite', TRUE),
    (v_operation_id, 'DM6_5', 'DM6.5 Stockpile', 'Satellite', TRUE),
    (v_operation_id, 'DM7', 'DM7 Stockpile', 'Satellite', TRUE),
    (v_operation_id, 'DM7_5', 'DM7.5 Stockpile', 'Satellite', TRUE),
    (v_operation_id, 'DM8', 'DM8 Stockpile', 'Satellite', TRUE),
    (v_operation_id, 'DM9_27RL', 'DM9 27RL Stockpile', 'Satellite', TRUE),
    (v_operation_id, 'LG3_DEADLODE', 'LG3 Deadlode Stockpile', 'Satellite', TRUE),
    (v_operation_id, 'SG7', 'SG7 Stockpile', 'Satellite', TRUE),
    (v_operation_id, 'TS2W', 'TS2W Stockpile', 'Satellite', TRUE),
    (v_operation_id, 'TS3', 'TS3 Stockpile', 'Satellite', TRUE),
    (v_operation_id, 'TS3W', 'TS3W Stockpile', 'Satellite', TRUE),
    (v_operation_id, 'TS4W', 'TS4W Stockpile', 'Satellite', TRUE),
    (v_operation_id, 'TS6W', 'TS6W Stockpile', 'Satellite', TRUE),
    (v_operation_id, 'TSB2', 'TSB2 Stockpile', 'Satellite', TRUE),
    (v_operation_id, 'TSB3', 'TSB3 Stockpile', 'Satellite', TRUE),
    (v_operation_id, 'TSB3SOUTH', 'TSB3 South Stockpile', 'Satellite', TRUE),
    (v_operation_id, 'TSC3SOUTH', 'TSC3 South Stockpile', 'Satellite', TRUE),
    (v_operation_id, 'TSG6', 'TSG6 Stockpile', 'Satellite', TRUE),
    (v_operation_id, 'TSG6_5', 'TSG6.5 Stockpile', 'Satellite', TRUE),
    (v_operation_id, 'TSG7', 'TSG7 Stockpile', 'Satellite', TRUE),
    (v_operation_id, 'TSG7_5', 'TSG7.5 Stockpile', 'Satellite', TRUE);

-- ROM Stockpiles
INSERT INTO StockpileTbl
    (OperationID, StockpileCode, StockpileDesc, NodeType, ActiveCheck)
VALUES
    (v_operation_id, 'PAD12_BAY3', 'Pad 12 Bay 3', 'ROM', TRUE),
    (v_operation_id, 'PAD12_BAY2_UG', 'Pad 12 Bay 2 UG', 'ROM', TRUE),
    (v_operation_id, 'PAD14', 'Pad 14', 'ROM', TRUE),
    (v_operation_id, 'HG_PYRRHOTITE_SP#2', 'HG Pyrrhotite Stockpile #2', 'ROM', TRUE),
    (v_operation_id, 'TEMPORE2', 'Temporary Ore 2', 'ROM', TRUE),
    (v_operation_id, 'TEMPORE1', 'Temporary Ore 1', 'ROM', TRUE),
    (v_operation_id, 'BF_SUSPECT_HG', 'BF Suspect HG', 'ROM', TRUE),
    (v_operation_id, 'BFS_OS', 'BFS OS', 'ROM', TRUE),
    (v_operation_id, 'CLEAN_STICKS', 'Clean Sticks', 'ROM', TRUE),
    (v_operation_id, 'HG_PYRRHOTITE_SP', 'HG Pyrrhotite Stockpile', 'ROM', TRUE),
    (v_operation_id, 'PAD3_BAY5', 'Pad 3 Bay 5', 'ROM', TRUE),
    (v_operation_id, 'SM_27', 'SM 27', 'ROM', TRUE),
    (v_operation_id, 'PAD7_BAY2', 'Pad 7 Bay 2', 'ROM', TRUE),
    (v_operation_id, 'PAD7_BAY1', 'Pad 7 Bay 1', 'ROM', TRUE),
    (v_operation_id, 'PAD12_BAY4', 'Pad 12 Bay 4', 'ROM', TRUE),
    (v_operation_id, 'PAD3_BAY3', 'Pad 3 Bay 3', 'ROM', TRUE),
    (v_operation_id, 'PAD7_BAY5_UG', 'Pad 7 Bay 5 UG', 'ROM', TRUE),
    (v_operation_id, 'PAD3_BAY2', 'Pad 3 Bay 2', 'ROM', TRUE);

-- CTG Stockpiles
INSERT INTO StockpileTbl
    (OperationID, StockpileCode, StockpileDesc, NodeType, ActiveCheck)
VALUES
    (v_operation_id, 'CSI_OTG', 'CSI OTG', 'CTG', TRUE),
    (v_operation_id, 'SQ_SPILE_2', 'SQ Spile 2', 'CTG', TRUE),
    (v_operation_id, 'SQ_SPILE', 'SQ Spile', 'CTG', TRUE);

-- COS Stockpiles
INSERT INTO StockpileTbl
    (OperationID, StockpileCode, StockpileDesc, NodeType, ActiveCheck)
VALUES
    (v_operation_id, 'PRCOSP', 'PR Crushed Ore Stockpile', 'COS', TRUE),
    (v_operation_id, 'COSP', 'Crushed Ore Stockpile', 'COS', TRUE);

-- SCT Stockpiles
INSERT INTO StockpileTbl
    (OperationID, StockpileCode, StockpileDesc, NodeType, ActiveCheck)
VALUES
    (v_operation_id, 'CLEAN_SCAT_40', 'Clean Scats 40', 'SCT', TRUE),
    (v_operation_id, 'DIRTY_SCAT_40', 'Dirty Scats 40', 'SCT', TRUE),
    (v_operation_id, 'DIRTY_SCAT_40B', 'Dirty Scats 40B', 'SCT', TRUE);
END $$;

COMMIT; 