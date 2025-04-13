create or replace TRIGGER audit_event_types_trigger
AFTER INSERT OR UPDATE OR DELETE ON ENC_event_types
FOR EACH ROW
BEGIN
  IF INSERTING THEN
    INSERT INTO ENC_audit_logs (usr_id, evs_action)
    VALUES (NULL, 'Event type inserted: ID ' || :NEW.typ_event_type_id || ', Name "' || :NEW.typ_event_type_name || '"');
  ELSIF UPDATING THEN
    DECLARE
        v_changes VARCHAR2(1000);
    BEGIN
        v_changes := 'Event type updated: ID ' || :NEW.typ_event_type_id || ', Name "' || :NEW.typ_event_type_name || '". Changes: ';

        IF NVL(:OLD.typ_event_type_name, 'NULL') != NVL(:NEW.typ_event_type_name, 'NULL') THEN
            v_changes := v_changes || 'Name from "' || NVL(:OLD.typ_event_type_name, 'NULL') || '" to "' || NVL(:NEW.typ_event_type_name, 'NULL') || '"; ';
        END IF;

        INSERT INTO ENC_audit_logs (usr_id, evs_action)
        VALUES (NULL, v_changes);
    END;
  ELSIF DELETING THEN
    INSERT INTO ENC_audit_logs (usr_id, evs_action)
    VALUES (NULL, 'Event type deleted: ID ' || :OLD.typ_event_type_id || ', Name "' || :OLD.typ_event_type_name || '"');
  END IF;
END;
/