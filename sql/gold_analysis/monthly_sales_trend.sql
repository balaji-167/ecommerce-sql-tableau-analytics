/*

Purpose:
1. This script creates a view (gold.monthly_sales_trend) designed to track chronological business trajectory and financial velocity over time.
2. By aggregating sales metrics at a monthly level and comparing them directly against the immediate previous month, it establishes baseline macro-trends.
3. This data allows finance, executive leadership, and growth teams to measure compounding Month-over-Month (MoM) expansion, track buyer behavior shift,
    and identify seasonal demand spikes.

*/

DROP VIEW IF EXISTS gold.monthly_sales_trend;

CREATE VIEW gold.monthly_sales_trend AS

WITH monthly_sales AS (

    SELECT
        DATE_TRUNC('month', order_date) AS sales_month,

        COUNT(DISTINCT orders_id) AS total_orders,

        COUNT(DISTINCT customer_id) AS purchasing_customers,

        ROUND(
            SUM(order_total_usd)::NUMERIC,
            2
        ) AS total_revenue,

        ROUND(
            AVG(order_total_usd)::NUMERIC,
            2
        ) AS average_order_value,

        ROUND(
            AVG(discount_pct)::NUMERIC,
            2
        ) AS average_discount_pct

    FROM gold.fact_orders

    GROUP BY DATE_TRUNC('month', order_date)
),

trend_metrics AS (

    SELECT
        sales_month,
        total_orders,
        purchasing_customers,
        total_revenue,
        average_order_value,
        average_discount_pct,

        LAG(total_revenue) OVER (
            ORDER BY sales_month
        ) AS previous_month_revenue,

        LAG(total_orders) OVER (
            ORDER BY sales_month
        ) AS previous_month_orders

    FROM monthly_sales
)

SELECT
    sales_month,
    total_orders,
    purchasing_customers,
    total_revenue,
    average_order_value,
    average_discount_pct,
    previous_month_revenue,
    previous_month_orders,

    ROUND(
        100.0 * (total_revenue - previous_month_revenue)
        / NULLIF(previous_month_revenue, 0),
        2
    ) AS revenue_mom_growth_pct,

    ROUND(
        100.0 * (total_orders - previous_month_orders)
        / NULLIF(previous_month_orders, 0),
        2
    ) AS orders_mom_growth_pct

FROM trend_metrics;
