create or replace TRIGGER audit_privileges_trigger
AFTER INSERT OR UPDATE OR DELETE ON aut_privileges
FOR EACH ROW
BEGIN
  IF INSERTING THEN
    INSERT INTO ENC_audit_logs (usr_id, evs_action)
    VALUES (NULL, 'Privilege inserted: ID ' || :NEW.pve_id || ', Name "' || :NEW.pve_name || '"');
  ELSIF UPDATING THEN
    DECLARE
        v_changes VARCHAR2(1000);
    BEGIN
        v_changes := 'Privilege updated: ID ' || :NEW.pve_id || ', Name "' || :NEW.pve_name || '". Changes: ';

        IF NVL(:OLD.pve_name, 'NULL') != NVL(:NEW.pve_name, 'NULL') THEN
            v_changes := v_changes || 'Name from "' || NVL(:OLD.pve_name, 'NULL') || '" to "' || NVL(:NEW.pve_name, 'NULL') || '"; ';
        END IF;

        INSERT INTO ENC_audit_logs (usr_id, evs_action)
        VALUES (NULL, v_changes);
    END;
  ELSIF DELETING THEN
    INSERT INTO ENC_audit_logs (usr_id, evs_action)
    VALUES (NULL, 'Privilege deleted: ID ' || :OLD.pve_id || ', Name "' || :OLD.pve_name || '"');
  END IF;
END;
/