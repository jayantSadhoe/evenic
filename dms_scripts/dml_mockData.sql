-- Insert into aut_roles
INSERT INTO aut_roles (rle_name, rle_description, rle_created_date, rle_created_by) 
VALUES 
('Admin', 'System administrator with full access', SYSDATE, 'system'),
('Organizer', 'Can create and manage events', SYSDATE, 'system'),
('Attendee', 'Regular user who can register for events', SYSDATE, 'system');

-- Insert into aut_users
INSERT INTO aut_users (usr_username, usr_password, usr_email, usr_created_by) 
VALUES 
('admin', 'hashed_password_123', 'admin@events.com', 'system'),
('organizer1', 'hashed_password_456', 'organizer1@events.com', 'system'),
('user1', 'hashed_password_789', 'user1@events.com', 'system'),
('user2', 'hashed_password_101', 'user2@events.com', 'system');

-- Insert into aut_privileges
INSERT INTO aut_privileges (pve_name, pve_apex_page, pve_read, pve_write, pve_created_date, pve_created_by) 
VALUES 
('Manage Users', 10, 'Y', 'Y', SYSDATE, 'system'),
('Manage Events', 20, 'Y', 'Y', SYSDATE, 'system'),
('View Events', 20, 'Y', 'N', SYSDATE, 'system'),
('Register for Events', 30, 'Y', 'Y', SYSDATE, 'system');

-- Insert into aut_rle_pve (role-privilege mappings)
INSERT INTO aut_rle_pve (rpe_rle_id, rpe_pve_id, rpe_created_by) 
VALUES 
(1, 1, 'system'), -- Admin can Manage Users
(1, 2, 'system'), -- Admin can Manage Events
(2, 2, 'system'), -- Organizer can Manage Events
(3, 3, 'system'), -- User can View Events
(3, 4, 'system'); -- User can Register for Events

-- Insert into aut_usr_rle (user-role assignments)
INSERT INTO aut_usr_rle (ure_usr_id, ure_rle_id, ure_created_by) 
VALUES 
(1, 1, 'system'), -- admin has Admin role
(2, 2, 'system'), -- organizer1 has Event Organizer role
(3, 3, 'system'), -- user1 has User role
(4, 3, 'system'); -- user2 has User role

-- Insert into ENC_event_types
INSERT INTO ENC_event_types (typ_event_type_id, typ_event_type_name) 
VALUES 
(1, 'Conference'),
(2, 'Workshop'),
(3, 'Concert'),
(4, 'Exhibition');

-- Insert into ENC_events
INSERT INTO ENC_events (
    evs_event_id, usr_organizer_id, evs_title, 
    typ_event_type_id, evs_description, evs_location, 
    evs_event_date, evs_start_time, evs_end_time
) VALUES 
(1, 2, 'Tech Conference 2023', 1, 'Annual technology conference', 'Amsterdam RAI', 
 TO_DATE('15-11-2023', 'DD-MM-YYYY'), TO_TIMESTAMP('15-11-2023 09:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('15-11-2023 17:00:00', 'DD-MM-YYYY HH24:MI:SS')),

(2, 2, 'Data Science Workshop', 2, 'Hands-on data science training', 'Online', 
 TO_DATE('20-11-2023', 'DD-MM-YYYY'), TO_TIMESTAMP('20-11-2023 13:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('20-11-2023 16:00:00', 'DD-MM-YYYY HH24:MI:SS')),

(3, 1, 'Jazz Night', 3, 'Evening of live jazz music', 'Paradiso, Amsterdam', 
 TO_DATE('25-11-2023', 'DD-MM-YYYY'), TO_TIMESTAMP('25-11-2023 20:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('25-11-2023 23:00:00', 'DD-MM-YYYY HH24:MI:SS'));

-- Insert into ENC_tickets
INSERT INTO ENC_tickets (tks_ticket_id, tks_name, evs_event_id, tks_currency, tks_price, tks_quantity) 
VALUES 
(1, 'Early Bird', 1, 'SRD', 99.99, 100),
(2, 'Regular', 1, 'SRD', 149.99, 200),
(3, 'VIP Zilver', 1, 'SRD', 450, 5),
(4, 'VIP Gold', 2, 'SRD', 750, 5),
(5, 'Standard Entry', 3, 'SRD', 25.00, 150);

-- Insert into ENC_registrations
INSERT INTO ENC_registrations (
    rts_registration_id, usr_id, evs_event_id, 
    tks_ticket_id, rts_events_status
) VALUES 
(1, 3, 1, 1, 'Confirmed'),
(2, 4, 1, 2, 'Confirmed'),
(3, 3, 2, 4, 'Pending'),
(4, 4, 3, 5, 'Confirmed');

-- Insert into ENC_notifications
INSERT INTO ENC_notifications (
    nts_notification_id, usr_id, evs_event_id, 
    nts_title, nts_message
) VALUES 
(1, 3, 1, 'Registration Confirmed', 'Your registration for Tech Conference 2023 has been confirmed'),
(2, 4, 1, 'Registration Confirmed', 'Your registration for Tech Conference 2023 has been confirmed'),
(3, 3, 2, 'Reminder', 'Your workshop starts tomorrow at 13:00');

-- Insert into ENC_audit_logs
INSERT INTO ENC_audit_logs (evs_log_id, usr_id, evs_action) 
VALUES 
(1, 1, 'Created new event: Jazz Night'),
(2, 2, 'Updated ticket prices for Tech Conference'),
(3, 3, 'Registered for Tech Conference'),
(4, 4, 'Cancelled registration for Workshop');

COMMIT;