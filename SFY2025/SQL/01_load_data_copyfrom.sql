-- ============================================================
-- Vermont Medicaid PMPM Reconciliation SFY2022 (Recalibrated)
-- Data Load Script - COPY FROM version
-- Run in DBeaver against medicaid_pmpm DB, AFTER running 00_setup.sql
--
-- Update the three file paths below to match where you saved the
-- CSVs on your machine. Avoid OneDrive-synced folders, since
-- PostgreSQL's server process needs direct OS-level file access
-- and cloud-synced placeholder files can cause a permission error.
-- ============================================================

TRUNCATE TABLE budget_reference CASCADE;
TRUNCATE TABLE reconciliation CASCADE;
TRUNCATE TABLE findings_log CASCADE;

COPY budget_reference (meg, avg_monthly_enrollment, gross_pmpm, premium_pmpm, net_pmpm, annual_budget_est)
FROM 'C:\path\to\your\csvs\budget_reference_clean.csv'
CSV HEADER;

COPY reconciliation (meg, budget_enrollment, actual_enrollment, enrollment_variance, enrollment_variance_pct, budget_pmpm, actual_pmpm, pmpm_variance, pmpm_variance_pct, budget_ann_cost, actual_ann_cost, cost_impact)
FROM 'C:\path\to\your\csvs\reconciliation_clean.csv'
CSV HEADER;

COPY findings_log (meg, variance_type, budget_figure, actual_figure, variance, variance_pct, finding_root_cause, resolution_status)
FROM 'C:\path\to\your\csvs\findings_log.csv'
CSV HEADER;

SELECT 'budget_reference' AS tbl, COUNT(*) FROM budget_reference
UNION ALL SELECT 'reconciliation', COUNT(*) FROM reconciliation
UNION ALL SELECT 'findings_log', COUNT(*) FROM findings_log;
