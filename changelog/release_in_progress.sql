--liquibase formatted sql

--changeset ushja:membership_history_2.0 labels:membership_history2.0 context:development
--comment: Retrieve records from the membership_history table.
SELECT * FROM membership_history;