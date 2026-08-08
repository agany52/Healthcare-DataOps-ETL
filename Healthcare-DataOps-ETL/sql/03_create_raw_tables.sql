USE HealthcareDataOps;
GO

CREATE TABLE raw.MadisonGeneral_Encounter (
    patient_id VARCHAR(50),
    encounter_id VARCHAR(50),
    service_date VARCHAR(50),
    diagnosis_code VARCHAR(20),
    procedure_code VARCHAR(20),
    provider_id VARCHAR(50),
    charge_amount VARCHAR(50)
);
GO

CREATE TABLE raw.Lakeshore_Encounter (
    MRN VARCHAR(50),
    visit_number VARCHAR(50),
    service_dt VARCHAR(50),
    ICD10 VARCHAR(20),
    CPT VARCHAR(20),
    rendering_provider VARCHAR(50),
    total_charge VARCHAR(50)
);
GO

CREATE TABLE raw.PrairieValley_Encounter (
    member_number VARCHAR(50),
    encounter_ref VARCHAR(50),
    date_of_service VARCHAR(50),
    dx_code VARCHAR(20),
    proc_code VARCHAR(20),
    clinician_id VARCHAR(50),
    billed_amount VARCHAR(50)
);
GO