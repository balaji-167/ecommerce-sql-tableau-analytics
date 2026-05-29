/*

Purpose
1. This script creates a view (gold.source_device_conversion) designed to measure and compare marketing performance and user experience across different hardware platforms,
   marketing channels, and geographic regions.
2. By cross-referencing session metadata with chronological clickstream events, it calculates multi-dimensional conversion rates.
3. This allows marketing teams to see which combinations are converting into actual paying buyers and which ones are underperforming.

*/

DROP VIEW IF EXISTS gold.source_device_conversion;

CREATE VIEW gold.source_device_conversion AS

WITH session_base AS (

    SELECT
        s.session_id,
        s.customer_id,
        s.device_type,
        s.traffic_source,
        s.country_code
    FROM gold.fact_sessions s
),

session_events AS (

    SELECT
        session_id,

        MAX(CASE WHEN event_type = 'page_view' THEN 1 ELSE 0 END) AS has_page_view,

        MAX(CASE WHEN event_type = 'add_to_cart' THEN 1 ELSE 0 END) AS has_add_to_cart,

        MAX(CASE WHEN event_type = 'checkout' THEN 1 ELSE 0 END) AS has_checkout,

        MAX(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) AS has_purchase

    FROM gold.fact_events

    GROUP BY session_id
),

combined AS (

    SELECT
        sb.session_id,
        sb.customer_id,
        sb.device_type,
        sb.traffic_source,
        sb.country_code,

        COALESCE(se.has_page_view, 0) AS has_page_view,
        COALESCE(se.has_add_to_cart, 0) AS has_add_to_cart,
        COALESCE(se.has_checkout, 0) AS has_checkout,
        COALESCE(se.has_purchase, 0) AS has_purchase

    FROM session_base sb

    LEFT JOIN session_events se
        ON sb.session_id = se.session_id
)

SELECT
    device_type,
    traffic_source,
    country_code,

    COUNT(DISTINCT session_id) AS total_sessions,

    SUM(has_page_view) AS page_view_sessions,
    SUM(has_add_to_cart) AS add_to_cart_sessions,
    SUM(has_checkout) AS checkout_sessions,
    SUM(has_purchase) AS purchase_sessions,

    ROUND(
        100.0 * SUM(has_add_to_cart) / NULLIF(SUM(has_page_view), 0),
        2
    ) AS add_to_cart_rate_pct,

    ROUND(
        100.0 * SUM(has_checkout) / NULLIF(SUM(has_add_to_cart), 0),
        2
    ) AS checkout_rate_pct,

    ROUND(
        100.0 * SUM(has_purchase) / NULLIF(SUM(has_page_view), 0),
        2
    ) AS purchase_conversion_rate_pct

FROM combined

GROUP BY
    device_type,
    traffic_source,
    country_code;
