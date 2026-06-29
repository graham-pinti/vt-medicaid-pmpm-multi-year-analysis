-- ============================================================
-- Vermont Medicaid PMPM Reconciliation SFY2022 (Recalibrated)
-- Setup Script - Run this first against the medicaid_pmpm database
-- Creates all three tables with correct schemas
-- Safe to re-run - drops existing tables first
-- ============================================================

DROP TABLE IF EXISTS budget_reference CASCADE;
CREATE TABLE budget_reference (
    meg                    TEXT,
    avg_monthly_enrollment INTEGER,
    gross_pmpm             NUMERIC,
    premium_pmpm           NUMERIC,
    net_pmpm               NUMERIC,
    annual_budget_est      NUMERIC
);

DROP TABLE IF EXISTS reconciliation CASCADE;
CREATE TABLE reconciliation (
    meg                      TEXT,
    budget_enrollment        INTEGER,
    actual_enrollment        INTEGER,
    enrollment_variance      INTEGER,
    enrollment_variance_pct  NUMERIC,
    budget_pmpm              NUMERIC,
    actual_pmpm              NUMERIC,
    pmpm_variance            NUMERIC,
    pmpm_variance_pct        NUMERIC,
    budget_ann_cost          NUMERIC,
    actual_ann_cost          NUMERIC,
    cost_impact              NUMERIC
);

DROP TABLE IF EXISTS findings_log CASCADE;
CREATE TABLE findings_log (
    meg                TEXT,
    variance_type      TEXT,
    budget_figure       TEXT,
    actual_figure       TEXT,
    variance            TEXT,
    variance_pct         TEXT,
    finding_root_cause TEXT,
    resolution_status   TEXT
);

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
AND table_name IN ('budget_reference', 'reconciliation', 'findings_log')
ORDER BY table_name;
