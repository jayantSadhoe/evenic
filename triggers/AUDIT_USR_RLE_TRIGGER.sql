create or replace TRIGGER audit_usr_rle_trigger
AFTER INSERT OR UPDATE OR DELETE ON aut_usr_rle
FOR EACH ROW
DECLARE
    v_role_name VARCHAR2(100);
    v_username VARCHAR2(100);
BEGIN
    -- Haal de rolnaam op
    BEGIN
        SELECT rle_name INTO v_role_name
        FROM aut_roles
        WHERE rle_id = :NEW.ure_rle_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_role_name := 'Unknown Role';
    END;

    -- Haal de gebruikersnaam op
    BEGIN
        SELECT usr_username INTO v_username
        FROM aut_users
        WHERE usr_id = :NEW.ure_usr_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_username := 'Unknown User';
    END;

    IF INSERTING THEN
        INSERT INTO ENC_audit_logs (usr_id, evs_action)
        VALUES (:NEW.ure_usr_id, 'User role assigned: User "' || v_username || '", Role "' || v_role_name || '"');
    ELSIF UPDATING THEN
        INSERT INTO ENC_audit_logs (usr_id, evs_action)
        VALUES (:OLD.ure_usr_id, 'User role updated: User "' || v_username || '", Role "' || v_role_name || '"');
    ELSIF DELETING THEN
        INSERT INTO ENC_audit_logs (usr_id, evs_action)
        VALUES (:OLD.ure_usr_id, 'User role removed: User "' || v_username || '", Role "' || v_role_name || '"');
    END IF;
END;
/