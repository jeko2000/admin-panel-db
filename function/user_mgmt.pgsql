CREATE OR REPLACE FUNCTION get_user_role_names (
  in_user_id users.user_id % TYPE
)
  RETURNS TEXT
  AS $$
DECLARE
  v_role_names TEXT;
BEGIN
  SELECT
    STRING_AGG(r.role_name::TEXT, ',') INTO v_role_names
  FROM
    user_roles ur,
    roles r
  WHERE
    ur.user_id = in_user_id
    AND ur.role_id = r.role_id;
  RETURN v_role_names;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_all_users ()
  RETURNS TABLE (
      user_id users.user_id % TYPE,
      email_address users.email_address % TYPE,
      password_hash users.password_hash % TYPE,
      role_names TEXT,
      created_at users.created_at % TYPE
    )
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    u.user_id,
    u.email_address,
    u.password_hash,
    get_user_role_names (u.user_id) AS role_names,
    u.created_at
  FROM
    users u;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION create_user_registration (
  in_email_address user_registrations.email_address % TYPE,
  in_password_hash user_registrations.password_hash % TYPE
)
  RETURNS UUID
  AS $$
DECLARE
  out_user_registration_id UUID;
BEGIN
  INSERT INTO user_registrations (email_address, password_hash)
    VALUES (in_email_address, in_password_hash)
  RETURNING
    user_registration_id INTO out_user_registration_id;
  RETURN out_user_registration_id;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION confirm_user_registration (
  in_user_registration_id user_registrations.user_registration_id % TYPE
)
  RETURNS INTEGER
  AS $$
DECLARE
  v_registration_row user_registrations % ROWTYPE;
  out_user_id INTEGER;
BEGIN
  -- Get registration row
  SELECT
    * INTO v_registration_row
  FROM
    user_registrations
  WHERE
    user_registration_id = in_user_registration_id;
  -- insert fields into users table
  INSERT INTO users (email_address, password_hash)
    VALUES (v_registration_row.email_address, v_registration_row.password_hash)
  RETURNING
    user_id INTO out_user_id;
  -- Associate user role with new user
  INSERT INTO user_roles(user_id, role_id)
  VALUES (out_user_id, (SELECT role_id FROM roles WHERE role_name = 'user'));
  -- Associate user_registration_id and corresponding user_id in the rtab table
  INSERT INTO user_registrations_rtab (user_registration_id, user_id)
    VALUES (in_user_registration_id, out_user_id);
  RETURN out_user_id;
END;
$$
LANGUAGE plpgsql;
