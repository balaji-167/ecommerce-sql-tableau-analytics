/*

Purpose:
1. This script creates a view (gold.review_analysis) designed to cross-reference customer feedback metrics with actual commercial performance.
2. By combining product ratings with sales volumes and revenue data, it allows product managers, quality assurance teams, and marketing analysts
   to understand how product satisfaction impacts financial performance and to instantly identify which inventory items are driving customer frustration.

*/

DROP VIEW IF EXISTS gold.review_analysis;

CREATE VIEW gold.review_analysis AS

WITH review_summary AS (

    SELECT
        r.product_id,

        COUNT(DISTINCT r.review_id) AS total_reviews,

        ROUND(
            AVG(r.rating)::NUMERIC,
            2
        ) AS avg_rating,

        MIN(r.rating) AS min_rating,

        MAX(r.rating) AS max_rating

    FROM gold.fact_reviews r

    GROUP BY r.product_id
),

product_sales AS (

    SELECT
        oi.product_id,

        COUNT(DISTINCT oi.order_id) AS total_orders,

        SUM(oi.quantity) AS total_quantity_sold,

        ROUND(
            SUM(oi.line_total_usd)::NUMERIC,
            2
        ) AS total_revenue

    FROM gold.fact_order_items oi

    GROUP BY oi.product_id
)

SELECT
    p.product_id,
    p.product_name,
    p.product_category,

    COALESCE(rs.total_reviews, 0) AS total_reviews,
    rs.avg_rating,
    rs.min_rating,
    rs.max_rating,

    COALESCE(ps.total_orders, 0) AS total_orders,
    COALESCE(ps.total_quantity_sold, 0) AS total_quantity_sold,
    COALESCE(ps.total_revenue, 0) AS total_revenue,

    CASE
        WHEN rs.avg_rating >= 4.5 AND rs.total_reviews >= 5
            THEN 'Highly Rated'

        WHEN rs.avg_rating >= 4.0
            THEN 'Good'

        WHEN rs.avg_rating >= 3.0
            THEN 'Average'

        WHEN rs.avg_rating < 3.0
            THEN 'Needs Attention'

        ELSE 'No Reviews'
    END AS rating_segment

FROM gold.dim_products p

LEFT JOIN review_summary rs
    ON p.product_id = rs.product_id

LEFT JOIN product_sales ps
    ON p.product_id = ps.product_id;
