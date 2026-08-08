USE HealthcareDataOps;
GO

CREATE OR ALTER PROCEDURE staging.usp_LoadMadisonGeneral
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO staging.Encounter (
        client_id,
        patient_id,
        encounter_id,
        service_date,
        diagnosis_code,
        procedure_code,
        provider_id,
        charge_amount
    )
    SELECT DISTINCT
        1 AS client_id,
        r.patient_id,
        r.encounter_id,
        TRY_CONVERT(DATE, r.service_date),
        r.diagnosis_code,
        r.procedure_code,
        r.provider_id,
        TRY_CONVERT(DECIMAL(12,2), r.charge_amount)
    FROM raw.MadisonGeneral_Encounter AS r
    WHERE NULLIF(LTRIM(RTRIM(r.patient_id)), '') IS NOT NULL
      AND TRY_CONVERT(DATE, r.service_date) IS NOT NULL
      AND TRY_CONVERT(DECIMAL(12,2), r.charge_amount) >= 0
      AND NOT EXISTS (
          SELECT 1
          FROM staging.Encounter AS s
          WHERE s.client_id = 1
            AND s.encounter_id = r.encounter_id
      );
END;
GO


CREATE OR ALTER PROCEDURE staging.usp_LoadLakeshore
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO staging.Encounter (
        client_id,
        patient_id,
        encounter_id,
        service_date,
        diagnosis_code,
        procedure_code,
        provider_id,
        charge_amount
    )
    SELECT DISTINCT
        2 AS client_id,
        r.MRN,
        r.visit_number,
        TRY_CONVERT(DATE, r.service_dt, 101),
        r.ICD10,
        r.CPT,
        r.rendering_provider,
        TRY_CONVERT(DECIMAL(12,2), REPLACE(r.total_charge, '$', ''))
    FROM raw.Lakeshore_Encounter AS r
    WHERE NULLIF(LTRIM(RTRIM(r.MRN)), '') IS NOT NULL
      AND TRY_CONVERT(DATE, r.service_dt, 101) IS NOT NULL
      AND TRY_CONVERT(
            DECIMAL(12,2),
            REPLACE(r.total_charge, '$', '')
          ) >= 0
      AND NOT EXISTS (
          SELECT 1
          FROM staging.Encounter AS s
          WHERE s.client_id = 2
            AND s.encounter_id = r.visit_number
      );
END;
GO


CREATE OR ALTER PROCEDURE staging.usp_LoadPrairieValley
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO staging.Encounter (
        client_id,
        patient_id,
        encounter_id,
        service_date,
        diagnosis_code,
        procedure_code,
        provider_id,
        charge_amount
    )
    SELECT DISTINCT
        3 AS client_id,
        r.member_number,
        r.encounter_ref,
        TRY_CONVERT(DATE, r.date_of_service, 111),
        r.dx_code,
        r.proc_code,
        r.clinician_id,
        TRY_CONVERT(DECIMAL(12,2), r.billed_amount)
    FROM raw.PrairieValley_Encounter AS r
    WHERE NULLIF(LTRIM(RTRIM(r.member_number)), '') IS NOT NULL
      AND TRY_CONVERT(DATE, r.date_of_service, 111) IS NOT NULL
      AND NULLIF(LTRIM(RTRIM(r.dx_code)), '') IS NOT NULL
      AND NULLIF(LTRIM(RTRIM(r.clinician_id)), '') IS NOT NULL
      AND TRY_CONVERT(DECIMAL(12,2), r.billed_amount) >= 0
      AND NOT EXISTS (
          SELECT 1
          FROM staging.Encounter AS s
          WHERE s.client_id = 3
            AND s.encounter_id = r.encounter_ref
      );
END;
GO


CREATE OR ALTER PROCEDURE staging.usp_LoadAllClients
AS
BEGIN
    SET NOCOUNT ON;

    EXEC staging.usp_LoadMadisonGeneral;
    EXEC staging.usp_LoadLakeshore;
    EXEC staging.usp_LoadPrairieValley;
END;
GO