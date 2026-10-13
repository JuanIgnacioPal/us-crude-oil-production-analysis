
# 🛢️ U.S. Crude Oil Production Analysis

> 📊 A data analytics project exploring production trends, regional
> differences, and the geographic concentration of U.S. crude oil
> production using public data from the U.S. Energy Information
> Administration (EIA).

**Status:** 🚧 In progress — Phase 2: Data acquisition and cleaning  
**Industry:** 🛢️ Oil & Gas · Crude oil production  
**Coverage:** 🌎 United States  
**Frequency:** 📅 Monthly  
**Tools:** Excel · Power Query · MySQL · SQL · Power BI · DAX · GitHub

---

## 🎯 Project Objective

Analyze **how U.S. crude oil production changes over time**, identify
the geographic areas contributing to its growth or decline, and
assess production concentration.

The project will develop a reproducible workflow covering data
acquisition, preparation, SQL analysis, indicator validation, and
reporting in Power BI.

## 🏭 Business Context

An energy analytics team needs to understand **how much production
changes, where those changes originate, and how production is
distributed across producing areas**.

The analysis will support:

- 📈 **Trend monitoring:** tracking production over time.
- 🌎 **Geographic comparisons:** identifying differences between
  producing areas.
- 🔎 **Change attribution:** measuring each area's contribution
  to changes in national production.
- 🏆 **Production rankings:** tracking changes in the relative
  position of producing areas.
- 🛢️ **Concentration analysis:** measuring the share of production
  accounted for by the leading areas.

The results will provide context for monitoring the sector.
Explanations of the underlying causes will require additional evidence.

## ❓ Analytical Questions

| Focus | Question |
|---|---|
| 📈 Trends | How does production change over time? |
| 📉 Changes | Which areas record the largest increases and decreases? |
| 🔎 Contribution | How much does each area contribute to changes in national production? |
| 🏆 Rankings | How do producing areas move up or down the rankings? |
| 🛢️ Concentration | What share of production comes from the leading areas? |

---

## 🌎 Initial Scope

| Dimension | Definition |
|---|---|
| **Activity** | Crude oil production |
| **Country** | United States |
| **Frequency** | Monthly |
| **Geographic coverage** | States and federal offshore areas available in the source |
| **Regional grouping** | Petroleum Administration for Defense Districts (PADDs), following EIA classifications |
| **Analysis period** | January 2010–July 2026 |
| **Original unit** | Thousand barrels per day (monthly average) |
| **Analytical focus** | Trends, growth and decline, contribution, rankings, and concentration |

> 📌 The product definition and its inclusions will be documented
> using the official notes for the selected series. This version
> focuses on crude oil; natural gas is outside its scope.

## 🗃️ Data Source

**U.S. Energy Information Administration (EIA)**

- 🛢️ [Crude Oil Production](https://www.eia.gov/dnav/pet/pet_crd_crpdn_adc_mbblpd_m.htm)
- 🌐 [Petroleum & Other Liquids Data](https://www.eia.gov/petroleum/data.php)
- 📚 [Project Source Register](https://github.com/JuanIgnacioPal/us-crude-oil-production-analysis/blob/main/sources/sources.md)

An unmodified copy of the original file is preserved in data/raw/.
The documentation will record:

- Download date.
- Temporal and geographic coverage.
- Product definition and measurement units.
- Special codes and missing values.
- Applied transformations.

---

## ⚙️ Tools and Analytical Workflow

| Tool | Planned Use |
|---|---|
| **Excel and Power Query** | Data inspection, cleaning, and transformation |
| **MySQL Workbench and SQL** | Queries, quality checks, and indicator validation |
| **Power BI and DAX** | Data modeling, measures, and visualizations |
| **GitHub** | Version control, documentation, and publication |

### 🧭 Project Workflow

**EIA Data → Preparation → SQL → KPIs → Power BI → Validation → Findings**

Each phase will be divided into manageable blocks with
**expected outputs and validation checks before proceeding**.

<details>
<summary><strong>📋 Project Phases</strong></summary>

1. **Project definition and organization:** objectives, scope,
   analytical questions, and repository setup.
2. **Data acquisition and cleaning:** original file preservation,
   data preparation, and data dictionary.
3. **SQL analysis:** data loading, quality checks, and exploratory
   analysis.
4. **KPI definition and validation:** formulas, units, and
   aggregation rules.
5. **Data modeling:** tables, calendar, relationships, and model
   validation in Power BI.
6. **Measures and dashboards:** DAX calculations, visualizations,
   and comparison with SQL results.
7. **Data quality audit:** consolidation of checks, reconciliations,
   and limitations.
8. **Publication and project closure:** conclusions, final README,
   dashboard previews, and report demonstration.

Quality checks will take place throughout the project.
Phase 7 will consolidate the supporting evidence.

</details>

## 🧪 Data Quality Principles

| Check | Purpose |
|---|---|
| **Uniqueness** | Verify one observation per period and geographic area in the analytical table |
| **Time coverage** | Detect missing months within the selected period |
| **Special values** | Distinguish zero production from unavailable data and other source codes |
| **Geographic consistency** | Avoid overlapping areas or adding components together with their subtotals |
| **Units and aggregation** | Distinguish monthly volumes from average daily production rates |
| **Reconciliation** | Compare aggregated values with source reference totals |
| **Cross-validation** | Compare Power BI indicators with SQL results |
| **Traceability** | Document transformations, source revisions, and rounding differences |

> 🔎 Daily production rates will not be summed across months as
> though they were monthly volumes. Calculation and aggregation
> rules will be defined before the indicators are built.

---

## 📦 Planned Deliverables

- [x] Original and prepared datasets.
- [x] Data dictionary and transformation log.
- [ ] SQL analysis and validation scripts.
- [ ] KPI catalog and calculation rules.
- [ ] Power BI data model and dashboard.
- [ ] Data quality audit.
- [ ] Findings, conclusions, and limitations.
- [ ] Dashboard previews and report demonstration.

## ⚠️ Analytical Limitations

- Geographic aggregates cannot be used to evaluate the performance
  of **individual wells, equipment, or companies**.
- A regional production decline does not, by itself, demonstrate
  reservoir depletion or an operational failure.
- This source alone does not support estimates of **reserves,
  profitability, or equipment efficiency**.
- Findings and recommendations will be added after the analysis
  has been completed and validated.

---

<details>
<summary><strong>🗂️ Current Repository Structure</strong></summary>

```text
us-crude-oil-production-analysis/
├── README.md
├── data/
│   ├── raw/
│   │   ├── PET_CRD_CRPDN_ADC_MBBLPD_M.xls
│   │   └── README.md
│   └── processed/
│       ├── us_crude_oil_preparation.xlsx
│       ├── geography_lookup.csv
│       ├── production_monthly.csv
│       └── README.md
├── docs/
│   ├── data_dictionary.md
│   ├── data_preparation.md
│   └── README.md
├── sources/
│   └── sources.md
└── sql/
    └── README.md
```

</details>
