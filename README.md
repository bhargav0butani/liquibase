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

For more information on Liquibase commands, please see the Liquibase documentation: Liquibase commands: https://docs.liquibase.com/commands/home.html

## Liquibase properties

The Liquibase properties file is a text file that configures the Liquibase runtime. It contains the following information:

- The database connection URL
- The database username and password
- Other Liquibase configuration settings

Please note that arguments that are entered at a command prompt override values that are specified in liquibase.properties.

## More Info

For more information, check out the Liquibase documentation : https://docs.liquibase.com/home.html