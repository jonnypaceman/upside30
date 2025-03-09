#!/bin/bash
# Script to deploy seed data to Cloud SQL instance

# Configuration
INSTANCE_NAME="m2m-postgres-dev"
PROJECT_ID="mine-to-mill-recon-jg-2024"
DB_NAME="mine_to_mill"
DB_USER="postgres"
DB_PASSWORD="Maree123$"
PROXY_PORT=5433

# Start Cloud SQL Proxy in the background
echo "Starting Cloud SQL Proxy..."
cloud_sql_proxy -instances=${PROJECT_ID}:australia-southeast1:${INSTANCE_NAME}=tcp:${PROXY_PORT} &
PROXY_PID=$!

# Wait for proxy to start
sleep 5
echo "Cloud SQL Proxy started with PID: $PROXY_PID"

# Deploy seed data
echo "Deploying seed data..."
PGPASSWORD="${DB_PASSWORD}" psql -h localhost -p ${PROXY_PORT} -U ${DB_USER} -d ${DB_NAME} -f seed_01_organization.sql
PGPASSWORD="${DB_PASSWORD}" psql -h localhost -p ${PROXY_PORT} -U ${DB_USER} -d ${DB_NAME} -f seed_02_reference_tables.sql
PGPASSWORD="${DB_PASSWORD}" psql -h localhost -p ${PROXY_PORT} -U ${DB_USER} -d ${DB_NAME} -f seed_03_period_data.sql

# Verify data was inserted correctly
echo "Verifying data..."
PGPASSWORD="${DB_PASSWORD}" psql -h localhost -p ${PROXY_PORT} -U ${DB_USER} -d ${DB_NAME} << EOF
SELECT 'Company Count: ' || COUNT(*) FROM CompanyTbl;
SELECT 'Region Count: ' || COUNT(*) FROM RegionTbl;
SELECT 'Operation Count: ' || COUNT(*) FROM OperationTbl;
SELECT 'Ore Source Count: ' || COUNT(*) FROM OreSourceTbl;
SELECT 'Ore Type Count: ' || COUNT(*) FROM OreTypeTbl;
SELECT 'Mine Type Count: ' || COUNT(*) FROM MineTypeTbl;
SELECT 'Mine Count: ' || COUNT(*) FROM MineTbl;
SELECT 'Mine Zone Count: ' || COUNT(*) FROM MineZoneTbl;
SELECT 'Stockpile Count: ' || COUNT(*) FROM StockpileTbl;
SELECT 'Period Count: ' || COUNT(*) FROM PeriodTbl;
SELECT 'Monthly Upload Count: ' || COUNT(*) FROM MonthlyUploadTbl;
SELECT 'Satellite Stock Count: ' || COUNT(*) FROM SatelliteStockTbl;
SELECT 'ROM Stock Count: ' || COUNT(*) FROM ROMStockTbl;
SELECT 'CTG Stock Count: ' || COUNT(*) FROM CTGStockTbl;
SELECT 'COS Stock Count: ' || COUNT(*) FROM COSStockTbl;
SELECT 'SCT Stock Count: ' || COUNT(*) FROM SCTStockTbl;
SELECT 'Reconciliation Factor Count: ' || COUNT(*) FROM ReconciliationFactorTbl;
EOF

# Kill the proxy
echo "Stopping Cloud SQL Proxy..."
kill $PROXY_PID

echo "Seed data deployment completed!" 