/*

Purpose:
This script builds a reusable view (gold.sales_kpis) to act as a single source of truth for our core business performance metrics.
It aggregates transaction data from gold.fact_orders into a clean, presentation-ready layer for dashboards and stakeholder reporting.

*/

CREATE OR REPLACE VIEW gold.sales_kpis AS

SELECT 
	COUNT(DISTINCT orders_id) AS total_orders,
	COUNT(DISTINCT customer_id) AS total_customers,
	ROUND(SUM(order_total_usd)::NUMERIC, 2) AS total_revenue,
	ROUND(AVG(order_total_usd)::NUMERIC, 2) AS average_order_value,
	ROUND(
		PERCENTILE_CONT(0.5)
		WITHIN GROUP (ORDER BY order_total_usd)::NUMERIC,
		2
	) AS median_order_value,
	ROUND(
		SUM(order_total_usd)::NUMERIC / COUNT(DISTINCT customer_id),
		2
	) AS revenue_per_customer
FROM gold.fact_orders;
