  CREATE OR REPLACE FORCE EDITIONABLE VIEW "VW_EVENT_REVENUE" ("EVENT_NAME", "TOTAL_REVENUE") AS 
  SELECT e.evs_title AS event_name, SUM(t.tks_price) AS total_revenue
FROM ENC_events e
LEFT JOIN ENC_registrations r ON e.evs_event_id = r.evs_event_id
LEFT JOIN ENC_tickets t ON r.tks_ticket_id = t.tks_ticket_id
GROUP BY e.evs_title;