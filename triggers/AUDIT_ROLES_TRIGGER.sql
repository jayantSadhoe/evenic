create or replace TRIGGER audit_roles_trigger
AFTER INSERT OR UPDATE OR DELETE ON aut_roles
FOR EACH ROW
BEGIN
  IF INSERTING THEN
    INSERT INTO ENC_audit_logs (usr_id, evs_action)
    VALUES (NULL, 'Role inserted: ID ' || :NEW.rle_id || ', Name "' || :NEW.rle_name || '"');
  ELSIF UPDATING THEN
    DECLARE
        v_changes VARCHAR2(1000);
    BEGIN
        v_changes := 'Role updated: ID ' || :NEW.rle_id || ', Name "' || :NEW.rle_name || '". Changes: ';

        IF NVL(:OLD.rle_name, 'NULL') != NVL(:NEW.rle_name, 'NULL') THEN
            v_changes := v_changes || 'Name from "' || NVL(:OLD.rle_name, 'NULL') || '" to "' || NVL(:NEW.rle_name, 'NULL') || '"; ';
        END IF;

        INSERT INTO ENC_audit_logs (usr_id, evs_action)
        VALUES (NULL, v_changes);
    END;
  ELSIF DELETING THEN
    INSERT INTO ENC_audit_logs (usr_id, evs_action)
    VALUES (NULL, 'Role deleted: ID ' || :OLD.rle_id || ', Name "' || :OLD.rle_name || '"');
  END IF;
END;
/