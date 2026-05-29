/*
Purpose:
This script builds a reusable reporting view (gold.product_performance) that tracks how well individual items and product categories are selling.
By joining transactional sales details with product descriptive data, it computes volume, revenue, costs, and profit margins in one centralized place.
*/

CREATE OR REPLACE VIEW gold.product_performance AS

SELECT
	p.product_id,
	p.product_name,
	p.product_category,
	COUNT(DISTINCT oi.order_id) AS total_orders,
	SUM(oi.quantity) AS total_quantity_sold,
	ROUND(
		SUM(oi.line_total_usd)::NUMERIC, 2
	) AS total_revenue,
	ROUND(
		SUM(oi.quantity * p.cost_usd)::NUMERIC, 2
	) AS total_cost,
	ROUND(
		SUM(oi.line_total_usd - (oi.quantity * p.cost_usd))::NUMERIC, 2
	) AS total_profit,
	ROUND(
		AVG(oi.line_total_usd)::NUMERIC, 2
	) AS avg_order_product_value
FROM gold.fact_order_items oi
JOIN gold.dim_products p
ON oi.product_id = p.product_id
GROUP BY 
	p.product_id,
	p.product_name,
	p.product_category;
