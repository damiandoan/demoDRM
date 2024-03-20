CREATE SCHEMA IF NOT EXISTS rentals;
CREATE TABLE rentals.book_rentals (
                              id SERIAL PRIMARY KEY,
                              user_id INT NOT NULL,
                              isbn VARCHAR(20) NOT NULL,
                              start_date DATE NOT NULL,
                              end_date DATE NOT NULL,
                              status VARCHAR(20) NOT NULL
);
CREATE INDEX idx_book_rentals_isbn
ON rentals.book_rentals (isbn);

\getenv cms_svc_username CMS_SVC_USERNAME
\getenv cms_svc_password CMS_SVC_DB_INIT_PASSWORD

\getenv rental_svc_username RENTAL_SVC_USERNAME
\getenv rental_svc_password RENTAL_SVC_DB_INIT_PASSWORD
-- cms_svc user
CREATE USER :cms_svc_username;
GRANT USAGE ON SCHEMA rentals TO :cms_svc_username;
GRANT SELECT, INSERT, UPDATE, DELETE ON rentals.book_rentals TO :cms_svc_username;
ALTER USER :cms_svc_username WITH PASSWORD :cms_svc_password;

-- rental_svc user
CREATE USER :rental_svc_username;
GRANT USAGE ON SCHEMA rentals TO :rental_svc_username;
GRANT SELECT, INSERT, UPDATE, DELETE ON rentals.book_rentals TO :rental_svc_username;
ALTER USER :rental_svc_username WITH PASSWORD :rental_svc_password;
GRANT USAGE, SELECT ON SEQUENCE rentals.book_rentals_id_seq TO :rental_svc_username;