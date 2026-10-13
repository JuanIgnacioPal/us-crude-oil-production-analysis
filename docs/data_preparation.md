# 🧹 Data Preparation and Validation

## 📁 Input and working file

- Original: `data/raw/PET_CRD_CRPDN_ADC_MBBLPD_M.xls`
- Preparation workbook: `data/processed/us_crude_oil_preparation.xlsx`
- Source worksheet: `Data 1`
- Metadata worksheet: `Contents`
- Source release: 2026-09-30
- Selected period: January 2010–July 2026

The original workbook is preserved without modifications.
Preparation uses Excel and the Power Query interface.

## ⚙️ Transformation sequence

| Step | Action | Purpose |
|---|---|---|
| 1 | Import the Data 1 worksheet | Read the source production series |
| 2 | Remove introductory content and promote Sourcekey identifiers to headers | Preserve original EIA identifiers |
| 3 | Remove the series-description row from the production table | Separate descriptions from observations |
| 4 | Convert the month field to Date | Enable chronological filtering |
| 5 | Normalize dates to the first day of each month | Establish consistent monthly keys |
| 6 | Filter January 2010–July 2026 | Apply the selected analysis period |
| 7 | Unpivot all series columns | Produce one row per month and series |
| 8 | Rename fields and assign data types | Establish consistent analytical fields |
| 9 | Create the 42-row geographic lookup | Classify geographic levels and component areas |
| 10 | Left-join production to geography using series_id | Add geographic context without dropping observations |

The date conversion used English (United States) locale.
The stored result is a Date value; display formatting is separate.

No production values were replaced, imputed, or recalculated.
Published zeros were retained.

## 🗃️ Workbook objects

| Object | Role |
|---|---|
| stg_production_monthly | Query and worksheet containing 8,358 production observations |
| tbl_geography | Editable Excel table on geography_lookup |
| dim_geography | Connection-only query reading tbl_geography |
| production_classified | Query and worksheet containing production joined to geography |

## ✅ Saved-workbook validation

The saved workbook was checked against the original source.

| Check | Result |
|---|---|
| Staging records | 8,358 |
| Classified records | 8,358 |
| Monthly periods | 199 |
| Distinct series | 42 |
| Duplicate month-series combinations | 0 |
| Missing or unexpected month-series combinations | 0 |
| Production values differing from the original source | 0 |
| Duplicate geographic lookup identifiers | 0 |
| Incorrect or missing geographic matches | 0 |
| Blank cells or Excel errors in the validated data tables | 0 |
| Component records | 6,766 |

These checks validate the saved results.
A live Excel refresh was not independently executed.

## 📤 SQL exports

| File | Content | Expected records |
|---|---|---:|
| production_monthly.csv | month, series_id, production_kbpd | 8,358 |
| geography_lookup.csv | series_id, area_name, area_type, padd, is_component | 42 |

---

CSV validation status: Passed on 2026-10-13.
Actual delimiter: Comma.
Encoding: UTF-8 with BOM.
Date representation: YYYY-MM-DD.
- Production export: 8,358 records, matching the preparation
  workbook and original EIA source exactly.
- Geographic export: 42 records, matching the validated lookup.
- Duplicate keys: 0 in both exports.
- Missing geographic mappings: 0.
- Empty field values: 0.

## 🔗 Related documentation

- [Data Dictionary](data_dictionary.md)
- [Source Register](../sources/sources.md)
