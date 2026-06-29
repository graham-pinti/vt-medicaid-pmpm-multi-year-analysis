-- ============================================================
-- Vermont Medicaid PMPM Reconciliation SFY2022 (Recalibrated)
-- Summary View
-- ============================================================

DROP VIEW IF EXISTS vw_reconciliation_summary;

CREATE VIEW vw_reconciliation_summary AS
SELECT
    r.meg,

    r.budget_enrollment,
    r.actual_enrollment,
    r.enrollment_variance,
    ROUND(r.enrollment_variance_pct * 100, 2) AS enrollment_variance_pct,

    r.budget_pmpm,
    r.actual_pmpm,
    r.pmpm_variance,
    ROUND(r.pmpm_variance_pct * 100, 2)        AS pmpm_variance_pct,

    ROUND(r.budget_ann_cost / 1e6, 4)          AS budget_ann_cost_M,
    ROUND(r.actual_ann_cost  / 1e6, 4)         AS actual_ann_cost_M,
    ROUND(r.cost_impact      / 1e6, 4)         AS cost_impact_M,

    b.net_pmpm,
    CASE
        WHEN b.net_pmpm >= 500 THEN 'HIGH COST'
        WHEN b.net_pmpm >= 100 THEN 'MODERATE'
        ELSE 'LOW COST'
    END AS pmpm_tier,

    CASE
        WHEN ABS(r.enrollment_variance_pct) > 0.095 THEN 'ESCALATE'
        WHEN ABS(r.enrollment_variance_pct) > 0.063 THEN 'MONITOR'
        ELSE 'OK'
    END AS enrollment_flag,

    CASE
        WHEN ABS(r.pmpm_variance_pct) > 0.134 THEN 'ESCALATE'
        WHEN ABS(r.pmpm_variance_pct) > 0.089 THEN 'MONITOR'
        ELSE 'OK'
    END AS pmpm_flag,

    CASE
        WHEN ABS(r.enrollment_variance_pct) > 0.095
          OR ABS(r.pmpm_variance_pct)        > 0.134 THEN 'ESCALATE'
        WHEN ABS(r.enrollment_variance_pct) > 0.063
          OR ABS(r.pmpm_variance_pct)        > 0.089 THEN 'MONITOR'
        ELSE 'OK'
    END AS overall_flag,

    f.enrollment_finding,
    f.pmpm_finding,
    f.enrollment_resolution,
    f.pmpm_resolution

FROM reconciliation r
LEFT JOIN budget_reference b ON r.meg = b.meg
LEFT JOIN (
    SELECT
        meg,
        MAX(CASE WHEN variance_type = 'Enrollment' THEN finding_root_cause END) AS enrollment_finding,
        MAX(CASE WHEN variance_type = 'PMPM Cost' THEN finding_root_cause END) AS pmpm_finding,
        MAX(CASE WHEN variance_type = 'Enrollment' THEN resolution_status END) AS enrollment_resolution,
        MAX(CASE WHEN variance_type = 'PMPM Cost' THEN resolution_status END) AS pmpm_resolution
    FROM findings_log
    GROUP BY meg
) f ON r.meg = f.meg;

SELECT * FROM vw_reconciliation_summary ORDER BY overall_flag DESC, ABS(cost_impact_M) DESC;
