--liquibase formatted sql

--changeset ushja:membership_history_3.0 labels:membership_history3.0 context:development
--comment: Retrieve records from the membership_history table.
SELECT * FROM membership_history;