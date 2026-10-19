SQL Data Quality and Geographic Reconciliation
Phase: 3 — SQL analysis
Block: B — Detailed data-quality checks and geographic reconciliation
Validation date: 2026-10-19
MySQL server version: 9.7.1 (as recorded in the Block A report)
Overall status: Completed — structural checks passed; reconciliation differences documented
Purpose
Verify observation uniqueness, record validity, geography coverage, and monthly completeness. Compare sums of non-overlapping geographic components with the published U.S. and PADD totals retained in the dataset.
Inputs and Reproducibility
- [Geography lookup](../data/processed/geography_lookup.csv)
- [Monthly production data](../data/processed/production_monthly.csv)
- [SQL validation script](../sql/03_data_quality_reconciliation.sql)
- [Block A import validation](sql_import_validation.md)
Run the script after completing the schema creation and CSV imports documented in Block A. Execute checks A–D individually, then execute the complete reconciliation statement E.

The dataset contains 8,358 observations, covering 42 geographic series and 199 months, from January 2010 through July 2026. Production values are monthly average rates expressed in thousand barrels per day (kbpd).
Structural and Completeness Checks
Check	Validation	Expected result	Reported actual result	Status
A	Duplicate month–series combinations	No rows	No rows	Passed
B	Missing or blank identifiers, missing values, negative production, invalid monthly dates, or dates outside the selected period	No rows	No rows	Passed
C	Production records without a matching geography	No rows	No rows	Passed
D	Missing expected month–series combinations	No rows	No rows	Passed


Zero-production values are valid observations and remain in the dataset. Check D evaluates every expected month against every series in the geography dimension, including the first and last months of the analysis period.
Geographic Reconciliation Method
For each month, the query compares:
1. The sum of 32 states and two federal offshore areas with the published U.S. total.
2. The sum of those components within each PADD with its published PADD total.
Only geography records where is_component = 1 enter the component sums. National totals, PADD totals, and Alaska subdivisions are excluded from these sums to prevent double counting.
Difference (kbpd) = Component sum (kbpd) − Published total (kbpd)
A positive difference means the component sum exceeds the published total. A negative difference means it falls below the published total. Zero indicates an exact match.

Geographic components are summed within each month. Daily production rates are not summed across months or presented as production volumes.
Reconciliation Results
All difference columns below are expressed in kbpd.
Comparison area	Months compared	Exact-match months	Differing months	Minimum difference	Maximum difference	Maximum absolute difference
PADD 1	199	116	83	-1.000	2.000	2.000
PADD 2	199	64	135	-3.000	3.000	3.000
PADD 3	199	105	94	-2.000	2.000	2.000
PADD 4	199	113	86	-2.000	1.000	2.000
PADD 5	199	133	66	-1.000	2.000	2.000
United States	199	38	161	-5.000	4.000	5.000


Check E status: Verified against prepared CSVs; nonzero differences retained.

Each area has all 199 monthly comparisons. Exact-match months plus differing months equal 199 for every area. The largest absolute discrepancy is 3 kbpd (3,000 barrels per day) among PADD comparisons and 5 kbpd (5,000 barrels per day) nationally.
Verification Evidence
- Checks A–D were executed in MySQL and reported as returning no rows by the project author.
- The uploaded SQL script was reviewed against the intended validation and reconciliation logic.
- The six-row SQL reconciliation result was reviewed from the supplied MySQL result-grid screenshot.
- An independent Python recalculation using production_monthly.csv and geography_lookup.csv from the repository reproduced every value in the reconciliation summary.
The independent recalculation confirms consistency between the SQL output and the prepared CSV inputs. It is not a separate audit of EIA's underlying estimates or proof of the cause of each discrepancy.
Interpretation and Reporting Rules
The reconciliation differences are present in the prepared data and were not introduced by the SQL aggregation. Their magnitude is consistent with independent rounding, but the summary alone does not establish rounding as the sole cause. No numerical acceptance tolerance or exact-match requirement was imposed retrospectively.
- Preserve the original imported production values; do not adjust them to force agreement.
- Use the published national series for U.S. totals and the published PADD series for regional totals.
- Use non-overlapping components for component-level comparisons and rankings.
- Retain the reconciliation differences when interpreting component contributions or shares against published totals; exact agreement is not guaranteed.
Conclusion
All structural and monthly completeness checks passed. Geographic reconciliation covered 199 months for each of six areas. SQL results matched an independent recalculation from the prepared CSV files. Component sums differ from published totals by up to 3 thousand barrels per day for PADDs and 5 thousand barrels per day nationally. These differences are retained and documented; no source values were adjusted.

Phase 3, Block B is complete with documented reconciliation differences. The next block is exploratory production analysis.
