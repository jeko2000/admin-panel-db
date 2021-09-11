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
