/*

Purpose:
This script creates a view (gold.churn_analysis) designed to monitor customer retention and detect business attrition.
It calculates how long it has been since each customer last bought a product and categorizes them into lifecycle statuses based on inactivity thresholds.
This enables the business to instantly flag dormant users and trigger win-back strategies before the customers are lost permanently.

*/

DROP VIEW IF EXISTS gold.churn_analysis;

CREATE VIEW gold.churn_analysis AS

WITH max_date AS (

    SELECT
        MAX(order_date) AS dataset_last_date
    FROM gold.fact_orders
),

customer_activity AS (

    SELECT
        customer_id,

        MAX(order_date) AS last_order_date,

        (
            SELECT dataset_last_date
            FROM max_date
        ) - MAX(order_date) AS days_since_last_order,

        COUNT(DISTINCT orders_id) AS total_orders,

        ROUND(
            SUM(order_total_usd)::NUMERIC,
            2
        ) AS total_spent

    FROM gold.fact_orders

    GROUP BY customer_id
)

SELECT
    customer_id,
    last_order_date,
    days_since_last_order,
    total_orders,
    total_spent,

    CASE

        WHEN days_since_last_order <= 30
            THEN 'Active'

        WHEN days_since_last_order <= 90
            THEN 'At Risk'

        ELSE 'Churned'

    END AS customer_status

FROM customer_activity;
