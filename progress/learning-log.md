# SQL Learning Log

## 2026-07-22: PostgreSQL Setup and SQL Fundamentals

### Objective

Begin building a local SQL practice environment using PostgreSQL and a publicly available transport dataset.

### Environment Setup

Installed PostgreSQL locally on Ubuntu.

Verified the installation:

```bash
psql --version
```
PostgreSQL version:
`18.4`
### Database setup
Created a dedicated PostgreSQL database:
```bash
sql_practice
```
Connected to the database using:
```bash
sudo -u postgres psql -d sql_practice
```
Verified the active database using:
```bash
SELECT current_database();
```
### Schema Setup

Created the tfl schema to organize the transport-related tables.
```bash
CREATE SCHEMA IF NOT EXISTS tfl;
```
### Dataset

Selected a publicly available public transport journeys dataset.

The original dataset contains periodic journey data for:

* Bus
* Underground
* DLR
* Tram
* Overground
* London Cable Car
* TfL Rail

The dataset was imported into PostgreSQL as:
```bash
tfl.raw_transport_data
```
### Data Import

The CSV was imported using PostgreSQL's \copy command.

The local dataset was:
```bash
public-transport-journeys.csv
```
The table was verified using:
``` SQL
SELECT *
FROM tfl.raw_transport_data
LIMIT 5;
```
### SQL Concepts Practiced

Today I practiced:

* SELECT
* FROM
* AS
* WHERE
* ANd

### Queries Practiced

Selected all columns:
```SQL
SELECT *
FROM tfl.raw_transport_data;
```
Selected specific columns:
```SQL
SELECT
    period_financial_year,
    bus_journeys_m,
    underground_journeys_m
FROM tfl.raw_transport_data;
```
Used aliases:
```SQL
SELECT
    period_financial_year AS financial_year,
    bus_journeys_m AS bus_journeys
FROM tfl.raw_transport_data;
```
Filtered records:
```SQL
SELECT
    period_financial_year,
    bus_journeys_m
FROM tfl.raw_transport_data
WHERE bus_journeys_m > 200;
```
### Key Learning

SQL queries can be understood as a process of translating an analytical question into a sequence of operations.

For basic queries:

What data do I want?

`SELECT`

Where is the data?

`FROM`

Which rows do I want?

`WHERE`

Do multiple conditions apply?
    
`AND / OR`
