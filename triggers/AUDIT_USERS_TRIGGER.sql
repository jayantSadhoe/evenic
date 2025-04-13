create or replace TRIGGER audit_users_trigger
AFTER UPDATE ON aut_users
FOR EACH ROW
DECLARE
    v_changes VARCHAR2(1000);
BEGIN
    v_changes := 'User updated: ID ' || :OLD.usr_id || '. Changes: ';

    IF NVL(:OLD.usr_deleted, 'N') != NVL(:NEW.usr_deleted, 'N') THEN
        v_changes := v_changes || 'Deleted status from "' || NVL(:OLD.usr_deleted, 'N') || '" to "' || NVL(:NEW.usr_deleted, 'N') || '"; ';
    END IF;

    IF NVL(:OLD.usr_email, 'NULL') != NVL(:NEW.usr_email, 'NULL') THEN
        v_changes := v_changes || 'Email from "' || NVL(:OLD.usr_email, 'NULL') || '" to "' || NVL(:NEW.usr_email, 'NULL') || '"; ';
    END IF;

    IF NVL(:OLD.usr_username, 'NULL') != NVL(:NEW.usr_username, 'NULL') THEN
        v_changes := v_changes || 'Username from "' || NVL(:OLD.usr_username, 'NULL') || '" to "' || NVL(:NEW.usr_username, 'NULL') || '"; ';
    END IF;

    INSERT INTO ENC_audit_logs (usr_id, evs_action)
    VALUES (:OLD.usr_id, v_changes);
END;
/