// Basic types for the Mine to Mill Reconciliation System

// Organization structure types
export interface Company {
    id: number;
    code: string;
    description: string;
    isActive: boolean;
}

export interface Region {
    id: number;
    companyId: number;
    code: string;
    description: string;
    isActive: boolean;
    company?: Company;
}

export interface Operation {
    id: number;
    companyId: number;
    regionId: number;
    code: string;
    description: string;
    isActive: boolean;
    company?: Company;
    region?: Region;
}

// Material classification types
export interface OreSource {
    id: number;
    operationId: number;
    code: string;
    description: string;
    isActive: boolean;
    operation?: Operation;
}

export interface OreType {
    id: number;
    operationId: number;
    code: string;
    description: string;
    isActive: boolean;
    operation?: Operation;
}

export interface MineType {
    id: number;
    operationId: number;
    code: string;
    description: string;
    isActive: boolean;
    operation?: Operation;
}

// Mining location types
export interface Mine {
    id: number;
    operationId: number;
    oreSourceId: number;
    code: string;
    description: string;
    isActive: boolean;
    operation?: Operation;
    oreSource?: OreSource;
}

export interface MineZone {
    id: number;
    operationId: number;
    mineId: number;
    code: string;
    description: string;
    isActive: boolean;
    operation?: Operation;
    mine?: Mine;
}

export interface Stockpile {
    id: number;
    operationId: number;
    code: string;
    description: string;
    nodeType: string; // e.g., 'ROM', 'Satellite', 'CTG', etc.
    isActive: boolean;
    operation?: Operation;
}

// Time period type
export interface Period {
    id: number;
    year: number;
    month: number;
    description: string;
    isActive: boolean;
    isClosed: boolean;
}

// Monthly data types
export interface MonthlyUpload {
    id: number;
    operationId: number;
    periodId: number;
    uploadDate: string;
    uploadedBy: string;
    status: 'Pending' | 'Validated' | 'Processed' | 'Approved' | 'Rejected';
    comments: string;
    operation?: Operation;
    period?: Period;
}

export interface StockpileData {
    id: number;
    uploadId: number;
    oreSourceId: number;
    oreTypeId: number;
    mineTypeId: number;
    stockpileId: number;
    tonnes: number;
    grade: number;
    ounces: number;
    upload?: MonthlyUpload;
    oreSource?: OreSource;
    oreType?: OreType;
    mineType?: MineType;
    stockpile?: Stockpile;
}

// User authentication and authorization
export interface User {
    id: string;
    email: string;
    displayName: string;
    role: 'admin' | 'manager' | 'user' | 'readonly';
    companyId?: number;
    regionId?: number;
    operationId?: number;
}

// Reconciliation factors
export interface ReconciliationFactor {
    id: number;
    operationId: number;
    periodId: number;
    factorType: 'MineClaim' | 'MetalCall';
    value: number;
    operation?: Operation;
    period?: Period;
}
