-- Mine to Mill Reconciliation System
-- Seed Data Script: Organization Structure
-- This script inserts seed data for the organization structure tables

BEGIN;

    -- Insert Company data
    INSERT INTO CompanyTbl
        (CompanyCode, CompanyDesc, ActiveCheck)
    VALUES
        ('NST', 'Northern Star', TRUE);

    -- Get the CompanyID for Northern Star
    DO $$
    DECLARE
    v_company_id INTEGER;
BEGIN
    SELECT CompanyID
    INTO v_company_id
    FROM CompanyTbl
    WHERE CompanyCode = 'NST';

    -- Insert Region data
    INSERT INTO RegionTbl
        (CompanyID, RegionCode, RegionDesc, ActiveCheck)
    VALUES
        (v_company_id, 'KAL', 'Kalgoorlie', TRUE),
        (v_company_id, 'YAN', 'Yandal', TRUE),
        (v_company_id, 'POG', 'Pogo', TRUE);

    -- Get RegionIDs
    DECLARE
        v_kal_region_id INTEGER;
v_yan_region_id INTEGER;
        v_pog_region_id INTEGER;
BEGIN
    SELECT RegionID
    INTO v_kal_region_id
    FROM RegionTbl
    WHERE RegionCode = 'KAL';
    SELECT RegionID
    INTO v_yan_region_id
    FROM RegionTbl
    WHERE RegionCode = 'YAN';
    SELECT RegionID
    INTO v_pog_region_id
    FROM RegionTbl
    WHERE RegionCode = 'POG';

    -- Insert Operation data
    -- Kalgoorlie Operations
    INSERT INTO OperationTbl
        (CompanyID, RegionID, OperationCode, OperationDesc, ActiveCheck)
    VALUES
        (v_company_id, v_kal_region_id, 'KCGM', 'Kalgoorlie Consolidated Gold Mines', TRUE),
        (v_company_id, v_kal_region_id, 'KALOPS', 'Kalgoorlie Operations', TRUE),
        (v_company_id, v_kal_region_id, 'CAROSUE', 'Carosue Dam', TRUE);

    -- Yandal Operations
    INSERT INTO OperationTbl
        (CompanyID, RegionID, OperationCode, OperationDesc, ActiveCheck)
    VALUES
        (v_company_id, v_yan_region_id, 'TBOX', 'Thunderbox', TRUE),
        (v_company_id, v_yan_region_id, 'JUNDEE', 'Jundee', TRUE);

    -- Pogo Operations
    INSERT INTO OperationTbl
        (CompanyID, RegionID, OperationCode, OperationDesc, ActiveCheck)
    VALUES
        (v_company_id, v_pog_region_id, 'POGOOPS', 'Pogo Operations', TRUE);
END;
END $$;

COMMIT; 