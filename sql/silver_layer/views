/*

=============================================================================================================
Silver Layer Update: We have utilized Views for the Silver Layer to handle data standardization and cleaning.
=============================================================================================================

*/

CREATE OR REPLACE VIEW silver.customers AS 
SELECT
	customer_id,
	TRIM(name) AS customer_name,
	LOWER(TRIM(email)) AS email,
	UPPER(TRIM(country)) AS country_code,
	age,
	signup_date,
	marketing_opt_in
FROM bronze.customers;

CREATE OR REPLACE VIEW silver.orders AS
SELECT
	orders_id,
	customer_id,
	order_time,
	DATE(order_time) AS order_date,
	LOWER(TRIM(payment_method)) AS payment_method,
	discount_pct,
	subtotal_usd AS order_subtotal_usd,
	total_usd AS order_total_usd,
	UPPER(TRIM(country)) AS country_code,
	LOWER(TRIM(device)) AS device_type,
    LOWER(TRIM(source)) AS traffic_source
FROM bronze.orders;	

CREATE OR REPLACE VIEW silver.products AS
SELECT
	product_id,
	INITCAP(TRIM(category)) AS product_category,
	TRIM(name) AS product_name,
	price_usd,
	cost_usd,
	margin_usd
FROM bronze.products;

CREATE OR REPLACE VIEW silver.order_items AS
SELECT
    order_id,
    product_id,
    unit_price_usd,
    quantity,
    line_total_usd
FROM bronze.order_items;

CREATE OR REPLACE VIEW silver.sessions AS
SELECT
    session_id,
    customer_id,
    start_time AS session_start_time,
    DATE(start_time) AS session_date,
    LOWER(TRIM(device)) AS device_type,
    LOWER(TRIM(source)) AS traffic_source,
    UPPER(TRIM(country)) AS country_code
FROM bronze.sessions;

CREATE OR REPLACE VIEW silver.events AS 
SELECT 
	event_id,
	session_id,
	"timestamp" AS event_time,
	DATE("timestamp") AS event_date,
	product_id::INT AS product_id,
	LOWER(TRIM(event_type)) AS event_type,
	qty::INT AS quantity,
	cart_size::INT AS cart_size,
	LOWER(TRIM(payment)) AS payment_method,
    discount_pct,
    amount_usd AS event_amount_usd
FROM bronze.events;

CREATE OR REPLACE VIEW silver.reviews AS
SELECT
	review_id,
	order_id,
	product_id,
	rating,
    TRIM(review_text) AS review_text,
    DATE(review_time) AS review_date
FROM bronze.reviews;

