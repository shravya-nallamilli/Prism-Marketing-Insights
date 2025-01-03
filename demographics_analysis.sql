-- demographics_top_purchases_by_gender.sql
-- This script analyses customer purchases by gender, categorizing customers into spending segments.

-- SECTION 1: Segment Customers by Spending
WITH Segmented_Customers AS (
    SELECT 
        user_crm_id, -- Unique customer ID
        DATE_DIFF(latest_purchase_date, first_purchase_date, DAY) AS customer_lifecycle_days, -- Total lifecycle days
        DATE_DIFF(CURRENT_DATE(), latest_purchase_date, DAY) AS days_since_last_purchase, -- Days since last purchase
        transaction_count, -- Total transactions per customer
        total_revenue, -- Total revenue generated by the customer
        CASE 
            WHEN total_revenue >= 5000 THEN 'High Spender'
            WHEN total_revenue >= 1000 THEN 'Medium Spender'
            ELSE 'Low Spender'
        END AS spending_segment -- Spending category
    FROM 
        `prism-insights.prism_acquire.users`
    WHERE 
        DATE_DIFF(latest_purchase_date, first_purchase_date, DAY) > 0 -- Exclude customers with 0 lifecycle days
)

-- SECTION 2: Analyse Transactions by Gender
SELECT
    u.user_gender, -- Customer gender
    COUNT(t.transaction_id) AS transaction_count -- Total transactions by gender
FROM
    prism-insights.prism_acquire.transactions t
JOIN
    prism-insights.prism_acquire.users u ON t.user_crm_id = u.user_crm_id
GROUP BY
    u.user_gender -- Group data by gender
ORDER BY
    transaction_count DESC; -- Order by number of transactions in descending order
