USE HealthcareDataOps;
GO

CREATE OR ALTER PROCEDURE dbo.usp_RunHealthcareETL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @run_id INT;

    INSERT INTO audit.Pipeline_Run (status)
    VALUES ('RUNNING');

    SET @run_id = SCOPE_IDENTITY();

    BEGIN TRY
        EXEC audit.usp_ValidateAllClients;
        EXEC staging.usp_LoadAllClients;
        EXEC production.usp_LoadEncounters;

        UPDATE audit.Pipeline_Run
        SET end_time = SYSDATETIME(),
            status = 'SUCCESS'
        WHERE run_id = @run_id;

        EXEC audit.usp_ReconcileClients;
    END TRY

    BEGIN CATCH
        UPDATE audit.Pipeline_Run
        SET end_time = SYSDATETIME(),
            status = 'FAILED',
            notes = ERROR_MESSAGE()
        WHERE run_id = @run_id;

        THROW;
    END CATCH
END;
GO