-----------
-- USERS --
-----------
CREATE SEQUENCE IF NOT EXISTS users_user_id_seq START WITH 1042;

CREATE TABLE IF NOT EXISTS users (
  user_id INTEGER PRIMARY KEY DEFAULT NEXTVAL('users_user_id_seq'),
  email_address TEXT NOT NULL UNIQUE,
  password_hash TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER SEQUENCE users_user_id_seq OWNED BY users.user_id;

----------------
-- USER ROLES --
----------------
CREATE TABLE IF NOT EXISTS user_roles (
  user_id INTEGER REFERENCES users,
  role_id INTEGER REFERENCES roles,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id, role_id)
);

------------------------
-- USER REGISTRATIONS --
------------------------
CREATE TABLE IF NOT EXISTS user_registrations (
  user_registration_id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
  email_address TEXT NOT NULL,
  password_hash TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-----------------------------
-- USER REGISTRATIONS RTAB --
-----------------------------
CREATE TABLE IF NOT EXISTS user_registrations_rtab (
  user_registration_id UUID REFERENCES user_registrations,
  user_id INTEGER REFERENCES users,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (user_registration_id, user_id)
);
