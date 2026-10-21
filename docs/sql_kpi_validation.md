# 📐 Production KPIs | SQL References

> **Phase 4 · Block B** — Weighted averages, concentration and contributions

🟡 **Status:** reference values; SQL execution confirmation pending.

## 🛢️ At a Glance

| 2025 Average | 2026 YTD Average | Top 5 · July 2026 |
|---:|---:|---:|
| **13,662.068 kbpd** | **13,760.132 kbpd** | **84.82%** |

## 🧪 Reference Checks

| Query | Metric | Expected result |
|---|---|---:|
| A | Complete years | 16 · 2010–2025 |
| A | 2024 average · 366 days | 13,266.891 kbpd |
| A | 2025 average · 365 days | 13,662.068 kbpd |
| B | Coverage of each YTD period | 7 months · 212 days |
| B | January–July 2025 average | 13,492.901 kbpd |
| B | January–July 2026 average | 13,760.132 kbpd |
| C | Selected components | 5 |
| C | Top 5 / U.S. production | 11,831 / 13,948 kbpd |
| C | Top 5 share | 84.82% |
| D | Output rows | 34 components + 1 residual |
| D | Combined component YoY change | +222 kbpd |
| D | Reconciliation residual | +2 kbpd |
| D | National YoY change | +224 kbpd |

**Key takeaway:** the five leading components account for 84.82% of July 2026 national production in these reference figures. National change reconciles as **222 + 2 = 224 kbpd**. (SQL)

<details>
<summary>🔎 Method and Calculation Rules</summary>

- **Averages:** sum of monthly rate × days in month, divided by days covered. Include complete years and compare YTD periods covering the same months. (SQL)
- **Top 5:** exactly five non-overlapping components; production descending and `series_id` ascending to resolve ties. Denominator: published national total. (SQL)
- **Contribution:** 100 × component change ÷ prior-year national rate, in percentage points. The residual retains geographic differences; it is not a producing area. (SQL)
- **Precision:** calculate before rounding; preserve valid zeros and unavailable comparisons as `NULL`. Never sum daily rates across months. (SQL)
- **Section B correction:** `HAVING COUNT(DISTINCT f.month) = cutoff_month`. (SQL)

</details>

<details>
<summary>📋 Evidence Scope</summary>

Figures come from the reference checks documented when this block was prepared. This report does not establish a new MySQL execution or a fresh independent CSV verification.

To close the block, compare A–D with the executed outputs and record the execution date and MySQL version. In B, the 2025 change columns should be `NULL` because 2024 is not selected. Unrounded contributions plus the residual should equal national growth. (MySQL Workbench, SQL)

</details>

## 🔗 Related Documentation

- [KPI script](../sql/05_kpi_validation.sql)
- [KPI catalog](kpi_catalog.md)
- [Geographic reconciliation](sql_quality_reconciliation.md)
- [Exploratory findings](sql_exploratory_findings.md)
