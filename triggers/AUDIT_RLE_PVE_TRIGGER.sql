create or replace TRIGGER audit_rle_pve_trigger
AFTER INSERT OR UPDATE OR DELETE ON aut_rle_pve
FOR EACH ROW
DECLARE
    v_role_name VARCHAR2(100);
    v_privilege_name VARCHAR2(100);
BEGIN
    -- Haal de rolnaam op
    BEGIN
        SELECT rle_name INTO v_role_name
        FROM aut_roles
        WHERE rle_id = :NEW.rpe_rle_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_role_name := 'Unknown Role';
    END;

    -- Haal de privilegenaam op
    BEGIN
        SELECT pve_name INTO v_privilege_name
        FROM aut_privileges
        WHERE pve_id = :NEW.rpe_pve_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_privilege_name := 'Unknown Privilege';
    END;

    IF INSERTING THEN
        INSERT INTO ENC_audit_logs (usr_id, evs_action)
        VALUES (NULL, 'Role privilege assigned: Role "' || v_role_name || '", Privilege "' || v_privilege_name || '"');
    ELSIF UPDATING THEN
        INSERT INTO ENC_audit_logs (usr_id, evs_action)
        VALUES (NULL, 'Role privilege updated: Role "' || v_role_name || '", Privilege "' || v_privilege_name || '"');
    ELSIF DELETING THEN
        INSERT INTO ENC_audit_logs (usr_id, evs_action)
        VALUES (NULL, 'Role privilege removed: Role "' || v_role_name || '", Privilege "' || v_privilege_name || '"');
    END IF;
END;
/