create or replace TRIGGER audit_notifications_trigger
AFTER INSERT OR DELETE ON ENC_notifications
FOR EACH ROW
BEGIN
  IF INSERTING THEN
    INSERT INTO ENC_audit_logs (usr_id, evs_action)
    VALUES (:NEW.usr_id, 'Notification inserted: ' || :NEW.nts_title);

  ELSIF DELETING THEN
    INSERT INTO ENC_audit_logs (usr_id, evs_action)
    VALUES (:OLD.usr_id, 'Notification deleted: ' || :OLD.nts_title);
  END IF;
END;
/