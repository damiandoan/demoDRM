CREATE SCHEMA IF NOT EXISTS library;

CREATE TABLE library.books (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    s3_bucket_name VARCHAR(255),
    s3_key VARCHAR(255)
);

CREATE TABLE library.categories (
    id SERIAL PRIMARY KEY,
    name varchar NOT NULL  UNIQUE
);

CREATE TABLE library.books_categories (
    book_id INTEGER REFERENCES library.books(id),
    category_id INTEGER REFERENCES library.categories(id),
    PRIMARY KEY(book_id, category_id)
);


CREATE SCHEMA IF NOT EXISTS store;

CREATE TABLE store.isbn (
    isbn varchar(255) PRIMARY KEY,
    book_id int,
    FOREIGN KEY (book_id) REFERENCES library.books(id)
);

CREATE SCHEMA  IF NOT EXISTS drm;

CREATE TABLE drm.encryption_keys (
    id SERIAL PRIMARY KEY,
    book_id int,
    page_number int,
    FOREIGN KEY (book_id) REFERENCES library.books(id),
    encryption_key varchar
);

CREATE INDEX library_books_id_index ON library.books (id);
CREATE INDEX isbn_book_id_index ON store.isbn (book_id);
CREATE INDEX isbn_index ON store.isbn (isbn);

\getenv cms_svc_username CMS_SVC_USERNAME
\getenv cms_svc_password CMS_SVC_DB_INIT_PASSWORD

\getenv bookstore_svc_username BOOKSTORE_SVC_USERNAME
\getenv bookstore_svc_password BOOKSTORE_DB_INIT_SVC_PASSWORD

CREATE ROLE admin;
CREATE USER liquibase WITH ROLE admin;

-- cms_svc user
CREATE USER :cms_svc_username;
GRANT USAGE ON SCHEMA library TO :cms_svc_username;
GRANT SELECT, INSERT, UPDATE, DELETE ON library.books TO :cms_svc_username;
GRANT USAGE ON SCHEMA store TO :cms_svc_username;
GRANT SELECT, INSERT, UPDATE, DELETE ON store.isbn TO :cms_svc_username;
GRANT USAGE ON SCHEMA drm TO :cms_svc_username;
GRANT SELECT, INSERT, UPDATE, DELETE ON drm.encryption_keys TO :cms_svc_username;
ALTER USER :cms_svc_username WITH PASSWORD :cms_svc_password;

-- bookstore user
CREATE USER :bookstore_svc_username;
GRANT USAGE ON SCHEMA library TO :bookstore_svc_username;
GRANT SELECT ON library.books TO :bookstore_svc_username;
GRANT USAGE ON SCHEMA store TO :bookstore_svc_username;
GRANT SELECT ON store.isbn TO :bookstore_svc_username;
ALTER  USER :bookstore_svc_username WITH PASSWORD :bookstore_svc_password;

-- rental_svc user
\getenv rental_svc_username RENTAL_SVC_USERNAME
\getenv rental_svc_password RENTAL_SVC_DB_INIT_PASSWORD
CREATE USER :rental_svc_username;
GRANT USAGE ON SCHEMA library TO :rental_svc_username;
GRANT SELECT ON library.books TO :rental_svc_username;
GRANT USAGE ON SCHEMA store TO :rental_svc_username;
GRANT SELECT, INSERT, UPDATE, DELETE ON store.isbn TO :rental_svc_username;
ALTER  USER :rental_svc_username WITH PASSWORD :rental_svc_password;

-- kms_svc user
\getenv kms_svc_username KMS_SVC_USERNAME
\getenv kms_svc_password KMS_SVC_DB_INIT_PASSWORD
CREATE USER :kms_svc_username;
GRANT USAGE ON SCHEMA drm TO :kms_svc_username;
GRANT SELECT ON drm.encryption_keys TO :kms_svc_username;
ALTER  USER :kms_svc_username WITH PASSWORD :kms_svc_password;

