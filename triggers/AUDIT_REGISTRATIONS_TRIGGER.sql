create or replace TRIGGER audit_registrations_trigger
AFTER INSERT OR UPDATE OR DELETE ON ENC_registrations
FOR EACH ROW
DECLARE
    v_event_name VARCHAR2(255);
    v_ticket_name VARCHAR2(255);
    v_user_name VARCHAR2(255);
    v_ticket_price NUMBER(8, 2);
    v_old_event_name VARCHAR2(255);
    v_old_ticket_name VARCHAR2(255);
    v_old_ticket_price NUMBER(8, 2);
    v_changes VARCHAR2(1000);
BEGIN
    -- Haal de oude event naam op (voor update), zorg ervoor dat je slechts 1 rij krijgt
    IF UPDATING OR DELETING THEN
        BEGIN
            SELECT evs_title INTO v_old_event_name
            FROM ENC_events
            WHERE evs_event_id = :OLD.evs_event_id
            AND ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_old_event_name := 'Event niet gevonden';
            WHEN TOO_MANY_ROWS THEN
                v_old_event_name := 'Meerdere events gevonden';
        END;
    END IF;

    -- Haal de nieuwe event naam op (voor insert of update), zorg ervoor dat je slechts 1 rij krijgt
    IF INSERTING OR UPDATING THEN
        BEGIN
            SELECT evs_title INTO v_event_name
            FROM ENC_events
            WHERE evs_event_id = :NEW.evs_event_id
            AND ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_event_name := 'Event niet gevonden';
            WHEN TOO_MANY_ROWS THEN
                v_event_name := 'Meerdere events gevonden';
        END;
    END IF;

    -- Haal de oude ticket naam en prijs op (voor update en delete)
    IF UPDATING OR DELETING THEN
        BEGIN
            SELECT tks_name, tks_price INTO v_old_ticket_name, v_old_ticket_price
            FROM ENC_tickets
            WHERE tks_ticket_id = :OLD.tks_ticket_id
            AND ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_old_ticket_name := 'Ticket niet gevonden';
                v_old_ticket_price := 0;
            WHEN TOO_MANY_ROWS THEN
                v_old_ticket_name := 'Meerdere tickets gevonden';
                v_old_ticket_price := 0;
        END;
    END IF;

    -- Haal de nieuwe ticket naam en prijs op (voor insert of update)
    IF INSERTING OR UPDATING THEN
        BEGIN
            SELECT tks_name, tks_price INTO v_ticket_name, v_ticket_price
            FROM ENC_tickets
            WHERE tks_ticket_id = :NEW.tks_ticket_id
            AND ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_ticket_name := 'Ticket niet gevonden';
                v_ticket_price := 0;
            WHEN TOO_MANY_ROWS THEN
                v_ticket_name := 'Meerdere tickets gevonden';
                v_ticket_price := 0;
        END;
    END IF;

    -- Haal de gebruikersnaam op
    BEGIN
        SELECT usr_username INTO v_user_name
        FROM aut_users
        WHERE usr_id = :NEW.usr_id OR usr_id = :OLD.usr_id
        AND ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_user_name := 'User niet gevonden';
        WHEN TOO_MANY_ROWS THEN
            v_user_name := 'Meerdere gebruikers gevonden';
    END;

    -- Voor Insert
    IF INSERTING THEN
        INSERT INTO ENC_audit_logs (usr_id, evs_action)
        VALUES (
            :NEW.usr_id,
            'Registration inserted: ID ' || :NEW.rts_registration_id ||
            ', User: ' || v_user_name ||
            ', Event: ' || v_event_name ||
            ', Ticket: ' || v_ticket_name ||
            ', Price: ' || TO_CHAR(v_ticket_price, '9999.99') ||
            ', Status: "' || :NEW.rts_events_status || '"'
        );
    ELSIF UPDATING THEN
        v_changes := 'Registration updated: ID ' || :NEW.rts_registration_id || '. Changes: ';

        -- Vergelijk oude en nieuwe waarden en voeg toe aan v_changes
        IF NVL(:OLD.rts_events_status, 'NULL') != NVL(:NEW.rts_events_status, 'NULL') THEN
            v_changes := v_changes || 'Status from "' || NVL(:OLD.rts_events_status, 'NULL') || '" to "' || NVL(:NEW.rts_events_status, 'NULL') || '"; ';
        END IF;

        IF NVL(:OLD.evs_event_id, 0) != NVL(:NEW.evs_event_id, 0) THEN
            v_changes := v_changes || 'Event from "' || v_old_event_name || '" to "' || v_event_name || '"; ';
        END IF;

        IF NVL(:OLD.tks_ticket_id, 0) != NVL(:NEW.tks_ticket_id, 0) THEN
            v_changes := v_changes || 'Ticket from "' || v_old_ticket_name || '" to "' || v_ticket_name || '"; ';
            v_changes := v_changes || 'Price from "' || TO_CHAR(v_old_ticket_price, '9999.99') || '" to "' || TO_CHAR(v_ticket_price, '9999.99') || '"; ';
        END IF;

        INSERT INTO ENC_audit_logs (usr_id, evs_action)
        VALUES (
            :OLD.usr_id,
            v_changes
        );
    ELSIF DELETING THEN
        INSERT INTO ENC_audit_logs (usr_id, evs_action)
        VALUES (
            :OLD.usr_id,
            'Registration deleted: ID ' || :OLD.rts_registration_id ||
            ', User: ' || v_user_name ||
            ', Event: ' || v_old_event_name ||
            ', Ticket: ' || v_old_ticket_name ||
            ', Price: ' || TO_CHAR(v_old_ticket_price, '9999.99')
        );
    END IF;
END;
/