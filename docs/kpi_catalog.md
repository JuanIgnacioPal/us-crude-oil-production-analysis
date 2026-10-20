# 📐 KPI Catalog

> **Phase 4 · Block A** — Calculation rules for SQL and Power BI

🛢️ **Source unit:** thousand barrels per day (kbpd)  
🗓️ **Coverage:** January 2010–July 2026

## 🎯 Core Indicators

| KPI | Calculation | Unit |
|---|---|---|
| Monthly production | Published monthly average daily rate | kbpd |
| Production change | Current rate − comparison-period rate | kbpd |
| Production growth | 100 × change ÷ comparison-period rate | % |
| Geographic share | 100 × area production ÷ published U.S. production | % |
| Production rank | Rank components by production, descending | Rank |
| Top 5 production share | 100 × production of five leading components ÷ published U.S. production | % |
| Contribution to national growth | 100 × area production change ÷ previous U.S. production | Percentage points |
| Period average production | Sum of monthly rate × days in month ÷ total days covered | kbpd |

## 🗓️ Comparison Rules

- **MoM:** compare a month with the immediately preceding month.
- **YoY:** compare a month with the same month one year earlier.
- **Annual:** compare complete calendar years using daily rates
  weighted by the number of days in each month.
- **YTD:** compare January through the latest available month
  with those same calendar months in the previous year.
- For this dataset, 2026 YTD means January–July.
- Never compare a partial year with a complete year as if their
  coverage were equivalent.

## 🌎 Geography Rules

- Use the published national series for U.S. totals.
- Use published PADD series for PADD totals.
- Use `is_component = 1` for component rankings, Top 5 shares,
  and component contributions.
- Components comprise 32 states and two federal offshore areas.
- Exclude Alaska subdivisions from component sums.
- Never add national or PADD totals to their components.
- Label federal offshore areas explicitly; they are not states.

## 🏆 Rankings & Top 5

- Monthly rankings use production in the selected month.
- Equal production values receive the same dense rank.
- Top 5 includes exactly five components.
- Select those five by production descending, then `series_id`
  ascending to resolve any tie at the cutoff.
- For annual or YTD rankings, first calculate each component's
  day-weighted average over the same period.
- Recalculate the Top 5 for each period; membership may change.

## 🔎 Contribution to National Growth

For each component:

Contribution (percentage points)
= 100 × (current area rate − previous area rate)
÷ previous U.S. rate

A positive contribution adds to national growth.
A negative contribution offsets it.

This measures contribution to the national growth rate.
It is different from the component's own growth percentage.

Component contributions may not sum exactly to published
national growth because geographic totals do not reconcile
perfectly. Report the residual:

Residual (percentage points)
= published U.S. growth (%) − sum of component contributions

## ⚖️ Time Aggregation

Period average production
= Σ(monthly production × days in month)
÷ Σ(days in month)

- Use the actual number of days, including leap years.
- Require complete monthly coverage for the stated period.
- Do not add daily production rates across months.
- Do not average monthly growth percentages to obtain annual growth.
- Period shares use area and U.S. weighted averages over identical dates.
- Period growth compares the weighted averages of the two periods.

## 🧪 Missing Values & Precision

- Preserve zero production as a valid observation.
- Return NULL/blank when the comparison period is unavailable
  or a percentage denominator is zero.
- Never convert an unavailable comparison into zero growth.
- Retain full precision during calculations.
- Display percentages and percentage-point contributions
  to two decimals.
- Display weighted average production to three decimals.
- Calculate totals from unrounded values.

## 📌 Interpretation

These indicators describe production patterns and geographic
concentration. They do not measure profitability, reserves,
well productivity, or the causes of production changes.

Shares and contributions retain the reconciliation differences
documented in Block B.
