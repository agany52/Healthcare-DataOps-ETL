USE HealthcareDataOps;
GO

CREATE TABLE production.Client (
    client_id INT PRIMARY KEY,
    client_name VARCHAR(100) NOT NULL,
    city VARCHAR(100),
    state_code CHAR(2),
    is_active BIT NOT NULL DEFAULT 1
);
GO

CREATE TABLE staging.Encounter (
    client_id INT NOT NULL,
    patient_id VARCHAR(50) NOT NULL,
    encounter_id VARCHAR(50) NOT NULL,
    service_date DATE NOT NULL,
    diagnosis_code VARCHAR(20) NOT NULL,
    procedure_code VARCHAR(20),
    provider_id VARCHAR(50) NOT NULL,
    charge_amount DECIMAL(12,2) NOT NULL,

    CONSTRAINT UQ_Staging_ClientEncounter
        UNIQUE (client_id, encounter_id)
);
GO

CREATE TABLE production.Encounter (
    encounter_key INT IDENTITY(1,1) PRIMARY KEY,
    client_id INT NOT NULL,
    patient_id VARCHAR(50) NOT NULL,
    encounter_id VARCHAR(50) NOT NULL,
    service_date DATE NOT NULL,
    diagnosis_code VARCHAR(20) NOT NULL,
    procedure_code VARCHAR(20),
    provider_id VARCHAR(50) NOT NULL,
    charge_amount DECIMAL(12,2) NOT NULL,
    load_date DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT FK_Encounter_Client
        FOREIGN KEY (client_id)
        REFERENCES production.Client(client_id),

    CONSTRAINT UQ_Encounter_ClientEncounter
        UNIQUE (client_id, encounter_id)
);
GO

CREATE TABLE audit.Validation_Error (
    error_id INT IDENTITY(1,1) PRIMARY KEY,
    client_id INT NOT NULL,
    encounter_id VARCHAR(50),
    error_type VARCHAR(100) NOT NULL,
    error_message VARCHAR(500) NOT NULL,
    raw_service_date VARCHAR(50),
    raw_diagnosis_code VARCHAR(20),
    raw_procedure_code VARCHAR(20),
    raw_charge_amount VARCHAR(50),
    logged_at DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO

CREATE TABLE audit.Pipeline_Run (
    run_id INT IDENTITY(1,1) PRIMARY KEY,
    start_time DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    end_time DATETIME2 NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'RUNNING',
    notes VARCHAR(500) NULL
);
GO