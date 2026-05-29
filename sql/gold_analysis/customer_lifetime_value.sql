/*

Purpose:
1. This script creates a view (gold.customer_lifetime_value) designed to track the long-term financial worth of each customer to the business.
2. By aggregating a customer's entire transactional history from their first purchase to their last, it establishes their lifespan duration and baseline financial value.
3. This data allows marketing and finance teams to identify top-tier spenders
4. Determine how much money the business can logically afford to spend on acquiring similar new customers (Customer Acquisition Cost - CAC).

*/

DROP VIEW IF EXISTS gold.customer_lifetime_value;

CREATE VIEW gold.customer_lifetime_value AS

WITH customer_summary AS (

    SELECT
        customer_id,

        MIN(order_date) AS first_order_date,

        MAX(order_date) AS last_order_date,

        COUNT(DISTINCT orders_id) AS total_orders,

        ROUND(
            SUM(order_total_usd)::NUMERIC,
            2
        ) AS lifetime_revenue,

        ROUND(
            AVG(order_total_usd)::NUMERIC,
            2
        ) AS avg_order_value

    FROM gold.fact_orders

    GROUP BY customer_id
)

SELECT
    customer_id,

    first_order_date,

    last_order_date,

    (last_order_date - first_order_date) AS customer_lifespan_days,

    total_orders,

    avg_order_value,

    lifetime_revenue,

    ROUND(
        lifetime_revenue / total_orders,
        2
    ) AS revenue_per_order

FROM customer_summary;
