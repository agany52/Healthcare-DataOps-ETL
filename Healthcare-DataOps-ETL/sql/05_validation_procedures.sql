USE HealthcareDataOps;
GO
CREATE OR ALTER PROCEDURE audit.usp_ValidateMadisonGeneral
AS
BEGIN
    SET NOCOUNT ON;

    -- Invalid service date
    INSERT INTO audit.Validation_Error (
        client_id,
        encounter_id,
        error_type,
        error_message,
        raw_service_date,
        raw_diagnosis_code,
        raw_procedure_code,
        raw_charge_amount
    )
    SELECT
        1,
        r.encounter_id,
        'Invalid Service Date',
        'service_date could not be converted to a valid date',
        r.service_date,
        r.diagnosis_code,
        r.procedure_code,
        r.charge_amount
    FROM raw.MadisonGeneral_Encounter AS r
    WHERE TRY_CONVERT(DATE, r.service_date) IS NULL
      AND NOT EXISTS (
          SELECT 1
          FROM audit.Validation_Error AS e
          WHERE e.client_id = 1
            AND e.encounter_id = r.encounter_id
            AND e.error_type = 'Invalid Service Date'
      );

    -- Negative charge
    INSERT INTO audit.Validation_Error (
        client_id,
        encounter_id,
        error_type,
        error_message,
        raw_service_date,
        raw_diagnosis_code,
        raw_procedure_code,
        raw_charge_amount
    )
    SELECT
        1,
        r.encounter_id,
        'Negative Charge',
        'charge_amount must be zero or greater',
        r.service_date,
        r.diagnosis_code,
        r.procedure_code,
        r.charge_amount
    FROM raw.MadisonGeneral_Encounter AS r
    WHERE TRY_CONVERT(DECIMAL(12,2), r.charge_amount) < 0
      AND NOT EXISTS (
          SELECT 1
          FROM audit.Validation_Error AS e
          WHERE e.client_id = 1
            AND e.encounter_id = r.encounter_id
            AND e.error_type = 'Negative Charge'
      );

    -- Missing patient ID
    INSERT INTO audit.Validation_Error (
        client_id,
        encounter_id,
        error_type,
        error_message,
        raw_service_date,
        raw_diagnosis_code,
        raw_procedure_code,
        raw_charge_amount
    )
    SELECT
        1,
        r.encounter_id,
        'Missing Patient ID',
        'patient_id is required and cannot be blank',
        r.service_date,
        r.diagnosis_code,
        r.procedure_code,
        r.charge_amount
    FROM raw.MadisonGeneral_Encounter AS r
    WHERE NULLIF(LTRIM(RTRIM(r.patient_id)), '') IS NULL
      AND NOT EXISTS (
          SELECT 1
          FROM audit.Validation_Error AS e
          WHERE e.client_id = 1
            AND e.encounter_id = r.encounter_id
            AND e.error_type = 'Missing Patient ID'
      );
END;
GO
CREATE OR ALTER PROCEDURE audit.usp_ValidateLakeshore
AS
BEGIN
    SET NOCOUNT ON;

    -- Invalid service date
    INSERT INTO audit.Validation_Error (
        client_id,
        encounter_id,
        error_type,
        error_message,
        raw_service_date,
        raw_diagnosis_code,
        raw_procedure_code,
        raw_charge_amount
    )
    SELECT
        2,
        r.visit_number,
        'Invalid Service Date',
        'service_dt could not be converted to a valid date',
        r.service_dt,
        r.ICD10,
        r.CPT,
        r.total_charge
    FROM raw.Lakeshore_Encounter AS r
    WHERE TRY_CONVERT(DATE, r.service_dt, 101) IS NULL
      AND NOT EXISTS (
          SELECT 1
          FROM audit.Validation_Error AS e
          WHERE e.client_id = 2
            AND e.encounter_id = r.visit_number
            AND e.error_type = 'Invalid Service Date'
      );

    -- Missing patient ID
    INSERT INTO audit.Validation_Error (
        client_id,
        encounter_id,
        error_type,
        error_message,
        raw_service_date,
        raw_diagnosis_code,
        raw_procedure_code,
        raw_charge_amount
    )
    SELECT
        2,
        r.visit_number,
        'Missing Patient ID',
        'MRN is required and cannot be blank',
        r.service_dt,
        r.ICD10,
        r.CPT,
        r.total_charge
    FROM raw.Lakeshore_Encounter AS r
    WHERE NULLIF(LTRIM(RTRIM(r.MRN)), '') IS NULL
      AND NOT EXISTS (
          SELECT 1
          FROM audit.Validation_Error AS e
          WHERE e.client_id = 2
            AND e.encounter_id = r.visit_number
            AND e.error_type = 'Missing Patient ID'
      );
