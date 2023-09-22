--liquibase formatted sql

--changeset ushja:membership_history_1.0 labels:membership_history context:development
--comment: Retrieve records from the membership_history table.
SELECT * FROM membership_history;