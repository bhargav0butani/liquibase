--liquibase formatted sql

--changeset USHJA:35.1 labels:host_invoice_report_log context:report_log
--comment: Creating table host_invoice_report_log and adding foreign key constraint.
CREATE TABLE IF NOT EXISTS public.host_invoice_report_log
	(
		id SERIAL PRIMARY KEY,
		host_application_mapper_id INTEGER,
		program_application_id INTEGER,
		competition_id INTEGER,
		competition_name TEXT,
		licensee_name TEXT,
		comp_year INTEGER,
		invoice_sent_date DATE,
		invoice TEXT,
		created_at TIMESTAMP WITH TIME ZONE,
		updated_at TIMESTAMP WITH TIME ZONE,
		created_by VARCHAR(255),
		updated_by VARCHAR(255),
		data_source VARCHAR(255)
	);

ALTER TABLE public.host_invoice_report_log
ADD CONSTRAINT fk_host_application_mapper_id
FOREIGN KEY (host_application_mapper_id)
REFERENCES public.host_application_mapper(id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

--rollback ALTER TABLE public.host_invoice_report_log; DROP CONSTRAINT fk_host_application_mapper_id;

