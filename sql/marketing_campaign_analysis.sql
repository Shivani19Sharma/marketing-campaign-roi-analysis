-- Marketing Campaign ROI Analysis
-- Purpose: SQL analysis layer for the Marketing Campaign ROI project
-- Assumed table name: marketing_campaigns
-- Dialect: MySQL 8+

-- ============================================================
-- 1. DATASET OVERVIEW
-- ============================================================

SELECT
    COUNT(*) AS total_campaigns,
    COUNT(DISTINCT campaign_id) AS unique_campaigns,
    SUM(impressions) AS total_impressions,
    SUM(clicks) AS total_clicks,
    SUM(conversions) AS total_conversions,
    ROUND(SUM(ad_spend), 2) AS total_ad_spend,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit
FROM marketing_campaigns;


-- ============================================================
-- 2. OVERALL CAMPAIGN KPIs
-- ============================================================

SELECT
    ROUND(100.0 * SUM(clicks) / NULLIF(SUM(impressions), 0), 2) AS overall_ctr_pct,
    ROUND(100.0 * SUM(conversions) / NULLIF(SUM(clicks), 0), 2) AS overall_conversion_rate_pct,
    ROUND(SUM(ad_spend) / NULLIF(SUM(conversions), 0), 2) AS overall_cpa,
    ROUND(SUM(revenue) / NULLIF(SUM(ad_spend), 0), 2) AS overall_roas,
    ROUND(SUM(revenue) - SUM(ad_spend), 2) AS overall_profit
FROM marketing_campaigns;


-- ============================================================
-- 3. PLATFORM PERFORMANCE
-- ============================================================

SELECT
    platform,
    COUNT(*) AS campaigns,
    SUM(impressions) AS impressions,
    SUM(clicks) AS clicks,
    SUM(conversions) AS conversions,
    ROUND(SUM(ad_spend), 2) AS total_spend,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(100.0 * SUM(clicks) / NULLIF(SUM(impressions), 0), 2) AS ctr_pct,
    ROUND(100.0 * SUM(conversions) / NULLIF(SUM(clicks), 0), 2) AS conversion_rate_pct,
    ROUND(SUM(ad_spend) / NULLIF(SUM(conversions), 0), 2) AS cpa,
    ROUND(SUM(revenue) / NULLIF(SUM(ad_spend), 0), 2) AS roas
FROM marketing_campaigns
GROUP BY platform
ORDER BY roas DESC;


-- ============================================================
-- 4. PLATFORM PERFORMANCE USING MEDIAN METRICS
--    MySQL 8+ percentile functions
-- ============================================================

SELECT
    platform,
    ROUND(
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY ROAS), 2
    ) AS median_roas,
    ROUND(
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY conversion_rate), 2
    ) AS median_conversion_rate_pct,
    ROUND(
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY CPA_clean), 2
    ) AS median_cpa
FROM marketing_campaigns
WHERE CPA_clean IS NOT NULL
GROUP BY platform
ORDER BY median_roas DESC;


-- ============================================================
-- 5. RETARGETING VS NON-RETARGETING
-- ============================================================

SELECT
    retargeting_flag,
    COUNT(*) AS campaigns,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS campaign_share_pct,
    ROUND(AVG(CTR), 2) AS avg_ctr_pct,
    ROUND(AVG(conversion_rate), 2) AS avg_conversion_rate_pct,
    ROUND(AVG(CPA_clean), 2) AS avg_cpa,
    ROUND(AVG(ROAS), 2) AS avg_roas,
    ROUND(AVG(profit), 2) AS avg_profit
FROM marketing_campaigns
GROUP BY retargeting_flag
ORDER BY retargeting_flag;


-- ============================================================
-- 6. RETARGETING PERFORMANCE — MEDIAN VIEW
-- ============================================================

SELECT
    retargeting_flag,
    COUNT(*) AS campaigns,
    ROUND(AVG(CTR), 2) AS avg_ctr_pct,
    ROUND(
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY CTR), 2
    ) AS median_ctr_pct,
    ROUND(
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY conversion_rate), 2
    ) AS median_conversion_rate_pct,
    ROUND(
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY CPA_clean), 2
    ) AS median_cpa,
    ROUND(
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY ROAS), 2
    ) AS median_roas,
    ROUND(
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY profit), 2
    ) AS median_profit
