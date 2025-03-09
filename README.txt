# MINE TO MILL RECONCILIATION SYSTEM
# ================================

## OVERVIEW

The Mine to Mill Reconciliation System is a comprehensive web application designed to track and reconcile ore movement from mines through processing mills, with a focus on gold mining operations. The system enables mining companies to monitor material flow, calculate reconciliation factors, and generate reports for operational decision-making.

## FUNCTIONAL SPECIFICATION

### Purpose
The Mine to Mill (M2M) Reconciliation system tracks ore as it moves through the mining and processing workflow, calculating key metrics like Mine Claim Factors and Metal Call Factors to support operational decisions.

### Key Components
1. **Hierarchical Organization Structure**:
   - Company → Region → Operation hierarchy
   - Permissions and data access based on this structure

2. **Material Tracking**:
   - Tracks ore by "ore streams" (Ore Source + Ore Type + Mine Type)
   - Follows material through the entire process from mine to mill

3. **Reconciliation Calculations**:
   - Mine Claim Factor = Declared Ore Mined / Mine Claim
   - Metal Call Factor = Reconciled Milled / Mine Predicted Processed
   - Variance tracking between nodes

4. **Workflow Management**:
   - Structured monthend process
   - Data entry, reconciliation execution, and reporting steps
   - Approval and signoff process

5. **Reporting**:
   - Stockpile reporting
   - Reconciliation reporting
   - Variance analysis

## SYSTEM ARCHITECTURE

                                MINE TO MILL RECONCILIATION SYSTEM ARCHITECTURE
                                ==========================================

+-------------------------------------------------------------------------------------------------------+
|                                        CLIENT LAYER                                                    |
|                                                                                                       |
|  +-------------------+    +-------------------+    +-------------------+    +-------------------+     |
|  |                   |    |                   |    |                   |    |                   |     |
|  |  Authentication   |    |  Data Entry       |    |  Reconciliation   |    |  Reporting &      |     |
|  |  & User Mgmt      |    |  Forms            |    |  Workflow         |    |  Dashboards       |     |
|  |                   |    |                   |    |                   |    |                   |     |
|  +-------------------+    +-------------------+    +-------------------+    +-------------------+     |
|                                                                                                       |
|  React.js + TypeScript + Material UI                                Firebase Hosting                  |
+-------------------------------------------------------------------------------------------------------+
                |                                       |
                | API Calls                             | Authentication
                v                                       v
+-------------------------------------------------------------------------------------------------------+
|                                        API LAYER                                                       |
|                                                                                                       |
|  +-------------------+    +-------------------+    +-------------------+    +-------------------+     |
|  |                   |    |                   |    |                   |    |                   |     |
|  |  Authentication   |    |  CRUD             |    |  Reconciliation   |    |  Reporting        |     |
|  |  API              |    |  API              |    |  Process API      |    |  API              |     |
|  |                   |    |                   |    |                   |    |                   |     |
|  +-------------------+    +-------------------+    +-------------------+    +-------------------+     |
|                                                                                                       |
|  Express.js + Node.js                                                    Cloud Run                    |
+-------------------------------------------------------------------------------------------------------+
                |                                       |
                | Data Access                           | Authentication
                v                                       v
+-------------------------------------------------------------------------------------------------------+
|                                        SERVICE LAYER                                                   |
|                                                                                                       |
|  +-------------------+    +-------------------+    +-------------------+    +-------------------+     |
|  |                   |    |                   |    |                   |    |                   |     |
|  |  Authentication   |    |  Data Access      |    |  Calculation      |    |  Workflow         |     |
|  |  Service          |    |  Service          |    |  Engine           |    |  Service          |     |
|  |                   |    |                   |    |                   |    |                   |     |
|  +-------------------+    +-------------------+    +-------------------+    +-------------------+     |
|                                                                                                       |
+-------------------------------------------------------------------------------------------------------+
                |                                       |
                | Database Operations                   | User Authentication
                v                                       v
