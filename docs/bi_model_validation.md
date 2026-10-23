# ✅ Power BI Model Validation

> **Phase 5 · Data modeling** — Structural checks passed; slicer tests confirmed.

**8,358 production records · 42 geographic series · 199 months**  
🗓️ January 2010–July 2026 | Reviewed: **23 October 2026**

## 🧪 Quality Checks

| Check | Result | Status |
|---|---:|:---:|
| Production records | 8,358 | ✅ |
| Duplicate month–series records | 0 | ✅ |
| Production series absent from geography | 0 | ✅ |
| Production dates absent from calendar | 0 | ✅ |

**Each production row represents one geographic series in one month.**

## 🎛️ Filter Tests

| Selection | Production rows | Status |
|---|---:|:---:|
| No filters | 8,358 | ✅ |
| July 2026 | 42 | ✅ |
| United States | 199 | ✅ |
| July 2026 + United States | 1 | ✅ |

All four interactive results were confirmed by the report author in Power BI Desktop.

<details>
<summary><strong>🔎 Model structure and verification method</strong></summary>

### Tables and relationships

| Table | Rows | Role |
|---|---:|---|
| `Fact_Production_Monthly` | 8,358 | Monthly production observations |
| `Dim_Geography` | 42 | Geographic identifiers and classifications |
| `Calendar` | 6,209 | Continuous daily date dimension |

`Measures.` stores the QA measures; it is not a production dimension.

Both relationships are **active, one-to-many, single direction**, filtering from the dimension into the fact table:

- `Dim_Geography[series_id]` → `Fact_Production_Monthly[series_id]`
- `Calendar[Date]` → `Fact_Production_Monthly[month]`

The calendar is marked as a date table and covers **1 January 2010–31 December 2026**. Its 204 calendar months include five months without production observations: **August–December 2026**. These are unavailable observations, not zero production.

### Evidence

- Inspected the submitted `us_crude_oil_production(2).pbix`, including its model metadata and four QA measure definitions.
- Independently recalculated record counts, duplicate month–series keys and unmatched keys from the stored model data using Python.
- Reviewed `QA Production Rows`, `QA Duplicate Rows`, `QA Unmatched Series` and `QA Unmatched Dates` against the intended checks.
- Interactive slicer results rely on the author's execution confirmation; the independent inspection did not execute DAX in Power BI Desktop.
- The submitted report contains the `QA_Model` page. This report documents calculation and model checks, not a rendered visual-layout audit.

</details>

## 📌 Conclusion

**The model passes the structural and filtering checks and is ready for production KPI development.**

This validation does **not** certify production totals, growth, geographic shares or day-weighted averages. Those measures require separate comparison with SQL reference results. It also does not resolve the separately recorded Phase 4 SQL execution-confirmation status.

