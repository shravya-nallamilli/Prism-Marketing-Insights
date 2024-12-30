-- rfm_analysis_complete.sql
-- This script performs RFM (Recency, Frequency, Monetary) segmentation and recency analysis for 2020 and 2021.

-- SECTION 1: Full RFM Analysis (2020–2021)
-- Calculates RFM segments (Recency, Frequency, Monetary) and aggregates total revenue for each segment.

SELECT
    EXTRACT(YEAR FROM latest_purchase_date) AS purchase_year,
    CASE 
        WHEN DATE_DIFF(CURRENT_DATE(), latest_purchase_date, DAY) <= 30 THEN 'R1'
        WHEN DATE_DIFF(CURRENT_DATE(), latest_purchase_date, DAY) <= 60 THEN 'R2'
        WHEN DATE_DIFF(CURRENT_DATE(), latest_purchase_date, DAY) <= 90 THEN 'R3'
        ELSE 'R4'
    END AS recency_segment,
    CASE 
        WHEN transaction_count >= 20 THEN 'F1'
        WHEN transaction_count BETWEEN 10 AND 19 THEN 'F2'
        WHEN transaction_count BETWEEN 5 AND 9 THEN 'F3'
        ELSE 'F4'
    END AS frequency_segment,
    CASE 
        WHEN total_revenue >= 1000 THEN 'M1'
        WHEN total_revenue BETWEEN 500 AND 999 THEN 'M2'
        WHEN total_revenue BETWEEN 100 AND 499 THEN 'M3'
        ELSE 'M4'
    END AS monetary_segment,
    SUM(total_revenue) AS total_revenue
FROM 
    `prism-insights.prism_acquire.users`
WHERE 
    latest_purchase_date BETWEEN '2020-01-01' AND '2021-12-31'
GROUP BY 
    purchase_year, recency_segment, frequency_segment, monetary_segment
ORDER BY 
    purchase_year, recency_segment, frequency_segment, monetary_segment;

-- SECTION 2: Recency Segmentation for 2020
-- Groups customers into recency segments (R1–R4) for the year 2020.

WITH recency_data_2020 AS (
  SELECT 
    user_crm_id,
    latest_purchase_date,
    DATE_DIFF(DATE('2020-12-31'), latest_purchase_date, DAY) AS recency_days,
    EXTRACT(YEAR FROM latest_purchase_date) AS purchase_year
  FROM `prism_acquire.users`
  WHERE latest_purchase_date BETWEEN '2020-01-01' AND '2020-12-31'
),

recency_segments_2020 AS (
  SELECT 
    purchase_year,
    CASE
      WHEN recency_days <= 30 THEN 'R1'
      WHEN recency_days BETWEEN 31 AND 60 THEN 'R2'
      WHEN recency_days BETWEEN 61 AND 90 THEN 'R3'
      ELSE 'R4'
    END AS recency_segment,
    COUNT(user_crm_id) AS customer_count
  FROM recency_data_2020
  GROUP BY purchase_year, recency_segment
)

SELECT *
FROM recency_segments_2020
ORDER BY recency_segment;

-- SECTION 3: Recency Segmentation for 2021
-- Groups customers into recency segments (R1–R4) for the year 2021.

WITH recency_data_2021 AS (
  SELECT 
    user_crm_id,
    latest_purchase_date,
    DATE_DIFF(DATE('2021-12-31'), latest_purchase_date, DAY) AS recency_days,
    EXTRACT(YEAR FROM latest_purchase_date) AS purchase_year
  FROM `prism_acquire.users`
  WHERE latest_purchase_date BETWEEN '2021-01-01' AND '2021-12-31'
),

recency_segments_2021 AS (
  SELECT 
    purchase_year,
    CASE
      WHEN recency_days <= 30 THEN 'R1'
      WHEN recency_days BETWEEN 31 AND 60 THEN 'R2'
      WHEN recency_days BETWEEN 61 AND 90 THEN 'R3'
      ELSE 'R4'
    END AS recency_segment,
    COUNT(user_crm_id) AS customer_count
  FROM recency_data_2021
  GROUP BY purchase_year, recency_segment
)

SELECT *
FROM recency_segments_2021
ORDER BY recency_segment;

