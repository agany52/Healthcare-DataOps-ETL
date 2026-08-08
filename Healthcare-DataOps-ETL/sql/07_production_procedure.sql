USE HealthcareDataOps;
GO

CREATE OR ALTER PROCEDURE production.usp_LoadEncounters
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO production.Encounter (
        client_id,
        patient_id,
        encounter_id,
        service_date,
        diagnosis_code,
        procedure_code,
        provider_id,
        charge_amount
    )
    SELECT
        s.client_id,
        s.patient_id,
        s.encounter_id,
        s.service_date,
        s.diagnosis_code,
        s.procedure_code,
        s.provider_id,
        s.charge_amount
    FROM staging.Encounter AS s
    WHERE NOT EXISTS (
        SELECT 1
        FROM production.Encounter AS p
        WHERE p.client_id = s.client_id
          AND p.encounter_id = s.encounter_id
    );
END;
GO