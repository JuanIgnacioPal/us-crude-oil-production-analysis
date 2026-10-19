# 🧪 SQL Quality & Reconciliation

> **Block B complete** · Structural checks passed · Reconciliation differences retained

📅 **Validated:** 2026-10-19 · 🗓️ **Coverage:** Jan 2010–Jul 2026  
📊 **Dataset:** 8,358 observations · 42 series · 199 months

[📄 SQL script](../sql/03_data_quality_reconciliation.sql) · [✅ Block A results](sql_import_validation.md)

## ✅ Data Quality

| Check | Result | Status |
|---|---|---|
| A · Duplicate month–series pairs | 0 found | Passed |
| B · Invalid production records | 0 found | Passed |
| C · Missing geography matches | 0 found | Passed |
| D · Missing month–series pairs | 0 found | Passed |

## 🔎 Geographic Reconciliation

**All six areas cover 199 months.** SQL results match an independent Python recalculation from the prepared CSVs.

Differences below are **component sum − published total**, in **thousand barrels per day (kbpd)**.

| Area | Exact months | Differing months | Min Δ | Max Δ | Max \|Δ\| |
|---|---:|---:|---:|---:|---:|
| PADD 1 | 116 | 83 | −1 | +2 | 2 |
| PADD 2 | 64 | 135 | −3 | +3 | 3 |
| PADD 3 | 105 | 94 | −2 | +2 | 2 |
| PADD 4 | 113 | 86 | −2 | +1 | 2 |
| PADD 5 | 133 | 66 | −1 | +2 | 2 |
| **United States** | **38** | **161** | **−5** | **+4** | **5** |

> **Largest gaps:** 3,000 barrels/day for PADDs; 5,000 barrels/day nationally. These differences exist in the prepared data and were not introduced by SQL aggregation.

## 📌 Reporting Decision

- **Preserve source values:** no adjustments to force agreement.
- **Report totals** using the published U.S. and PADD series.
- **Retain the differences:** their size is consistent with rounding, but rounding is not established as the sole cause.

<details>
<summary><strong>⚙️ Method & verification evidence</strong></summary>

- Sum 32 states and two federal offshore areas within each month using `is_component = 1`.
- Exclude national totals, PADD totals and Alaska subdivisions from component sums to avoid double counting.
- Compare those sums with the published national and PADD series. Daily rates are never summed across months.
- A–D: no rows returned, as reported by the project author. E: screenshot reviewed; all summary figures independently reproduced from the [production CSV](../data/processed/production_monthly.csv) and [geography CSV](../data/processed/geography_lookup.csv).
- MySQL version: 9.7.1, as recorded in Block A. No retrospective numerical tolerance was applied.

</details
