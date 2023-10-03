# liquibase

## Introduction

This project uses Liquibase, Liquibase is an open-source database schema change management solution which enables you to manage revisions of your database changes easily.

## Getting Started

1. **Install Liquibase**: Follow the instructions on the Liquibase website to install Liquibase on your system. please refer the Liquibase documentation:https://docs.liquibase.com/start/install/home.html

2. **Set Up Database**: Ensure your database is up and running. Update the `liquibase.properties` file with your database connection details.

3. **Run Migrations**: Use Liquibase commands to apply changesets to your database. For example, you can use `liquibase update` to apply all changesets.

## Project Structure

- `changelog.xml`: This is the root changelog file that includes references to all other changelogs in the project.
- `changelog/`: This directory contains all the changeset files that define the changes to be made to the database.
- `liquibase.properties`: This file contains configuration details for connecting to your database.

## Commands

Here are some common Liquibase commands you might find useful:

- `liquibase update`: Applies all changesets to the connected database.
- `liquibase rollback --tag=myTag`: Rolls back changes to the state of the database when the specified tag was applied.
- `liquibase tag --tag=myTag`: Tags the current state of the database.
- `liquibase validate`: It will validate Referenced files can be found,Any required or prohibited attributes are correct to your database, There are no duplicated id,author, and file combinations and There are no checksum errors

For more information on Liquibase commands, please see the Liquibase documentation: Liquibase commands: https://docs.liquibase.com/commands/home.html

## Liquibase properties

The Liquibase properties file is a text file that configures the Liquibase runtime. It contains the following information:

- The database connection URL
- The database username and password
- Other Liquibase configuration settings

Please note that arguments that are entered at a command prompt override values that are specified in liquibase.properties.

## Changeset Syntax

Each changeset in a migration script is represented as follows:

--changeset <author>:<id> labels:<label> context:<context>
--comment: <comment>
--rollback <rollback command>

Components
- author: Identifier of the person who made the changes.
- id: Unique identifier for the changeset.
- label: Used to categorize the changeset.
- context: It is a reference to a feature of a changeset.
- comment: Description of what changes are being made.
- rollback: Command that undo the changes made in this changeset.

## Example

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

- First line indicates the start of a new changeset. The author is USHJA and the id is 35.1. The labels is host_invoice_report_log and the context is report_log.
- The comment provides a description of the changes being made in this changeset.
- The SQL commands that will be executed when this changeset is run. They create a new table and add a foreign key constraint.
- The rollback command specifies what should be done to undo the changes made in this changeset. In this case, it removes the foreign key constraint that was added.

## More Info

For more information, check out the Liquibase documentation : https://docs.liquibase.com/home.html