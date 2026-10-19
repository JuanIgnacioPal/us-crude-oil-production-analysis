# 📊 Exploratory Production Analysis

> **July 2026 snapshot** · National trend · Leading producing areas · Regional shares

📅 **Analysis date:** 2026-10-19 · 🗓️ **Dataset:** Jan 2010–Jul 2026  
🛢️ **Units:** thousand barrels per day (kbpd), monthly average rates

[📄 SQL script](../sql/04_exploratory_analysis.sql) · [🧪 Quality checks](sql_quality_reconciliation.md)

## 💡 Key Findings

- **U.S. production: 13,948 kbpd** — 13.948 million barrels/day, up **104 kbpd (+0.75%)** from June and **224 kbpd (+1.63%)** from July 2025.
- **Texas leads:** 41.35% of national production; New Mexico follows at 17.35%.
- **PADD 3 dominates the regional comparison:** 10,339 kbpd, or 74.13% of the published U.S. total.

## 🏆 Leading Components · July 2026

States and federal offshore areas are ranked together; overlapping totals and Alaska subdivisions are excluded.

| Rank | Producing area | Production (kbpd) | U.S. share |
|---|---|---:|---:|
| 1 | Texas | 5,768 | 41.35% |
| 2 | New Mexico | 2,420 | 17.35% |
| 3 | Federal Offshore (PADD 3) | 2,043 | 14.65% |
| 4 | North Dakota | 1,158 | 8.30% |
| 5 | Colorado | 442 | 3.17% |
| 6 | Alaska | 421 | 3.02% |
| 7 | Oklahoma | 391 | 2.80% |
| 8 | Wyoming | 311 | 2.23% |
| 9 | California | 245 | 1.76% |
| 10 | Utah | 206 | 1.48% |

## 🌎 Published PADD Totals · July 2026

| Region | Production (kbpd) | U.S. share |
|---|---:|---:|
| Gulf Coast (PADD 3) | 10,339 | 74.13% |
| Midwest (PADD 2) | 1,816 | 13.02% |
| Rocky Mountain (PADD 4) | 1,027 | 7.36% |
| West Coast (PADD 5) | 713 | 5.11% |
| East Coast (PADD 1) | 52 | 0.37% |

<details>
<summary><strong>📈 National trend · latest 12 months</strong></summary>

MoM compares the previous month; YoY compares the same month one year earlier. Changes in kbpd are changes in daily production rates.

| Month | Production (kbpd) | MoM Δ (kbpd) | MoM % | YoY Δ (kbpd) | YoY % |
|---|---:|---:|---:|---:|---:|
| 2026-07 | 13,948 | 104 | 0.75% | 224 | 1.63% |
| 2026-06 | 13,844 | 33 | 0.24% | 188 | 1.38% |
| 2026-05 | 13,811 | -170 | -1.22% | 276 | 2.04% |
| 2026-04 | 13,981 | 255 | 1.86% | 423 | 3.12% |
| 2026-03 | 13,726 | 15 | 0.11% | 199 | 1.47% |
| 2026-02 | 13,711 | 406 | 3.05% | 442 | 3.33% |
| 2026-01 | 13,305 | -505 | -3.66% | 138 | 1.05% |
| 2025-12 | 13,810 | -117 | -0.84% | 280 | 2.07% |
| 2025-11 | 13,927 | -68 | -0.49% | 436 | 3.23% |
| 2025-10 | 13,995 | 78 | 0.56% | 412 | 3.03% |
| 2025-09 | 13,917 | 82 | 0.59% | 689 | 5.21% |
| 2025-08 | 13,835 | 111 | 0.81% | 419 | 3.12% |

</details>

<details>
<summary><strong>⚙️ Method & verification</strong></summary>

- **A:** Published U.S. series (`MCRFPUS2`); `LAG()` compares one and 12 months earlier. Full output: 199 rows. The first MoM and first 12 YoY comparisons are undefined within this dataset.
- **B:** All 34 non-overlapping components; `DENSE_RANK()` gives equal values the same rank. The table above displays the first 10 rows.
- **C:** Five published PADD series, using the same latest month as the national series.
- **Shares:** area production ÷ published U.S. production × 100. Percentages are rounded to two decimals. `NULLIF` protects against division by zero.
- **Evidence:** The project author reported successful MySQL execution and expected results. The uploaded query logic was reviewed. Figures in this report were independently calculated in Python from the repository's [production CSV](../data/processed/production_monthly.csv) and [geography CSV](../data/processed/geography_lookup.csv); actual SQL output exports were not supplied for a row-by-row comparison.

</details>

## 📌 Interpretation

These results describe production levels and changes, not their causes. Shares may not total exactly 100% because of source reconciliation differences and rounding. Original values are preserved; daily rates are not summed across months.
