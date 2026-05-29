/*

Purpose:
This script creates a view (gold.funnel_analysis) that tracks user behavior across a sequential e-commerce journey:
Page View -> Add to Cart -> Checkout -> Purchase.

It calculates how many unique sessions reach each stage, along with overall conversion rates and step-by-step drop-offs.

*/


DROP VIEW IF EXISTS gold.funnel_analysis;
CREATE VIEW gold.funnel_analysis AS

WITH funnel_stages AS (
    SELECT 1 AS stage_order, 'page_view' AS event_type
    UNION ALL SELECT 2, 'add_to_cart'
    UNION ALL SELECT 3, 'checkout'
    UNION ALL SELECT 4, 'purchase'
),

funnel_counts AS (
    SELECT
        event_type,
        COUNT(DISTINCT session_id) AS sessions_count
    FROM gold.fact_events
    GROUP BY event_type
),

base AS (
    SELECT
        fs.stage_order,
        fs.event_type,
        COALESCE(fc.sessions_count, 0) AS sessions_count
    FROM funnel_stages fs
    LEFT JOIN funnel_counts fc
        ON fs.event_type = fc.event_type
),

final AS (
    SELECT
        stage_order,
        event_type,
        sessions_count,
        LAG(sessions_count) OVER (ORDER BY stage_order) AS previous_stage_sessions
    FROM base
)

SELECT
    stage_order,
    event_type,
    sessions_count,

    ROUND(
        100.0 * sessions_count / MAX(sessions_count) OVER (),
        2
    ) AS overall_conversion_pct,

    ROUND(
        100.0 * sessions_count / NULLIF(previous_stage_sessions, 0),
        2
    ) AS step_conversion_pct,

    ROUND(
        100.0 * (previous_stage_sessions - sessions_count) / NULLIF(previous_stage_sessions, 0),
        2
    ) AS step_dropoff_pct

FROM final;
