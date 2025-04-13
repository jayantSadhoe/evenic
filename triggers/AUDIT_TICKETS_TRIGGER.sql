create or replace TRIGGER audit_tickets_trigger
AFTER UPDATE ON ENC_tickets
FOR EACH ROW
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;  -- Zorgt ervoor dat de insert in een aparte transactie wordt uitgevoerd
    v_changes VARCHAR2(1000);
BEGIN
    v_changes := 'Ticket updated: ID ' || :OLD.tks_ticket_id || '. Changes: ';

    IF NVL(:OLD.tks_name, 'NULL') != NVL(:NEW.tks_name, 'NULL') THEN
        v_changes := v_changes || 'Name from "' || :OLD.tks_name || '" to "' || :NEW.tks_name || '"; ';
    END IF;

    IF NVL(:OLD.tks_price, 0) != NVL(:NEW.tks_price, 0) THEN
        v_changes := v_changes || 'Price from "' || :OLD.tks_price || '" to "' || :NEW.tks_price || '"; ';
    END IF;

    IF NVL(:OLD.tks_currency, 'NULL') != NVL(:NEW.tks_currency, 'NULL') THEN
        v_changes := v_changes || 'Currency from "' || :OLD.tks_currency || '" to "' || :NEW.tks_currency || '"; ';
    END IF;

    IF NVL(:OLD.tks_quantity, 0) != NVL(:NEW.tks_quantity, 0) THEN
        v_changes := v_changes || 'Quantity from "' || :OLD.tks_quantity || '" to "' || :NEW.tks_quantity || '"; ';
    END IF;

    IF v_changes != 'Ticket updated: ID ' || :OLD.tks_ticket_id || '. Changes: ' THEN
        INSERT INTO ENC_audit_logs (usr_id, evs_action)
        VALUES (NULL, v_changes);
        COMMIT; -- Commit is nodig omdat we een autonome transactie gebruiken
    END IF;
END;
/