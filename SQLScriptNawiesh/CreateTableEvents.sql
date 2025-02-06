CREATE TABLE ENC_events (
    EVS_event_id      NUMBER PRIMARY KEY,
    USS_organizer_id  NUMBER NOT NULL,
    EVS_title         VARCHAR2(25) NOT NULL,
    TYP_event_type_id NUMBER NOT NULL,
    EVS_description   VARCHAR2(500),
    EVS_location      VARCHAR2(255) NOT NULL,
    EVS_event_date    DATE NOT NULL,
    EVS_start_time    TIMESTAMP NOT NULL,
    EVS_end_time      TIMESTAMP NOT NULL,
    EVS_created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (USS_organizer_id) REFERENCES ENC_users(USS_user_id),
    FOREIGN KEY (TYP_event_type_id) REFERENCES ENC_event_types(TYP_event_type_id)
);