END;
GO
CREATE OR ALTER PROCEDURE audit.usp_ValidatePrairieValley
AS
BEGIN
    SET NOCOUNT ON;

    -- Invalid service date
    INSERT INTO audit.Validation_Error (
        client_id,
        encounter_id,
        error_type,
        error_message,
        raw_service_date,
        raw_diagnosis_code,
        raw_procedure_code,
        raw_charge_amount
    )
    SELECT
        3,
        r.encounter_ref,
        'Invalid Service Date',
        'date_of_service could not be converted to a valid date',
        r.date_of_service,
        r.dx_code,
        r.proc_code,
        r.billed_amount
    FROM raw.PrairieValley_Encounter AS r
    WHERE TRY_CONVERT(DATE, r.date_of_service, 111) IS NULL
      AND NOT EXISTS (
          SELECT 1
          FROM audit.Validation_Error AS e
          WHERE e.client_id = 3
            AND e.encounter_id = r.encounter_ref
            AND e.error_type = 'Invalid Service Date'
      );

    -- Invalid charge amount
    INSERT INTO audit.Validation_Error (
        client_id,
        encounter_id,
        error_type,
        error_message,
        raw_service_date,
        raw_diagnosis_code,
        raw_procedure_code,
        raw_charge_amount
    )
    SELECT
        3,
        r.encounter_ref,
        'Invalid Charge Amount',
        'billed_amount could not be converted to a valid decimal',
        r.date_of_service,
        r.dx_code,
        r.proc_code,
        r.billed_amount
    FROM raw.PrairieValley_Encounter AS r
    WHERE TRY_CONVERT(DECIMAL(12,2), r.billed_amount) IS NULL
      AND NOT EXISTS (
          SELECT 1
          FROM audit.Validation_Error AS e
          WHERE e.client_id = 3
            AND e.encounter_id = r.encounter_ref
            AND e.error_type = 'Invalid Charge Amount'
      );

    -- Missing diagnosis code
    INSERT INTO audit.Validation_Error (
        client_id,
        encounter_id,
        error_type,
        error_message,
        raw_service_date,
        raw_diagnosis_code,
        raw_procedure_code,
        raw_charge_amount
    )
    SELECT
        3,
        r.encounter_ref,
        'Missing Diagnosis Code',
        'dx_code is required and cannot be blank',
        r.date_of_service,
        r.dx_code,
        r.proc_code,
        r.billed_amount
    FROM raw.PrairieValley_Encounter AS r
    WHERE NULLIF(LTRIM(RTRIM(r.dx_code)), '') IS NULL
      AND NOT EXISTS (
          SELECT 1
          FROM audit.Validation_Error AS e
          WHERE e.client_id = 3
            AND e.encounter_id = r.encounter_ref
            AND e.error_type = 'Missing Diagnosis Code'
      );

    -- Missing provider ID
    INSERT INTO audit.Validation_Error (
        client_id,
        encounter_id,
        error_type,
        error_message,
        raw_service_date,
        raw_diagnosis_code,
        raw_procedure_code,
        raw_charge_amount
    )
    SELECT
        3,
        r.encounter_ref,
        'Missing Provider ID',
        'clinician_id is required and cannot be blank',
        r.date_of_service,
        r.dx_code,
        r.proc_code,
        r.billed_amount
    FROM raw.PrairieValley_Encounter AS r
    WHERE NULLIF(LTRIM(RTRIM(r.clinician_id)), '') IS NULL
      AND NOT EXISTS (
          SELECT 1
          FROM audit.Validation_Error AS e
          WHERE e.client_id = 3
            AND e.encounter_id = r.encounter_ref
            AND e.error_type = 'Missing Provider ID'
      );

    -- Duplicate encounter
    INSERT INTO audit.Validation_Error (
        client_id,
        encounter_id,
        error_type,
        error_message,
        raw_service_date,
        raw_diagnosis_code,
        raw_procedure_code,
        raw_charge_amount
    )
    SELECT
        3,
        d.encounter_ref,
        'Duplicate Encounter',
        'encounter_ref appears more than once in the raw submission',
        d.date_of_service,
        d.dx_code,
        d.proc_code,
        d.billed_amount
    FROM (
        SELECT *,
               ROW_NUMBER() OVER (
                   PARTITION BY encounter_ref
                   ORDER BY encounter_ref
               ) AS rn
        FROM raw.PrairieValley_Encounter
    ) AS d
    WHERE d.rn > 1
      AND NOT EXISTS (
          SELECT 1
          FROM audit.Validation_Error AS e
          WHERE e.client_id = 3
            AND e.encounter_id = d.encounter_ref
            AND e.error_type = 'Duplicate Encounter'
      );
END;
GO

CREATE OR ALTER PROCEDURE audit.usp_ValidateAllClients
AS
BEGIN
    SET NOCOUNT ON;

    EXEC audit.usp_ValidateMadisonGeneral;
    EXEC audit.usp_ValidateLakeshore;
    EXEC audit.usp_ValidatePrairieValley;
END;
GO