FROM marketing_campaigns
WHERE CPA_clean IS NOT NULL
GROUP BY retargeting_flag;


-- ============================================================
-- 7. CAMPAIGN OBJECTIVE PERFORMANCE
-- ============================================================

SELECT
    campaign_objective,
    COUNT(*) AS campaigns,
    ROUND(SUM(ad_spend), 2) AS total_spend,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(100.0 * SUM(clicks) / NULLIF(SUM(impressions), 0), 2) AS ctr_pct,
    ROUND(100.0 * SUM(conversions) / NULLIF(SUM(clicks), 0), 2) AS conversion_rate_pct,
    ROUND(SUM(ad_spend) / NULLIF(SUM(conversions), 0), 2) AS cpa,
    ROUND(SUM(revenue) / NULLIF(SUM(ad_spend), 0), 2) AS roas
FROM marketing_campaigns
GROUP BY campaign_objective
ORDER BY roas DESC;


-- ============================================================
-- 8. DEVICE PERFORMANCE
-- ============================================================

SELECT
    device_type,
    COUNT(*) AS campaigns,
    ROUND(SUM(ad_spend), 2) AS total_spend,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(revenue) / NULLIF(SUM(ad_spend), 0), 2) AS roas,
    ROUND(100.0 * SUM(clicks) / NULLIF(SUM(impressions), 0), 2) AS ctr_pct,
    ROUND(100.0 * SUM(conversions) / NULLIF(SUM(clicks), 0), 2) AS conversion_rate_pct
FROM marketing_campaigns
GROUP BY device_type
ORDER BY roas DESC;


-- ============================================================
-- 9. CREATIVE FORMAT PERFORMANCE
-- ============================================================

SELECT
    creative_format,
    COUNT(*) AS campaigns,
    ROUND(SUM(ad_spend), 2) AS total_spend,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(revenue) / NULLIF(SUM(ad_spend), 0), 2) AS roas,
    ROUND(100.0 * SUM(clicks) / NULLIF(SUM(impressions), 0), 2) AS ctr_pct,
    ROUND(100.0 * SUM(conversions) / NULLIF(SUM(clicks), 0), 2) AS conversion_rate_pct
FROM marketing_campaigns
GROUP BY creative_format
ORDER BY roas DESC;


-- ============================================================
-- 10. HIGH-VALUE CAMPAIGNS
-- ============================================================

SELECT
    campaign_id,
    platform,
    campaign_objective,
    creative_format,
    ad_spend,
    revenue,
    conversions,
    ROAS,
    profit
FROM marketing_campaigns
ORDER BY ROAS DESC
LIMIT 20;


-- ============================================================
-- 11. LOSS-MAKING CAMPAIGNS
-- ============================================================

SELECT
    campaign_id,
    platform,
    campaign_objective,
    ad_spend,
    revenue,
    conversions,
    ROAS,
    profit
FROM marketing_campaigns
WHERE profit < 0
ORDER BY profit ASC
LIMIT 20;


-- ============================================================
-- 12. PURCHASE INTENT BY RETARGETING
-- ============================================================

SELECT
    retargeting_flag,
    purchase_intent_score,
    COUNT(*) AS campaigns,
    ROUND(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER (PARTITION BY retargeting_flag), 2
    ) AS share_within_retargeting_group_pct
FROM marketing_campaigns
GROUP BY retargeting_flag, purchase_intent_score
ORDER BY retargeting_flag, purchase_intent_score;


-- ============================================================
-- 13. MONTHLY PERFORMANCE TREND
-- ============================================================

SELECT
    YEAR(start_date) AS campaign_year,
    MONTH(start_date) AS campaign_month,
    COUNT(*) AS campaigns,
    ROUND(SUM(ad_spend), 2) AS total_spend,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(revenue) / NULLIF(SUM(ad_spend), 0), 2) AS roas
FROM marketing_campaigns
GROUP BY YEAR(start_date), MONTH(start_date)
ORDER BY campaign_year, campaign_month;
