--liquibase formatted sql

--changeset USHJA:create_table labels:Equestrian-create-table context:test
--comment: Create a new table.
CREATE TABLE equestrian (
  id SERIAL PRIMARY KEY,
  first_name VARCHAR(100),
  last_name VARCHAR(100)
);
--rollback DROP TABLE equestrian;

--changeset USHJA:add_column labels:Equestrian-add-column context:test
--comment: Add a new column to the table.
ALTER TABLE equestrian ADD COLUMN email VARCHAR(100);
--rollback ALTER TABLE equestrian DROP COLUMN email;

--changeset USHJA:rename_column labels:Equestrian-rename-column context:test
--comment: Rename a column in the table.
ALTER TABLE equestrian RENAME COLUMN email TO email_address;
--rollback ALTER TABLE equestrian RENAME COLUMN email_address TO email;