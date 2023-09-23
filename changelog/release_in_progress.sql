--liquibase formatted sql

--changeset ushja:individual2.0 labels:Update_Individual.3874 context:development
--comment: Update first_name in the individual table for individual id 3874.
UPDATE individual
SET first_name = 'BHARGAV 001'
WHERE id = '3874'

--rollback UPDATE individual SET first_name = 'Bhargav Itera' WHERE id = '3874'