/*
-------------------------------------------------------------------------------------
DDL Script: Create Bronze Tables
-------------------------------------------------------------------------------------

Script Purpose:
   This script creates tables in the 'Bronze' schema,
   Run this script to re-define the DDL structure of 'Bronze' tables
-------------------------------------------------------------------------------------
*/

DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name TEXT,
    email TEXT,
    country TEXT,
    age INT,
    signup_date DATE,
    marketing_opt_in BOOLEAN
);

DROP TABLE IF EXISTS orders;

CREATE TABLE orders(
	orders_id INT PRIMARY KEY,
	customer_id INT,
	order_time TIMESTAMP,
	payment_method TEXT,
	discount_pct NUMERIC(5,2),
	subtotal_usd NUMERIC(10,2),
	total_usd NUMERIC(10,2),
	country TEXT,
	device TEXT,
	source TEXT
);

DROP TABLE IF EXISTS products;

CREATE TABLE products(
	product_id INT PRIMARY KEY,
	category TEXT,
	name TEXT,
	price_usd NUMERIC(10,2),
	cost_usd NUMERIC(10,2),
	margin_usd NUMERIC(10,2)
);

DROP TABLE IF EXISTS order_items;

CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    unit_price_usd NUMERIC(10,2),
    quantity INT,
    line_total_usd NUMERIC(10,2)
);

DROP TABLE IF EXISTS reviews;

CREATE TABLE reviews(
	review_id INT PRIMARY KEY,
	order_id INT,
	product_id INT,
	rating INT,
	review_text TEXT,
	review_time TIMESTAMP
);

DROP TABLE IF EXISTS sessions;

CREATE TABLE sessions(
	session_id INT PRIMARY KEY,
	customer_id INT,
	start_time TIMESTAMP,
	device TEXT,
	source TEXT,
	country TEXT
);

DROP TABLE IF EXISTS events;

CREATE TABLE events (
    event_id INT PRIMARY KEY,
    session_id INT,
    timestamp TIMESTAMP,
    event_type TEXT,
    product_id NUMERIC,
    qty NUMERIC,
    cart_size NUMERIC,
    payment TEXT,
    discount_pct NUMERIC(5,2),
    amount_usd NUMERIC(10,2)
);

