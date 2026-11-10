# Power BI Production KPI Validation

**Phase 6 · DAX calculations**  
**Status:** reviewed cases match reference values. Analytical dashboard design remains pending.  
**Consolidated:** November 5, 2026.

## Main Results

| Indicator | Period | Result |
|---|---|---:|
| National production | July 2026 | 13,948 kbpd |
| National YoY change | July 2026 | +224 kbpd |
| National YoY growth | July 2026 | +1.63% |
| Weighted annual average | 2024 · 366 days | 13,266.891 kbpd |
| Weighted annual average | 2025 · 365 days | 13,662.068 kbpd |
| Weighted YTD average | January–July 2026 | 13,760.132 kbpd |
| Comparable prior-year average | January–July 2025 | 13,492.901 kbpd |
| Comparable YTD growth | January–July 2026 | +1.98% |
| Top 5 component production | July 2026 | 11,831 kbpd |
| Top 5 share | July 2026 | 84.82% |

**Units:** kbpd = thousand barrels per day; pp = percentage points. Figures are average daily rates, not monthly volumes.

## National Growth Reconciliation

| Metric | July 2026 |
|---|---:|
| Prior-year national production | 13,724 kbpd |
| Combined component change | +222 kbpd |
| Reconciliation residual | +2 kbpd |
| National change | +224 kbpd |
| Combined component contribution | +1.617604 pp |
| Residual contribution | +0.014573 pp |

**222 + 2 = 224 kbpd.** Contributions including the residual sum to approximately **1.632177 pp**, equivalent to national growth displayed as **1.63%**. Reconciliation uses unrounded values. The residual is a difference between the component aggregate and national series; it does not identify a producer or establish a cause.

<details>
<summary>Calculation and Filter Rules</summary>

- Annual and YTD averages are weighted by calendar days: sum of rate × days divided by covered days. Both January–July comparison periods contain 7 months and 212 days.
- Incomplete years do not return a full-year average. The 2026 annual indicator remains blank.
- The analytical population comprises 34 non-overlapping components: 32 states and 2 federal offshore areas. Components are not added together with national totals, PADD totals, or Alaska subdivisions.
- Rankings use dense ranking. Top 5 selects exactly five components, resolving cutoff ties by ascending series_id.
- July 2026 leaders are Texas, New Mexico, Federal Offshore (PADD 3), North Dakota, and Colorado.
- Individual contribution equals 100 × component YoY change ÷ prior-year national production for the same month. It is a decimal in pp, without percentage formatting.
- National indicators, reconciliation, and Top 5 cards retain the selected date and remain unchanged when selecting a geographic component.

</details>

<details>
<summary>Control Cases and Evidence Scope</summary>

| Case | Validated behavior |
|---|---|
| July 2026 versus June 2026 | Monthly change +104 kbpd; growth +0.75% |
| First month: January 2010 | Production 5,404 kbpd; unavailable earlier comparisons blank |
| December 2025 | YTD average equals annual average: 13,662.068 kbpd |
| August 2026, no current observation | Current production and changes blank; prior-period measures may contain data |
| New Mexico selection | National rank remains 2; national references remain stable |
| Reconciliation without a valid comparison | All five reconciliation measures blank |

Evidence consists of reviewed screenshots and user confirmation of interactive checks. It does not establish a fresh PBIX inspection, a new MySQL execution, or exhaustive testing of every filter combination.

The SQL report retains its separate status: **reference values; execution confirmation pending**. Closing that validation requires executed outputs, execution date, and MySQL version. Matching Power BI figures do not replace that evidence. (MySQL Workbench, SQL)

</details>

## Related Documentation

- [KPI catalog](kpi_catalog.md)
- [SQL references](sql_kpi_validation.md)
- [SQL validation script](../sql/05_kpi_validation.sql)
- [Power BI file](../powerbi/us_crude_oil_production.pbix)
