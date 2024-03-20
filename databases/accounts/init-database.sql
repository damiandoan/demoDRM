CREATE SCHEMA auth;

CREATE TABLE auth.users
(
    id bigserial PRIMARY KEY,
    created_on timestamp NOT NULL DEFAULT NOW(),
    updated_on timestamp NOT NULL DEFAULT NOW(),
    email varchar UNIQUE ,
    username varchar UNIQUE,
    password varchar,
    first_name varchar,
    last_name varchar,
    role varchar
);

CREATE UNIQUE INDEX ix_users_username ON auth.users(username);

CREATE TABLE auth.refresh_tokens
(
    id bigserial PRIMARY KEY,
    created_on timestamp NOT NULL,
    updated_on timestamp NOT NULL,
    value varchar,
    is_blacklisted boolean NOT NULL,
    user_id bigint REFERENCES auth.users (id) ON DELETE CASCADE
);

CREATE UNIQUE INDEX ix_refresh_tokens_user_id ON auth.refresh_tokens(user_id);

-- INSERT INTO auth."User"(Username, Email, Password, FirstName, LastName, Role)
-- VALUES
--     ('nghiadoangoody', 'nghiadoangoody@gmail.com', '$2a$12$axG6wmh4/U9z7ZuzwkzIZucQC5YzN7pEvaoqMFZqx0LaXYuwZvdG.', 'Nghia Doan', 'Goody', 'reader'),
--     ('tranhoaiphat', 'tranhoaiphat52@gmail.com', '$2a$12$axG6wmh4/U9z7ZuzwkzIZucQC5YzN7pEvaoqMFZqx0LaXYuwZvdG.', 'Tran Hoai', 'Phat', 'reader');

\getenv cms_svc_username CMS_SVC_USERNAME
\getenv cms_svc_password CMS_SVC_DB_INIT_PASSWORD

\getenv auth_svc_username AUTH_SVC_USERNAME
\getenv auth_svc_password AUTH_SVC_DB_INIT_PASSWORD
-- cms_svc user
CREATE USER :cms_svc_username;
GRANT USAGE ON SCHEMA auth TO :cms_svc_username;
GRANT SELECT, INSERT, UPDATE, DELETE ON auth."users" TO :cms_svc_username;
ALTER USER :cms_svc_username WITH PASSWORD :cms_svc_password;

-- auth_svc user
CREATE USER :auth_svc_username;
GRANT USAGE ON SCHEMA auth TO :auth_svc_username;
GRANT SELECT, INSERT, UPDATE ON auth."users" TO :auth_svc_username;
GRANT SELECT, INSERT, UPDATE ON auth.refresh_tokens TO :auth_svc_username;
GRANT USAGE, SELECT ON SEQUENCE auth.users_id_seq TO :auth_svc_username;
GRANT USAGE, SELECT ON SEQUENCE auth.refresh_tokens_id_seq TO :auth_svc_username;
ALTER USER :auth_svc_username WITH PASSWORD :auth_svc_password;