+-------------------------------------------------------------------------------------------------------+
|                                        DATA LAYER                                                      |
|                                                                                                       |
|  +-------------------+                                        +-------------------+                   |
|  |                   |                                        |                   |                   |
|  |  PostgreSQL       |                                        |  Firebase         |                   |
|  |  Database         |                                        |  Authentication   |                   |
|  |  (Cloud SQL)      |                                        |                   |                   |
|  |                   |                                        |                   |                   |
|  +-------------------+                                        +-------------------+                   |
|                                                                                                       |
+-------------------------------------------------------------------------------------------------------+

## DATA FLOW

                        DATA FLOW IN MINE TO MILL RECONCILIATION SYSTEM
                        ============================================

1. **Data Upload**: Users upload monthly data files for mine, haul, crush, and mill operations
2. **Validation**: System validates file format, schema, and business rules
3. **Data Import**: Validated data is parsed, transformed, and loaded into the database
4. **Reconciliation**: Users initiate the reconciliation process to calculate factors and generate reconciled data
5. **Reporting**: System generates interactive reports, dashboards, and exportable documents
6. **Approval Workflow**: Optional workflow for review and approval of reconciled data
7. **Finalization**: Approved data is locked for month-end and archived for historical comparison

## DATABASE SCHEMA

### Simplified Database Schema

                SIMPLIFIED MINE TO MILL RECONCILIATION DATABASE SCHEMA
                ================================================

+-------------------+       +-------------------+       +-------------------+
|    CompanyTbl     |       |     RegionTbl     |       |   OperationTbl    |
+-------------------+       +-------------------+       +-------------------+
| PK CompanyID      |<----->| PK RegionID       |<----->| PK OperationID    |
|    CompanyCode    |       | FK CompanyID      |       | FK CompanyID      |
|    CompanyDesc    |       |    RegionCode     |       | FK RegionID       |
|    ActiveCheck    |       |    RegionDesc     |       |    OperationCode  |
|                   |       |    ActiveCheck    |       |    OperationDesc  |
|                   |       |                   |       |    ActiveCheck    |
+-------------------+       +-------------------+       +-------------------+
                                                                  |
                                                                  |
                                                                  v
+-------------------+       +-------------------+       +-------------------+
|   OreSourceTbl    |       |    OreTypeTbl     |       |   MineTypeTbl     |
+-------------------+       +-------------------+       +-------------------+
| PK OreSourceID    |       | PK OreTypeID      |       | PK MineTypeID     |
| FK OperationID    |       | FK OperationID    |       | FK OperationID    |
|    OreSourceCode  |       |    OreTypeCode    |       |    MineTypeCode   |
|    OreSourceDesc  |       |    OreTypeDesc    |       |    MineTypeDesc   |
|    ActiveCheck    |       |    ActiveCheck    |       |    ActiveCheck    |
+-------------------+       +-------------------+       +-------------------+

+-------------------+       +-------------------+       +-------------------+
|     MineTbl       |       |   MineZoneTbl     |       |   StockpileTbl    |
+-------------------+       +-------------------+       +-------------------+
| PK MineID         |       | PK MineZoneID     |       | PK StockpileID    |
| FK OperationID    |       | FK OperationID    |       | FK OperationID    |
| FK OreSourceID    |       | FK MineID         |       |    StockpileCode  |
|    MineCode       |       |    MineZoneCode   |       |    StockpileDesc  |
|    MineDesc       |       |    MineZoneDesc   |       |    NodeType       |
|    ActiveCheck    |       |    ActiveCheck    |       |    ActiveCheck    |
+-------------------+       +-------------------+       +-------------------+

+-------------------+
|    PeriodTbl      |
+-------------------+
| PK PeriodID       |
|    Year           |
|    Month          |
|    PeriodDesc     |
|    IsActive       |
|    IsClosed       |
+-------------------+

                        MONTHLY DATA TABLES
                        ==================

+-------------------+
| MonthlyUploadTbl  |
+-------------------+
| PK UploadID       |
| FK OperationID    |
| FK PeriodID       |
|    UploadDate     |
|    UploadedBy     |
|    Status         |
|    Comments       |
+-------------------+
          |
          |
          v
