-- behavioural_analysis_revenue_contribution.sql
-- This script analyses revenue contribution by spending segment and year, along with the customer count for each segment.

SELECT
    EXTRACT(YEAR FROM latest_purchase_date) AS purchase_year, -- Extracts the year from the latest purchase date
    CASE
        WHEN total_revenue >= 1000 THEN 'High Spender' -- Customers with revenue >= 1000
        WHEN total_revenue >= 100 THEN 'Medium Spender' -- Customers with revenue >= 100 and < 1000
        ELSE 'Low Spender' -- Customers with revenue < 100
    END AS spending_segment, -- Categorizes customers into spending segments
    COUNT(DISTINCT user_crm_id) AS customer_count, -- Counts distinct customers in each spending segment
    SUM(total_revenue) AS total_revenue -- Calculates total revenue for each spending segment
FROM 
    `prism-insights.prism_acquire.users`
WHERE 
    DATE_DIFF(latest_purchase_date, first_purchase_date, DAY) > 0 -- Excludes customers with invalid lifecycle
    AND latest_purchase_date BETWEEN '2020-01-01' AND '2021-12-31' -- Filters data for 2020 and 2021
GROUP BY 
    purchase_year, -- Groups results by year
    spending_segment -- Groups results by spending segment
ORDER BY 
    purchase_year, -- Orders results by year
    spending_segment; -- Orders results by spending segment
