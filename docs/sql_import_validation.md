# SQL Import Validation

**Phase:** 3 — SQL loading and validation  
**Block:** A — Schema creation and initial import  
**Validation date:** 2026-10-16  
**MySQL server version:** 9.7.1  
**Overall result:** Passed

## Purpose

Confirm that the prepared CSV files were loaded into MySQL
with the expected record counts, coverage, classifications,
and reference value.

## Input Files

- `data/processed/geography_lookup.csv`
- `data/processed/production_monthly.csv`

## SQL Scripts

- [Schema creation](../sql/01_created_schema.sql)
- [Import validation](../sql/02_validated_import.sql)

Execution order:
1. Run the schema creation script.
2. Import the geography CSV into `dim_geography`.
3. Import the production CSV into `fact_production_monthly`.
4. Run the import validation script.

## Validation Results

Expected values were established during data preparation.
Actual values were checked against the MySQL query results.

| Check | Metric | Expected | Actual | Status |
|---|---|---|---|---|
| A | Geography records | 42 | 42 | Passed |
| A | Production records | 8,358 | 8,358 | Passed |
| B | First month | 2010-01-01 | 2010-01-01 | Passed |
| B | Last month | 2026-07-01 | 2026-07-01 | Passed |
| B | Distinct months | 199 | 199 | Passed |
| B | Distinct series | 42 | 42 | Passed |
| B | Zero-production values | 882 | 882 | Passed |
| C | Series with a record count other than 199 | 0 | 0 | Passed |
| D | Federal offshore: series / records | 2 / 398 | 2 / 398 | Passed |
| D | National: series / records | 1 / 199 | 1 / 199 | Passed |
| D | PADD: series / records | 5 / 995 | 5 / 995 | Passed |
| D | State: series / records | 32 / 6,368 | 32 / 6,368 | Passed |
| D | State subdivision: series / records | 2 / 398 | 2 / 398 | Passed |
| E | Non-overlapping component records | 6,766 | 6,766 | Passed |
| F | MCRFPUS2 on 2010-01-01 | 5404.000 | 5404.000 | Passed |

Production values are expressed in thousand barrels per day.

## Conclusion

All initial import checks passed. Phase 3, Block A is complete.

These checks confirm the initial import expectations.
Detailed monthly continuity checks and reconciliation against
published geographic totals will be performed in Block B.
