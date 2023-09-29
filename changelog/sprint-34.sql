--liquibase formatted sql

--changeset USHJA:LO_clinic_licence labels:LO_clinic_licence context:development
--comment: Creating the clinic_attendee_status type and adding new columns to the clinic_attendees table ,Truncating the license_requirements table and adding new columns ,Inserting data into the license_requirements table
--precondition-sql-check expectedResult:0 SELECT COUNT (*) FROM pg_type WHERE typname = 'clinic_attendee_status'
CREATE TYPE clinic_attendee_status AS ENUM ('CLINICIAN', 'ATTENDEE');
ALTER TABLE public.clinic_attendees 
	ADD COLUMN IF NOT EXISTS attendee_status clinic_attendee_status,
	ADD COLUMN IF NOT EXISTS is_license_expired boolean,
	ADD COLUMN IF NOT EXISTS is_notebook_cost_added boolean;

TRUNCATE TABLE public.license_requirements;

ALTER TABLE public.license_requirements
	ADD COLUMN IF NOT EXISTS license_type character varying(20),
	ADD COLUMN IF NOT EXISTS type character varying(20);

INSERT INTO public.license_requirements (name, license_type, type) VALUES
		('C1 Steward', '''r''', 'license'),
		('C1 Steward', '''R''', 'license'),
		('Hunter', '''r''', 'license'),
		('Hunter', '''R''', 'license'),
		('Hunter Breeding', '''R''', 'license'),
		('Hunter CD', '''r''', 'license'),
		('Hunter CD', '''R''', 'license'),
		('Hunter CD', 'Regional', 'license'),
		('Hunter/Jumping Seat Equitation', '''r''', 'license'),
		('Hunter/Jumping Seat Equitation', '''R''', 'license'),
		('Jumper', '''r''', 'license'),
		('Jumper', '''R''', 'license'),
		('Jumper CD', '''r''', 'license'),
		('Jumper CD', '''R''', 'license'),
		('Hunter Breeding', null, 'certificate');

--rollback DROP TYPE clinic_attendee_status CASCADE; ALTER TABLE public.clinic_attendees DROP COLUMN IF EXISTS attendee_status, DROP COLUMN is_license_expired, DROP COLUMN is_notebook_cost_added
--rollback DROP TABLE license_requirements;
--rollback DELETE FROM public.license_requirements;

--changeset USHJA:LO_clinic labels:LO_clinic_sprint34 context:development
--comment: Inserting data into the scheduler table , Creating the clinic_attendee_licenses table and adding foreign keys, Creating the clinic_attendee_notebooks table and adding foreign keys, Creating the clinic_attendee_sections table, Altering the clinic_attendee_sections and clinics tables, and adding foreign keys, Altering the clinics_docs and clinic_sections tables, Creating the individual_shopping_cart_clinic, individual_shopping_cart_clinic_section, and individual_clinic_payment tables
INSERT INTO public.scheduler
(id, scheduler_name, cron, status, created_by, updated_by, description, data_source)
VALUES(25, 'Close LO clinic registration', '1 1 1 * * *', true, 'SYSTEM', 'SYSTEM', 'This job changes the Open Registration flag to false on the close date', NULL);

CREATE TABLE IF NOT EXISTS public.clinic_attendee_licenses (
	id serial4 NOT NULL,
	license_requirement_id int4 NULL,
	clinic_attendee_id int4 NULL,
	exam_score float4 NULL,
	is_credit_received bool NULL DEFAULT false,
	created_at timestamp NOT NULL DEFAULT now(),
	updated_at timestamp NOT NULL DEFAULT now(),
	created_by varchar(100) NULL,
	updated_by varchar(100) NULL,
	data_source varchar(50) NULL,
	CONSTRAINT clinic_attendee_licenses_pkey PRIMARY KEY (id)
);
ALTER TABLE public.clinic_attendee_licenses ADD CONSTRAINT licenses_clinic_attendee_id_fkey FOREIGN KEY (clinic_attendee_id) REFERENCES public.clinic_attendees(id) ON DELETE CASCADE;
ALTER TABLE public.clinic_attendee_licenses ADD CONSTRAINT licenses_license_requirement_id_fkey FOREIGN KEY (license_requirement_id) REFERENCES public.license_requirements(id) ON DELETE CASCADE;

