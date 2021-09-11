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
  PRIMARY KEY (user_id, role_id)
);
