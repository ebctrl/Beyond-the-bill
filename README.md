# Beyond the Bill
### Hospital Performance Analytics: Billing Drivers, Patient Outcomes & Operational Efficiency

End-to-end analysis of 55,500 hospital admissions across 6 chronic conditions, 5 insurance providers, and 3 admission types spanning 2019–2024. Covers billing pattern analysis, length-of-stay drivers, demographic outcome disparities, medication effectiveness, and operational trends. Built with Python (Pandas, Seaborn, Matplotlib) and SQL. Key finding: billing variance is driven more by individual case complexity (LOS) than by diagnosis or insurance provider — a critical insight for hospital cost management.

---

## Business Questions

1. **What drives hospital billing?** Is it the condition, admission type, insurance, or length of stay?
2. **How long do patients stay?** What factors influence length of stay?
3. **Are outcomes equitable?** Do demographics or insurance affect test results?
4. **How do insurers compare?** Any billing or LOS differences across payers?
5. **What are the operational patterns?** Admission trends, seasonality, day-of-week effects?

## Dataset

- **Source**: [Healthcare Dataset](https://www.kaggle.com/datasets/prasad22/healthcare-dataset) (Kaggle)
- **Size**: 55,500 records × 15 features
- **Key variables**: Medical Condition, Billing Amount, Admission Type, Insurance Provider, Date of Admission, Discharge Date, Test Results, Medication, Age, Gender

## Project Structure

```
beyond-the-bill/
├── data/
│   └── healthcare_dataset.csv           # Raw dataset (55,500 rows)
├── output/
│   ├── healthcare_cleaned.csv           # Cleaned with derived features
│   ├── condition_summary.csv            # Full condition-level metrics
│   ├── insurance_provider_stats.csv     # Insurer comparison
│   ├── age_group_stats.csv              # Demographics analysis
│   ├── medication_stats.csv             # Medication effectiveness
│   ├── descriptive_statistics.csv       # Core descriptive stats
│   └── key_findings.txt                 # Written insights
├── visualizations/
│   ├── 01_billing_by_condition.png      # Box plots
│   ├── 02_billing_heatmap.png           # Condition × Admission Type
│   ├── 03_insurance_comparison.png      # Billing & LOS by insurer
│   ├── 04_los_distribution.png          # LOS histograms by condition
│   ├── 05_los_vs_billing.png            # Scatter: LOS × Billing
│   ├── 06_age_group_analysis.png        # Triple-metric age breakdown
│   ├── 07_test_results_by_condition.png # Stacked outcome bars
│   ├── 08_monthly_admissions_trend.png  # Dual-axis time series
│   └── 09_day_of_week.png              # Weekly admission pattern
├── sql_queries/
│   └── analysis_queries.sql             # 10 queries: CTEs, window, CASE
├── analysis.py                          # Full pipeline (run this)
└── README.md
```

## Key Findings

### Billing KPIs
| Metric | Value |
|--------|------:|
| Total Billing | $1.42B |
| Avg per Admission | $25,541 |
| Avg Length of Stay | 15.5 days |
| Avg Daily Cost | $3,387 |
| Total Admissions | 55,500 |

### Condition Summary
| Condition | Patients | Avg Billing | Avg LOS | Emergency % |
|-----------|:--------:|:-----------:|:-------:|:-----------:|
| Obesity | 9,231 | $25,808 | 15.5 | 33.9% |
| Diabetes | 9,304 | $25,640 | 15.4 | 32.4% |
| Asthma | 9,185 | $25,637 | 15.7 | 32.7% |
| Arthritis | 9,308 | $25,499 | 15.5 | 33.4% |
| Hypertension | 9,245 | $25,499 | 15.5 | 32.5% |
| Cancer | 9,227 | $25,164 | 15.5 | 32.7% |

### Visualizations

| Billing by Condition | Billing Heatmap |
|:---:|:---:|
| ![Billing](Visualizations/01_billing_by_condition.png) | ![Heatmap](Visualizations/02_billing_heatmap.png) |

| LOS vs Billing | Monthly Trend |
|:---:|:---:|
| ![LOS](Visualizations/05_los_vs_billing.png) | ![Trend](Visualizations/08_monthly_admissions_trend.png) |

| Age Group Analysis | Test Results |
|:---:|:---:|
| ![Age](Visualizations/06_age_group_analysis.png) | ![Tests](Visualizations/07_test_results_by_condition.png) |

## Data Cleaning Steps

1. Parsed dates and calculated **Length of Stay** (Discharge - Admission)
2. Fixed **108 negative billing amounts** (converted to absolute values)
3. Fixed **invalid LOS** (≤0 days set to 1)
4. Standardized **name casing** (original had random capitalization)
5. Created derived features: Age Group, Billing Tier, Daily Cost, time dimensions

## Skills Demonstrated

- **Python**: Pandas (55K-row data, datetime handling, pivot tables, groupby), Seaborn, Matplotlib
- **SQL**: Multi-condition aggregations, CTEs, window functions (LAG, RANK), CASE expressions
- **Analytics**: KPI dashboards, billing analysis, LOS modeling, demographic analysis, outcome comparisons
- **Data Cleaning**: Negative value handling, date parsing, feature engineering, outlier detection

## How to Run

```bash
pip install pandas numpy seaborn matplotlib
python analysis.py
```

## Author

**Ernesto** — Data Analyst | Berlin, Germany
