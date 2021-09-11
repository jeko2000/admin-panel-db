-----------
-- ROLES --
-----------
CREATE SEQUENCE IF NOT EXISTS roles_role_id_seq START WITH 100;

CREATE TABLE IF NOT EXISTS roles (
  prole_id INTEGER PRIMARY KEY DEFAULT NEXTVAL('roles_role_id_seq'),
  role_name TEXT NOT NULL UNIQUE,
  role_description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER SEQUENCE roles_role_id_seq owned BY roles.role_id;

INSERT INTO roles (role_name, role_description)
  VALUES ('user', 'Regular user');

INSERT INTO roles (role_name, role_description)
  VALUES ('admin', 'Administrator');
