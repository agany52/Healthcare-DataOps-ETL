USE HealthcareDataOps;
GO

CREATE OR ALTER PROCEDURE audit.usp_ReconcileClients
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        1 AS client_id,
        'Madison General Hospital' AS client_name,
        (SELECT COUNT(*) FROM raw.MadisonGeneral_Encounter) AS raw_rows,
        (SELECT COUNT(*) FROM production.Encounter WHERE client_id = 1) AS production_rows,
        (SELECT COUNT(*) FROM audit.Validation_Error WHERE client_id = 1) AS rejected_rows,
        CASE
            WHEN
                (SELECT COUNT(*) FROM raw.MadisonGeneral_Encounter)
                =
                (SELECT COUNT(*) FROM production.Encounter WHERE client_id = 1)
                +
                (SELECT COUNT(*) FROM audit.Validation_Error WHERE client_id = 1)
            THEN 'PASS'
            ELSE 'FAIL'
        END AS reconciliation_status

    UNION ALL

    SELECT
        2,
        'Lakeshore Medical Center',
        (SELECT COUNT(*) FROM raw.Lakeshore_Encounter),
        (SELECT COUNT(*) FROM production.Encounter WHERE client_id = 2),
        (SELECT COUNT(*) FROM audit.Validation_Error WHERE client_id = 2),
        CASE
            WHEN
                (SELECT COUNT(*) FROM raw.Lakeshore_Encounter)
                =
                (SELECT COUNT(*) FROM production.Encounter WHERE client_id = 2)
                +
                (SELECT COUNT(*) FROM audit.Validation_Error WHERE client_id = 2)
            THEN 'PASS'
            ELSE 'FAIL'
        END

    UNION ALL

    SELECT
        3,
        'Prairie Valley Health',
        (SELECT COUNT(*) FROM raw.PrairieValley_Encounter),
        (SELECT COUNT(*) FROM production.Encounter WHERE client_id = 3),
        (SELECT COUNT(*) FROM audit.Validation_Error WHERE client_id = 3),
        CASE
            WHEN
                (SELECT COUNT(*) FROM raw.PrairieValley_Encounter)
                =
                (SELECT COUNT(*) FROM production.Encounter WHERE client_id = 3)
                +
                (SELECT COUNT(*) FROM audit.Validation_Error WHERE client_id = 3)
            THEN 'PASS'
            ELSE 'FAIL'
        END;
END;
GO