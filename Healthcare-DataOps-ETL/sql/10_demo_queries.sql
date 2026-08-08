USE HealthcareDataOps;
GO

-- Run the full ETL pipeline
EXEC dbo.usp_RunHealthcareETL;
GO

-- View production row counts by client
SELECT
    client_id,
    COUNT(*) AS production_rows
FROM production.Encounter
GROUP BY client_id
ORDER BY client_id;
GO

-- View validation errors
SELECT
    client_id,
    encounter_id,
    error_type,
    error_message,
    logged_at
FROM audit.Validation_Error
ORDER BY client_id, encounter_id;
GO

-- View pipeline run history
SELECT
    run_id,
    start_time,
    end_time,
    status,
    notes
FROM audit.Pipeline_Run
ORDER BY run_id DESC;
GO

-- Run reconciliation checks
EXEC audit.usp_ReconcileClients;
GO