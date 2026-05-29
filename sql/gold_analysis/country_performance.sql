/*

Purpose:
1. This script creates a view (gold.country_performance) designed to analyze geographic market penetration and regional purchasing patterns.
2. By joining localized customer profiles with core transactional orders, it calculates regional revenue density and per-customer engagement depths.
3. This allows expansion, marketing, and supply chain teams to identify primary geographic strongholds, track international revenue generation,
    and isolate regions with low order frequencies that might need local promotional campaigns or improved shipping options.

*/

DROP VIEW IF EXISTS gold.country_performance;

CREATE VIEW gold.country_performance AS

WITH country_orders AS (

    SELECT
        c.country_code,

        COUNT(DISTINCT c.customer_id) AS total_customers,

        COUNT(DISTINCT o.orders_id) AS total_orders,

        ROUND(
            SUM(o.order_total_usd)::NUMERIC,
            2
        ) AS total_revenue,

        ROUND(
            AVG(o.order_total_usd)::NUMERIC,
            2
        ) AS average_order_value

    FROM gold.fact_orders o

    JOIN gold.dim_customers c
        ON o.customer_id = c.customer_id

    GROUP BY c.country_code
),

country_customer_value AS (

    SELECT
        country_code,

        ROUND(
            total_revenue / NULLIF(total_customers, 0),
            2
        ) AS revenue_per_customer,

        ROUND(
            total_orders::NUMERIC / NULLIF(total_customers, 0),
            2
        ) AS orders_per_customer

    FROM country_orders
)

SELECT
    co.country_code,
    co.total_customers,
    co.total_orders,
    co.total_revenue,
    co.average_order_value,
    ccv.revenue_per_customer,
    ccv.orders_per_customer

FROM country_orders co

JOIN country_customer_value ccv
    ON co.country_code = ccv.country_code;
