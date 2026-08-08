USE HealthcareDataOps;
GO

INSERT INTO production.Client (
    client_id,
    client_name,
    city,
    state_code
)
VALUES
    (1, 'Madison General Hospital', 'Madison', 'WI'),
    (2, 'Lakeshore Medical Center', 'Milwaukee', 'WI'),
    (3, 'Prairie Valley Health', 'Rockford', 'IL');
GO

INSERT INTO raw.MadisonGeneral_Encounter (
    patient_id,
    encounter_id,
    service_date,
    diagnosis_code,
    procedure_code,
    provider_id,
    charge_amount
)
VALUES
    ('P1001', 'E10001', '2026-07-01', 'I10', '99213', 'PR001', '215.50'),
    ('P1002', 'E10002', '2026-07-02', 'E11.9', '83036', 'PR002', '145.00'),
    ('P1003', 'E10003', 'not-a-date', 'J45.909', '94640', 'PR003', '310.75'),
    ('P1004', 'E10004', '2026-07-04', 'I10', '99214', 'PR004', '-25.00'),
    ('',      'E10005', '2026-07-05', 'M54.50', '97110', 'PR005', '180.00'),
    ('P1006', 'E10006', '2026-07-06', 'BADCODE', '99213', 'PR006', '225.00'),
    ('P1007', 'E10007', '2026-07-07', 'R51.9', 'ABC123', 'PR007', '95.00'),
    ('P1008', 'E10008', '2026-07-08', 'K21.9', '99213', 'PR008', '250.00');
GO

INSERT INTO raw.Lakeshore_Encounter (
    MRN,
    visit_number,
    service_dt,
    ICD10,
    CPT,
    rendering_provider,
    total_charge
)
VALUES
    ('L2001', 'V20001', '08/01/2026', 'I10', '99213', 'LP001', '$185.00'),
    ('L2002', 'V20002', '08/02/2026', 'E11.9', '83036', 'LP002', '$132.50'),
    ('L2003', 'V20003', '08/03/2026', 'J45.909', '94640', 'LP003', '$275.00'),
    ('L2004', 'V20004', 'bad-date', 'K21.9', '99214', 'LP004', '$210.00'),
    ('',      'V20005', '08/05/2026', 'M54.50', '97110', 'LP005', '$165.00'),
    ('L2006', 'V20006', '08/06/2026', 'R51.9', '99213', 'LP006', '$95.00');
GO

INSERT INTO raw.PrairieValley_Encounter (
    member_number,
    encounter_ref,
    date_of_service,
    dx_code,
    proc_code,
    clinician_id,
    billed_amount
)
VALUES
    ('PV3001', 'PV-E30001', '2026/08/01', 'I10', '99213', 'CL001', '190.00'),
    ('PV3002', 'PV-E30002', '2026/08/02', 'E11.9', '83036', 'CL002', '140.00'),
    ('PV3003', 'PV-E30003', '2026/08/03', 'J45.909', '94640', 'CL003', '275.00'),
    ('PV3004', 'PV-E30004', '2026/08/04', '', '99214', 'CL004', '225.00'),
    ('PV3005', 'PV-E30005', '2026/08/05', 'M54.50', '', 'CL005', '175.00'),
    ('PV3006', 'PV-E30006', 'not-a-date', 'R51.9', '99213', 'CL006', '105.00'),
    ('PV3007', 'PV-E30007', '2026/08/07', 'K21.9', '99213', '', '210.00'),
    ('PV3008', 'PV-E30008', '2026/08/08', 'I10', '99213', 'CL008', 'banana'),
    ('PV3009', 'PV-E30009', '2026/08/09', 'E11.9', '83036', 'CL009', '155.00'),
    ('PV3009', 'PV-E30009', '2026/08/09', 'E11.9', '83036', 'CL009', '155.00');
GO