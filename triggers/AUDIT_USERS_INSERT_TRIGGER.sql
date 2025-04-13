create or replace TRIGGER audit_users_insert_trigger
AFTER INSERT ON aut_users
FOR EACH ROW
DECLARE
BEGIN
  INSERT INTO ENC_audit_logs (usr_id, evs_action, evs_time)
  VALUES (:NEW.usr_id, 'Insert user: ' || :NEW.usr_username || ' with email: ' || :NEW.usr_email, SYSDATE);
END;
/