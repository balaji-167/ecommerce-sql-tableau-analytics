/*

Purpose:
This script creates a view (gold.cohort_retention) that groups customers into "cohorts" based on the month they made their very first purchase.
It then tracks what percentage of each cohort returns to buy again in subsequent months.
This is a foundational matrix used by businesses to measure customer lifetime value (LTV) and churn.

*/

CREATE OR REPLACE VIEW gold.cohort_retention AS

WITH first_purchase AS (
    SELECT
        customer_id,
        DATE_TRUNC('month', MIN(order_date)) AS cohort_month
    FROM gold.fact_orders
    GROUP BY customer_id
),

customer_activity AS (
    SELECT DISTINCT
        o.customer_id,
        fp.cohort_month,
        DATE_TRUNC('month', o.order_date) AS activity_month,
        (
            EXTRACT(YEAR FROM AGE(DATE_TRUNC('month', o.order_date), fp.cohort_month)) * 12
            +
            EXTRACT(MONTH FROM AGE(DATE_TRUNC('month', o.order_date), fp.cohort_month))
        )::INT AS month_number
    FROM gold.fact_orders o
    JOIN first_purchase fp
        ON o.customer_id = fp.customer_id
),

cohort_size AS (
    SELECT
        cohort_month,
        COUNT(DISTINCT customer_id) AS cohort_customers
    FROM first_purchase
    GROUP BY cohort_month
),

retention_counts AS (
    SELECT
        cohort_month,
        month_number,
        COUNT(DISTINCT customer_id) AS retained_customers
    FROM customer_activity
    GROUP BY cohort_month, month_number
)

SELECT
    rc.cohort_month,
    rc.month_number,
    cs.cohort_customers,
    rc.retained_customers,
    ROUND(
        100.0 * rc.retained_customers / cs.cohort_customers,
        2
    ) AS retention_rate_pct
FROM retention_counts rc
JOIN cohort_size cs
    ON rc.cohort_month = cs.cohort_month
ORDER BY
    rc.cohort_month,
    rc.month_number;
