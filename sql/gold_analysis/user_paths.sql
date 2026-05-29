/*

Purpose:
This script creates a view (gold.user_paths) designed to map out sequential user navigation patterns across your digital platform.
By analyzing how users transition from one specific event type to the next within the exact same browsing session, it uncovers the most common behavioral pathways.
This allows product teams to map the user journey, detect unexpected routing behavior, and optimize the overall user experience.

*/

DROP VIEW IF EXISTS gold.user_paths;

CREATE VIEW gold.user_paths AS 

WITH ordered_events AS(
	SELECT 
		session_id,
		event_time,
		event_type,
		LEAD(event_type) OVER (
			PARTITION BY session_id
			ORDER BY event_time) AS next_event
	FROM gold.fact_events
)

SELECT
	event_type AS current_event,
	next_event,
	COUNT(*) AS transition_count
FROM ordered_events
WHERE next_event IS NOT NULL
GROUP BY 
	event_type,
	next_event
ORDER BY transition_count DESC;