+-------------------+       +-------------------+       +-------------------+
| SatelliteStockTbl |       |    ROMStockTbl    |       |    CTGStockTbl    |
+-------------------+       +-------------------+       +-------------------+
| PK SatelliteStockID|      | PK ROMStockID     |       | PK CTGStockID     |
| FK UploadID       |       | FK UploadID       |       | FK UploadID       |
| FK OreSourceID    |       | FK OreSourceID    |       | FK OreSourceID    |
| FK OreTypeID      |       | FK OreTypeID      |       | FK OreTypeID      |
| FK MineTypeID     |       | FK MineTypeID     |       | FK MineTypeID     |
| FK StockpileID    |       | FK StockpileID    |       | FK StockpileID    |
|    Tonnes         |       |    Tonnes         |       |    Tonnes         |
|    Grade          |       |    Grade          |       |    Grade          |
|    Ounces         |       |    Ounces         |       |    Ounces         |
+-------------------+       +-------------------+       +-------------------+

Additional tables include:
- COSStockTbl, SCTStockTbl (for crushed ore stockpiles)
- MinedToSatTbl, MinedDirectTbl (for mining data)
- HauledTbl (for material movement)
- CrushedTbl, MillTbl (for processing data)

### Monthly Data Upload Flow
1. Each Operation uploads monthly data (MonthlyUploadTbl)
2. The upload contains data for each section in the CSV:
   - Satellite stockpile levels (SatelliteStockTbl)
   - ROM stockpile levels (ROMStockTbl)
   - CTG, COS, SCT stockpile levels (CTGStockTbl, COSStockTbl, SCTStockTbl)
   - Mining data (MinedToSatTbl, MinedDirectTbl)
   - Material movement (HauledTbl)
   - Processing data (CrushedTbl, MillTbl)

## GOOGLE CLOUD SERVICES

                    GOOGLE CLOUD SERVICES FOR MINE TO MILL RECONCILIATION APP
                    ===================================================

### Frontend Services
- **Firebase Hosting**: Hosts React app with global delivery and SSL certificates
- **Firebase Authentication**: User management with role-based authentication
- **Cloud CDN**: Content delivery with global caching for fast loading

### Backend Services
- **Cloud Run**: API hosting with containerized, auto-scaling, pay-per-use model
- **Cloud Functions**: Data validation, event triggers, and file processing
- **App Engine (optional)**: Alternative hosting option with managed platform

### Data Services
- **Cloud SQL (PostgreSQL)**: Primary database for relational data, fact tables, and dimension tables
- **Cloud Storage**: File storage for import/export templates and report storage
- **Firestore (optional)**: NoSQL database for real-time updates and user preferences

### DevOps & Monitoring
- **Cloud Build**: CI/CD pipeline with automated tests, container builds, and deployment
- **Cloud Monitoring**: Performance monitoring with alerts and dashboards
- **Cloud Logging**: Centralized logging with error tracking and audit trail

### Security & Management
- **Cloud IAM**: Access control with resource permissions and service accounts
- **Secret Manager**: Secure storage for API keys and database credentials
- **Cloud Armor**: DDoS protection with web application firewall and security rules

### Integration Services (Optional)
- **Pub/Sub**: Event messaging with async processing and notifications
- **Cloud Scheduler**: Scheduled jobs for automated reconciliation and report generation
- **BigQuery**: Data warehouse for advanced analytics and historical data

## IMPLEMENTATION NOTES

1. **Initial Deployment**:
   - Focus on core functionality with simplified schema
   - Implement monthly data upload workflow
   - Create basic reconciliation calculations

2. **Future Enhancements**:
   - Advanced analytics and trend analysis
   - Mobile-friendly interface
   - Integration with mining ERP systems

3. **Development Approach**:
   - Agile methodology with iterative development
   - Regular user feedback and testing
   - Continuous integration and deployment

## CONTACT

For more information, please contact the development team.

---
Last Updated: March 2024 