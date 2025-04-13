  CREATE OR REPLACE FORCE EDITIONABLE VIEW "VW_EVENT_PARTICIPANTS" ("EVENT_NAME", "PARTICIPANTS") AS 
  SELECT e.evs_title AS event_name, COUNT(DISTINCT r.usr_id) AS participants
FROM ENC_events e
LEFT JOIN ENC_registrations r ON e.evs_event_id = r.evs_event_id
GROUP BY e.evs_title;