/*
===============================================================
DDL Script: Create Gold Views
===============================================================

Script Purpose:
    This script creates views for the Gold layer in the data warehouse.
   
    Each view performs transformations and combines data from the Silver layer
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================
*/

CREATE OR REPLACE VIEW gold.dim_customers AS
SELECT
    customer_id,
    customer_name,
    email,
    country_code,
    age,
    signup_date,
    marketing_opt_in
FROM silver.customers;

CREATE OR REPLACE VIEW gold.dim_products AS
SELECT
    product_id,
    product_category,
    product_name,
    price_usd,
    cost_usd,
    margin_usd
FROM silver.products;

CREATE OR REPLACE VIEW gold.fact_orders AS
SELECT
    orders_id,
    customer_id,
    order_time,
    order_date,
    payment_method,
    discount_pct,
    order_subtotal_usd,
    order_total_usd,
    country_code,
    device_type,
    traffic_source
FROM silver.orders;

CREATE OR REPLACE VIEW gold.fact_order_items AS
SELECT
    order_id,
    product_id,
    unit_price_usd,
    quantity,
    line_total_usd
FROM silver.order_items;

CREATE OR REPLACE VIEW gold.fact_events AS
SELECT
    event_id,
    session_id,
    product_id,
    event_time,
    event_date,
    event_type,
    quantity,
    cart_size,
    payment_method,
    discount_pct,
    event_amount_usd
FROM silver.events;

CREATE OR REPLACE VIEW gold.fact_sessions AS
SELECT
    session_id,
    customer_id,
    session_start_time,
    session_date,
    device_type,
    traffic_source,
    country_code
FROM silver.sessions;

CREATE OR REPLACE VIEW gold.fact_reviews AS
SELECT
    review_id,
    order_id,
    product_id,
    rating,
    review_text,
    review_date
FROM silver.reviews;

