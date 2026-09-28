# Marketing Campaign ROI Analysis

An end-to-end marketing analytics project using **Python, SQL, statistics, and Power BI** to evaluate campaign efficiency, conversion performance, customer intent, and return on advertising spend.

## Business Problem

Marketing teams need to understand which campaigns and channels generate efficient customer acquisition and revenue. This project builds a repeatable analytical workflow to:

- audit and validate campaign data
- clean and engineer analysis-ready features
- measure acquisition and conversion KPIs
- compare advertising platforms
- evaluate retargeting performance
- test whether observed conversion differences are statistically significant
- prepare insights for an interactive Power BI dashboard

## Dataset

- **10,000 campaign records**
- **43 fields**
- Campaign, audience, creative, platform, engagement, conversion, spend, revenue and profitability attributes

## Tools

- **Python:** Pandas, NumPy, Matplotlib, SciPy
- **SQL:** MySQL-compatible analytical queries
- **Power BI:** KPI reporting and interactive dashboarding
- **Statistics:** Welch's independent t-test, chi-square test, confidence interval

## Analytical Workflow

### 1. Data Audit

The audit checks:

- duplicate records
- missing values
- impossible relationships such as clicks exceeding impressions or conversions exceeding clicks
- negative spend/revenue values
- zero-denominator cases
- consistency between supplied and recalculated KPIs

Core metrics were independently recalculated for CTR, CPC, conversion rate, CPA, ROAS and profit.

### 2. Data Cleaning & Feature Engineering

The cleaning workflow includes date conversion, handling zero-conversion campaigns for CPA analysis, and creation of a `conversion_status` feature.

CPA is treated as undefined for campaigns with zero conversions rather than forcing an artificial numeric value.

### 3. KPI Analysis

| KPI | Result |
|---|---:|
| Impressions | 705,392,200 |
| Clicks | 15,264,360 |
| Conversions | 655,688 |
| Ad Spend | 43,455,660 |
| Revenue | 284,157,700 |
| Profit | 240,702,000 |
| Overall CTR | 2.164% |
| Overall Conversion Rate | 4.296% |
| Overall ROAS | 6.539x |
| Overall CPA | 66.27 |

### 4. Platform Performance

Platform performance was evaluated using campaign count, spend, revenue, conversions, median ROAS, median CPA, median conversion rate, median CTR and total profit.

The analysis deliberately uses **median campaign-level efficiency metrics** alongside aggregate totals, because a platform's total revenue can be heavily influenced by the amount of spend or number of campaigns it receives.

### 5. Retargeting Analysis

Retargeting represented **24.7%** of campaigns, compared with **75.3%** non-retargeting.

| Group | Campaigns | Mean Conversion Rate | Median Conversion Rate |
|---|---:|---:|---:|
| Non-retargeting | 7,530 | 3.142% | 1.905% |
| Retargeting | 2,470 | 5.174% | 3.236% |

The difference in mean conversion rate was **2.032 percentage points**.

A Welch independent t-test produced:

- t = **17.36**
- p ≈ **1.04 × 10⁻⁶⁴**
- 95% CI for the mean difference: approximately **1.80 to 2.26 percentage points**

This provides strong statistical evidence of a difference in conversion rates between the two groups in this dataset. It does **not**, by itself, establish that retargeting caused the difference, because this is observational campaign data rather than a randomized experiment.

### 6. Purchase Intent Test

A chi-square test was used to examine the relationship between `retargeting_flag` and `purchase_intent_score`.

- χ² ≈ **1.70**
- p ≈ **0.427**
- df = **2**

The test does not provide statistical evidence of an association between these two categorical variables in this dataset.

## Key Takeaways

1. The dataset represents a large-scale campaign environment with **705M+ impressions and 655K+ conversions**.
2. Overall advertising performance was **6.54x ROAS** with a **4.30% conversion rate**.
3. Platform efficiency varies substantially when evaluated using campaign-level median metrics.
4. Retargeting campaigns show a materially higher average conversion rate than non-retargeting campaigns in this dataset.
5. The retargeting conversion-rate difference is statistically significant, while the relationship between retargeting and purchase-intent category is not statistically significant.
6. Statistical significance should be interpreted alongside campaign design and potential confounding factors rather than as proof of causality.

## Repository Structure

```text
marketing-campaign-roi-analysis/
│
├── data/
│   └── marketing_campaigns_cleaned.csv
│
├── notebooks/
│   ├── 01_data_audit.ipynb
│   ├── 02_data_cleaning.ipynb
│   └── 03_eda.ipynb
│
├── sql/
│   └── marketing_campaign_analysis.sql
│
├── dashboard/
│   └── README.md
│
├── docs/
│   └── methodology.md
│
├── README.md
├── requirements.txt
└── .gitignore
```

## How to Reproduce

1. Clone the repository.
2. Install the Python dependencies in `requirements.txt`.
3. Run the notebooks in order: audit → cleaning → EDA.
4. Load the cleaned CSV into MySQL and run the SQL analysis queries.
5. Open the Power BI dashboard using the included cleaned dataset.

## Important Note on the Dashboard

The Power BI `.pbix` file is intentionally not embedded in this repository package yet. Add the final dashboard file or dashboard screenshots after the visual layout has been finalized.
