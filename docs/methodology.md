# Methodology Notes

## KPI Definitions

- CTR = clicks / impressions × 100
- CPC = ad spend / clicks
- Conversion Rate = conversions / clicks × 100
- CPA = ad spend / conversions
- ROAS = revenue / ad spend
- Profit = revenue − ad spend

## Statistical Tests

### Retargeting conversion rate
Welch's independent two-sample t-test was selected because it does not assume equal population variances.

### Retargeting and purchase intent
A chi-square test of independence was used for the two categorical variables `retargeting_flag` and `purchase_intent_score`.

## Interpretation Caveat

The statistical tests identify patterns in the available observational data. They do not establish causal effects of retargeting or other campaign attributes.
