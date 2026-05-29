/*

Purpose
1. This script creates a view (gold.category_performance) designed to evaluate high-level business success at the macro product-group level.
2. By separating and aggregating financial transactions and customer sentiment independently before blending them together,
    it gives executives, procurement teams, and marketing planners a clear view of vertical profitability.
3. It helps identify which major product lines are highly profitable cash cows, which ones have healthy customer reviews,
    and which categories are operating on dangerously thin margins.

*/

DROP VIEW IF EXISTS gold.category_performance;

CREATE VIEW gold.category_performance AS

WITH category_sales AS (

    SELECT
        p.product_category,

        COUNT(DISTINCT oi.order_id) AS total_orders,

        COUNT(DISTINCT oi.product_id) AS total_products_sold,

        SUM(oi.quantity) AS total_quantity_sold,

        ROUND(
            SUM(oi.line_total_usd)::NUMERIC,
            2
        ) AS total_revenue,

        ROUND(
            SUM(oi.quantity * p.cost_usd)::NUMERIC,
            2
        ) AS total_cost,

        ROUND(
            SUM(oi.line_total_usd - (oi.quantity * p.cost_usd))::NUMERIC,
            2
        ) AS total_profit

    FROM gold.fact_order_items oi

    JOIN gold.dim_products p
        ON oi.product_id = p.product_id

    GROUP BY p.product_category
),

category_reviews AS (

    SELECT
        p.product_category,

        COUNT(DISTINCT r.review_id) AS total_reviews,

        ROUND(
            AVG(r.rating)::NUMERIC,
            2
        ) AS average_rating

    FROM gold.dim_products p

    LEFT JOIN gold.fact_reviews r
        ON p.product_id = r.product_id

    GROUP BY p.product_category
)

SELECT
    cs.product_category,
    cs.total_orders,
    cs.total_products_sold,
    cs.total_quantity_sold,
    cs.total_revenue,
    cs.total_cost,
    cs.total_profit,

    ROUND(
        100.0 * cs.total_profit / NULLIF(cs.total_revenue, 0),
        2
    ) AS profit_margin_pct,

    cr.total_reviews,
    cr.average_rating

FROM category_sales cs

LEFT JOIN category_reviews cr
    ON cs.product_category = cr.product_category;
