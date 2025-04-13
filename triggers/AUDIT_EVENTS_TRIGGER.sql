create or replace TRIGGER audit_events_trigger
AFTER INSERT OR UPDATE OR DELETE ON ENC_events
FOR EACH ROW
DECLARE
    v_old_event_type VARCHAR2(100);
    v_new_event_type VARCHAR2(100);
BEGIN
    -- Haal de oude en nieuwe event type naam op via typ_event_type_id
    IF UPDATING OR INSERTING THEN
        SELECT typ_event_type_name INTO v_new_event_type
        FROM ENC_event_types 
        WHERE typ_event_type_id = :NEW.typ_event_type_id;
    END IF;
    
    IF UPDATING OR DELETING THEN
        SELECT typ_event_type_name INTO v_old_event_type
        FROM ENC_event_types 
        WHERE typ_event_type_id = :OLD.typ_event_type_id;
    END IF;
  
    IF INSERTING THEN
        INSERT INTO ENC_audit_logs (usr_id, evs_action)
        VALUES (:NEW.usr_organizer_id, 'Event inserted: ID ' || :NEW.evs_event_id || 
                ', Title "' || :NEW.evs_title || 
                '", Event Type "' || NVL(v_new_event_type, 'NULL') || '"');
    ELSIF UPDATING THEN
        DECLARE
            v_changes VARCHAR2(1000);
        BEGIN
            v_changes := 'Event updated: ID ' || :NEW.evs_event_id || ', Title "' || :NEW.evs_title || '". Changes: ';

            IF NVL(:OLD.evs_title, 'NULL') != NVL(:NEW.evs_title, 'NULL') THEN
                v_changes := v_changes || 'Title from "' || NVL(:OLD.evs_title, 'NULL') || '" to "' || NVL(:NEW.evs_title, 'NULL') || '"; ';
            END IF;

            IF NVL(v_old_event_type, 'NULL') != NVL(v_new_event_type, 'NULL') THEN
                v_changes := v_changes || 'Event Type from "' || NVL(v_old_event_type, 'NULL') || '" to "' || NVL(v_new_event_type, 'NULL') || '"; ';
            END IF;

            -- Voeg de wijzigingen toe aan de audit log
            INSERT INTO ENC_audit_logs (usr_id, evs_action)
            VALUES (:NEW.usr_organizer_id, v_changes);
        END;
    ELSIF DELETING THEN
        INSERT INTO ENC_audit_logs (usr_id, evs_action)
        VALUES (:OLD.usr_organizer_id, 'Event deleted: ID ' || :OLD.evs_event_id || 
                ', Title "' || :OLD.evs_title || 
                '", Event Type "' || NVL(v_old_event_type, 'NULL') || '"');
    END IF;
END;
/