--liquibase formatted sql

-- -- Changeset nghiadoan:insertSampleBook
-- INSERT into library.books(title, s3_bucket_name, s3_key) VALUES ('Implement DRM system', 'demodrm-bookstore', '85557c1d-3dcc-4122-8821-4dabe4c6e5e3');

-- Changeset nghiadoan:insertSampleBookInstance
INSERT into store.isbn(isbn, book_id) VALUES ('isbn1', '1');
-- Changeset nghiadoan:insertSampleBookCategories
INSERT INTO library.categories (name)
VALUES
('novel'),
('children books'),
('academic');
-- Changeset nghiadoan:insertSampleBookWithCategories
INSERT INTO library.books_categories (book_id, category_id) VALUES (1::integer, 1::integer);

-- Changeset nghiadoan:insert2ndSampleBook
Insert into library.books (title, s3_bucket_name, s3_key) values ('Africa the secrets', 'demodrm-bookstore', 'e42cf76a-fb42-494b-a0ff-2b956f3b6674');