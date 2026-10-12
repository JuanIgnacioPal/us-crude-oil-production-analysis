# 📖 Data Dictionary

## 🛢️ Production observations

File: `data/processed/production_monthly.csv`

Grain: one observation per month and EIA series.
Expected records: 8,358.
Coverage: January 2010–July 2026, inclusive.

| Field | Logical type | Definition | Validation rule |
|---|---|---|---|
| month | Date | Month represented by the observation, normalized to its first day | Required; first day of month; exported as YYYY-MM-DD |
| series_id | Text | Original EIA series identifier | Required; must exist in geography_lookup.csv |
| production_kbpd | Decimal number | Monthly average daily crude oil production, in thousand barrels per day | Required and nonnegative |

The combination of `month` and `series_id` must be unique.

The current source contains whole-number production values.
A decimal-capable type preserves flexibility for future source revisions.

## 🌎 Geographic lookup

File: `data/processed/geography_lookup.csv`

Grain: one row per EIA series.
Expected records: 42.

| Field | Logical type | Definition | Validation rule |
|---|---|---|---|
| series_id | Text | Original EIA series identifier | Required and unique |
| area_name | Text | Readable project label for the geographic area | Required |
| area_type | Text | Geographic level represented by the series | State, Federal offshore, PADD, National, or State subdivision |
| padd | Text | Associated Petroleum Administration for Defense District | PADD 1–PADD 5; Not applicable for the national series |
| is_component | Integer flag | Identifies non-overlapping areas used in component-level analysis | 1 for states and federal offshore areas; 0 otherwise |

`area_name`, `area_type`, `padd`, and `is_component` are project
lookup fields based on the EIA geographic structure.
They are not additional production measurements.

## 🧭 Geographic composition

| Area type | Series | Monthly records |
|---|---:|---:|
| State | 32 | 6,368 |
| Federal offshore | 2 | 398 |
| PADD | 5 | 995 |
| National | 1 | 199 |
| State subdivision | 2 | 398 |
| Total | 42 | 8,358 |

The 34 component areas produce 6,766 monthly records.

The lookup includes the states available in the selected source,
not all 50 U.S. states. An absent state must not automatically be
interpreted as having zero production.

## ⚖️ Interpretation and aggregation

- `production_kbpd` is a daily rate reported at monthly frequency,
  not a monthly production volume.
- A value of 5,404 represents 5,404 thousand barrels per day.
- For component-level totals, use only `is_component = 1`.
- Do not add national or PADD totals to their component areas.
- Do not add South Alaska or North Slope to the Alaska total.
- Do not sum daily rates across months as though they were volumes.
- Any multi-month average rate must account for days in each month.
- Volumes derived from rounded daily rates are approximate.
- Preserve published zeros; they are distinct from missing values
  and may reflect source rounding.
- Small reconciliation differences may result from independently
  rounded source values.
- Comparisons involving 2026 must account for its partial-year coverage.

## 🔗 References

- [Project Source Register](../sources/sources.md)
- [EIA Crude Oil Production](https://www.eia.gov/dnav/pet/pet_crd_crpdn_adc_mbblpd_m.htm)
- [EIA Definitions, Sources and Notes](https://www.eia.gov/dnav/pet/TblDefs/pet_crd_crpdn_tbldef2.asp)
