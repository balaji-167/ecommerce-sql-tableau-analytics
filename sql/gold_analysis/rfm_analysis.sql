/*

Purpose:
This script creates a view (gold.rfm_analysis) that implements an RFM (Recency, Frequency, Monetary) customer segmentation framework.
It evaluates and scores customers based on how recently they bought, how often they buy, and how much they spend.
Businesses use this to identify their most loyal customers, big spenders, or those at risk of churning.

*/

DROP VIEW IF EXISTS gold.rfm_analysis;

CREATE VIEW gold.rfm_analysis AS

WITH customer_rfm AS (
	SELECT customer_id,
		MAX(order_date) AS last_order_date,
		CURRENT_DATE - MAX(order_date) AS recency_days,
		COUNT(DISTINCT orders_id) AS frequency,
		ROUND(SUM(order_total_usd)::NUMERIC, 2) AS monetary_value
	FROM gold.fact_orders
	GROUP BY customer_id
),

rfm_scores AS (
	SELECT *,
		NTILE(5) OVER (ORDER BY recency_days DESC) AS recency_score,
		NTILE(5) OVER (ORDER BY frequency) AS frequency_score,
		NTILE(5) OVER (ORDER BY monetary_value) AS monetary_score
	FROM customer_rfm
)

SELECT
    customer_id,
    last_order_date,
    recency_days,
    frequency,
    monetary_value,

    recency_score,
    frequency_score,
    monetary_score,

    CONCAT(
        recency_score,
		',',
        frequency_score,
		',',
        monetary_score
    ) AS rfm_score

FROM rfm_scores;
