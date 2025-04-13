create or replace TRIGGER trg_low_ticket_sales
AFTER INSERT OR UPDATE ON ENC_tickets
FOR EACH ROW
WHEN (NEW.tks_quantity < 10)  -- Drempel instellen
BEGIN
    INSERT INTO ENC_notifications (usr_id, evs_event_id, nts_title, nts_message)
    SELECT E.usr_organizer_id, E.evs_event_id,
           'Lage Ticketverkoop Waarschuwing',
           'De ticketverkoop voor het evenement "' || E.evs_title || '" is onder de 10 gezakt.'
    FROM ENC_events E
    WHERE E.evs_event_id = :NEW.evs_event_id;
END;
/