CREATE TABLE IF NOT EXISTS public.clinic_attendee_notebooks (
	id serial4 NOT NULL,
	"name" varchar(100) NULL,
	address1 varchar(250) NULL,
	address2 varchar(250) NULL,
	city varchar(50) NULL,
	state varchar(50) NULL,
	zip varchar(50) NULL,
	country varchar(50) NULL,
	created_at timestamp NOT NULL DEFAULT now(),
	updated_at timestamp NOT NULL DEFAULT now(),
	created_by varchar(100) NULL,
	updated_by varchar(100) NULL,
	data_source varchar(50) NULL,
	clinic_attendee_id int4 NULL,
	amount int4 NULL,
	CONSTRAINT clinic_attendee_notebooks_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.clinic_attendee_sections (
	id serial4 NOT NULL,
	clinic_attendee_id int4 NULL,
	section_id int4 NULL,
	amount int4 NULL,
	created_at timestamp NOT NULL DEFAULT now(),
	updated_at timestamp NOT NULL DEFAULT now(),
	created_by varchar(100) NULL,
	updated_by varchar(100) NULL,
	data_source varchar(50) NULL,
	CONSTRAINT clinic_attendee_sections_pkey PRIMARY KEY (id)
);

ALTER TABLE public.clinics ADD IF NOT EXISTS notebook_cost int4 NULL;
ALTER TABLE public.clinics ADD IF NOT EXISTS close_date date NULL;

ALTER TABLE public.clinics_docs ADD IF NOT EXISTS is_info_sheet bool  NULL DEFAULT false;
ALTER TABLE public.clinics_docs ADD IF NOT EXISTS description text NULL;
ALTER TABLE public.clinic_sections ADD IF NOT EXISTS is_allow_auditors bool NULL DEFAULT false;
ALTER TABLE public.clinic_sections ADD IF NOT EXISTS is_all_checklist_required bool NULL DEFAULT false;
alter table clinic_sections drop column IF EXISTS notebook_cost;
ALTER TYPE public."clinic_attendee_status" ADD VALUE IF NOT EXISTS 'AUDITOR';
ALTER TABLE public.clinics ALTER column custom_clinic_id type varchar(50);
ALTER TABLE clinics drop constraint IF EXISTS clinics_custom_clinic_id_key;

CREATE TABLE IF NOT EXISTS public.individual_shopping_cart_clinic
(
	id SERIAL PRIMARY KEY,
	individual_shopping_cart_id integer,
	clinic_id integer,
	notebook json null,
	created_at TIMESTAMP WITH TIME ZONE,
	updated_at TIMESTAMP WITH TIME ZONE,
	created_by VARCHAR(255),
	updated_by VARCHAR(255),
	data_source VARCHAR(255),
	CONSTRAINT individual_shopping_cart_id_fkey FOREIGN KEY (individual_shopping_cart_id)
        REFERENCES public.individual_shopping_cart (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        NOT VALID
);
CREATE TABLE IF NOT EXISTS public.individual_shopping_cart_clinic_section
(
	id SERIAL PRIMARY KEY,
	individual_shopping_cart_clinic_id integer,
	section_id integer,
	created_at TIMESTAMP WITH TIME ZONE,
	updated_at TIMESTAMP WITH TIME ZONE,
	created_by VARCHAR(255),
	updated_by VARCHAR(255),
	data_source VARCHAR(255),
	CONSTRAINT individual_shopping_cart_clinic_id_fkey FOREIGN KEY (individual_shopping_cart_clinic_id)
        REFERENCES public.individual_shopping_cart_clinic (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        NOT VALID
);
CREATE TABLE IF NOT EXISTS public.individual_clinic_payment
(
	id SERIAL PRIMARY KEY,
	authorize_transaction_id VARCHAR(255),
	individual_id integer,
	clinic_id integer,
	section_id integer,
	section_amount integer,
	notebook_amount integer,
	created_at TIMESTAMP WITH TIME ZONE,
	updated_at TIMESTAMP WITH TIME ZONE,
	created_by VARCHAR(255),
	updated_by VARCHAR(255),
	data_source VARCHAR(255)
);
--rollback DELETE FROM public.scheduler WHERE id = 23;

--rollback DROP TABLE public.clinic_attendee_licenses;

--rollback DROP TABLE public.clinic_attendee_notebooks;

--rollback DROP TABLE public.clinic_attendee_sections;

--rollback ALTER TABLE public.clinic_attendee_sections DROP CONSTRAINT sections_clinic_attendee_id_fkey; ALTER TABLE public.clinic_attendee_sections DROP CONSTRAINT sections_clinic_section_id_fkey; ALTER TABLE public.clinics DROP COLUMN notebook_cost; ALTER TABLE public.clinics DROP COLUMN close_date;

--rollback ALTER TABLE public.clinics_docs DROP COLUMN is_info_sheet; ALTER TABLE public.clinics_docs DROP COLUMN description; ALTER TABLE public.clinic_sections DROP COLUMN is_allow_auditors; ALTER TABLE public.clinic_sections DROP COLUMN is_all_checklist_required;

--rollback DROP TABLE IF EXISTS individual_shopping_cart_clinic CASCADE; DROP TABLE IF EXISTS individual_shopping_cart_clinic_section; DROP TABLE IF EXISTS individual_clinic_payment;