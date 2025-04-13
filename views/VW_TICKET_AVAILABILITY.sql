  CREATE OR REPLACE FORCE EDITIONABLE VIEW "VW_TICKET_AVAILABILITY" ("Evenement", "Ticket Type", "Totaal Beschikbaar", "Resterend", "Verkocht (%)", "Status") AS 
  SELECT 
    e.evs_title AS "Evenement",
    t.tks_name AS "Ticket Type",
    t.tks_quantity AS "Totaal Beschikbaar",
    t.tks_quantity - NVL(COUNT(r.tks_ticket_id), 0) AS "Resterend",
    ROUND(NVL(COUNT(r.tks_ticket_id), 0) / t.tks_quantity * 100, 2) AS "Verkocht (%)",
    CASE 
        WHEN t.tks_quantity - NVL(COUNT(r.tks_ticket_id), 0) < 10 
             AND NVL(COUNT(r.tks_ticket_id), 0) > 0 THEN 'BIJNA UITVERKOCHT'
        WHEN NVL(COUNT(r.tks_ticket_id), 0) = 0 THEN 'NOG NIET VERKOCHT'
        ELSE 'BESCHIKBAAR'
    END AS "Status"
FROM 
    ENC_tickets t
JOIN 
    ENC_events e ON t.evs_event_id = e.evs_event_id
LEFT JOIN 
    ENC_registrations r ON t.tks_ticket_id = r.tks_ticket_id AND r.rts_events_status = 'Confirmed'
GROUP BY 
    e.evs_title, t.tks_name, t.tks_quantity;