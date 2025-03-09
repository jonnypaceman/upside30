-- Mine to Mill Reconciliation System
-- Combined Seed Data Script
-- This script runs all seed data scripts in the correct order

-- Organization Structure
\i
seed_01_organization.sql

-- Reference Tables
\i seed_02_reference_tables.sql

-- Period and Monthly Data
\i seed_03_period_data.sql

-- Verify data was inserted correctly
SELECT 'Company Count: ' || COUNT(*)
FROM CompanyTbl;
SELECT 'Region Count: ' || COUNT(*)
FROM RegionTbl;
SELECT 'Operation Count: ' || COUNT(*)
FROM OperationTbl;
SELECT 'Ore Source Count: ' || COUNT(*)
FROM OreSourceTbl;
SELECT 'Ore Type Count: ' || COUNT(*)
FROM OreTypeTbl;
SELECT 'Mine Type Count: ' || COUNT(*)
FROM MineTypeTbl;
SELECT 'Mine Count: ' || COUNT(*)
FROM MineTbl;
SELECT 'Mine Zone Count: ' || COUNT(*)
FROM MineZoneTbl;
SELECT 'Stockpile Count: ' || COUNT(*)
FROM StockpileTbl;
SELECT 'Period Count: ' || COUNT(*)
FROM PeriodTbl;
SELECT 'Monthly Upload Count: ' || COUNT(*)
FROM MonthlyUploadTbl;
SELECT 'Satellite Stock Count: ' || COUNT(*)
FROM SatelliteStockTbl;
SELECT 'ROM Stock Count: ' || COUNT(*)
FROM ROMStockTbl;
SELECT 'CTG Stock Count: ' || COUNT(*)
FROM CTGStockTbl;
SELECT 'COS Stock Count: ' || COUNT(*)
FROM COSStockTbl;
SELECT 'SCT Stock Count: ' || COUNT(*)
FROM SCTStockTbl;
SELECT 'Reconciliation Factor Count: ' || COUNT(*)
FROM ReconciliationFactorTbl; 