-- Tabel for Users
CREATE TABLE ENC_users (
    USS_user_id      NUMBER PRIMARY KEY,
    USS_first_name   VARCHAR2(17) NOT NULL,
    USS_last_name    VARCHAR2(17) NOT NULL,
    USS_phone_number VARCHAR2(17),
    USS_email        VARCHAR2(100) UNIQUE NOT NULL,
    USS_password     VARCHAR2(25) NOT NULL,
    USS_created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    USS_updated_at   TIMESTAMP
);


-- Tabel for Rolls
CREATE TABLE ENC_roles (
    ROL_role_id   NUMBER PRIMARY KEY,
    ROL_role_name VARCHAR2(17) UNIQUE NOT NULL
);


-- Join table for Users & Rolls
CREATE TABLE ENC_user_roles (
    USS_user_id NUMBER NOT NULL,
    ROL_role_id NUMBER NOT NULL,
    PRIMARY KEY (USS_user_id, ROL_role_id),
    FOREIGN KEY (USS_user_id) REFERENCES ENC_users(USS_user_id) ON DELETE CASCADE,
    FOREIGN KEY (ROL_role_id) REFERENCES ENC_roles(ROL_role_id) ON DELETE CASCADE
);


-- Tabel for permissions
CREATE TABLE ENC_permissions (
    PSS_permission_id   NUMBER PRIMARY KEY,
    PSS_permission_name VARCHAR2(40) UNIQUE NOT NULL
);


-- Join table for Rolls & Permissions
CREATE TABLE ENC_role_permissions (
    ROL_role_id       NUMBER NOT NULL,
    PSS_permission_id NUMBER NOT NULL,
    PRIMARY KEY (ROL_role_id, PSS_permission_id),
    FOREIGN KEY (ROL_role_id) REFERENCES ENC_roles(ROL_role_id) ON DELETE CASCADE,
    FOREIGN KEY (PSS_permission_id) REFERENCES ENC_permissions(PSS_permission_id) ON DELETE CASCADE
);