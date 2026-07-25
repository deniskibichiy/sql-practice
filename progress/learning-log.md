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

## 2026-07-24: Filtering records in SQL
### Using multiple criteria to filter data
`OR`: 
* Filtering multiple criteria but want to meet only one criteria
```SQL
SELECT title
FROM films
WHERE year = 1994
    OR year = 2004;

```
`AND` and `OR`:
```SQL
SELECT title
FROM films
WHERE (year = 1994 OR year = 2004)
    AND (year = 2004 OR year = 2003)

```
`BETWEEN`:
```SQL
SELECT title
FROM films
WHERE year 
    BETWEEN 1990 AND 2004;
--- Inclusive and indicated values are included
```
## 2026-07-25: Filtering text using wild card, `LIKE`, `NOT LIKE`, and `IN`
* Retrieving based on patterns
### `LIKE`:

LIKE used with WHERE to search for patterns. Uses wild cards
1. `%`: matches zero, one or many characters

```SQL
SELECT name
FROM people
WHERE name LIKE 'Ade%';
```
2. `_`: Matches a single character

```SQL
SELECT name
FROM people
WHERE name LIKE 'Ev_';
```
### NOT LIKE
Used to filter records that don't match the  pattern that is specified by the specific wild cards

```sql 
SELECT name
FROM people
WHERE name NOT LIKE 'A.%';
```
### Combining and positioning wild cards

```sql
SELECT name 
FROM people 
WHERE name LIKE '%r';
```
Retrieves records where names end in r

```sql 
SELECT name
FROM people 
WHERE name LIKE '_ _t%';
```
Retrieves records where the third character is t

### Filtering based on many conditions or clauses
Can be achieved by chaining multiple operators

```SQL 
SELECT title
FROM films
WHERE release_year = 1920
    OR release_year = 1930
    OR release_year = 1940;
```
Instead of the above messy code, we can instead use `IN` operator which allows the specification of multiple values in a `WHERE` clause allow setting of multiple conditions to inform data retrieval

```sql
SELECT title
FROM films
WHERE release_year IN (1920, 1930, 1940);
```
### FIltering data that include Null values
* `COUNT(field_name)` selects only non-missing values
*  `COUNT(*)`: includes missing values
`NULL` values are missing values
`IS NULL` is used with the `WHERE` clause
```sql
SELECT COUNT(*) AS no_birthdate
FROM people 
--- Filter values where birthdate does not exist
WHERE birthdate IS NULL;
--- Filter values where there is birthdate
WHERE birth_date IS NOT NULL;
```
### Multi-clause and text filtering practice
#### Selecting a new dataset with desired features for practice and Loading it to postgreSQL
1. Downloaded the dataset as xlsx
```bash
:~/repos_two/sql-practice$ ls datasets/online+retail/ -lh
total 23M
-rwx------ 1 denis-kibichiy denis-kibichiy 23M May 22  2023  'Online Retail.xlsx'
```
2. Inspection of the source data using pandas to learn about the features of the dataset and converting to csv for easier exporting to postgreSQL
```bash
>>> import pandas as pd
>>> df = pd.read_excel("datasets/online+retail/Online Retail.xlsx")
>>> df.shape
(541909, 8)
>>> df.columns
Index(['InvoiceNo', 'StockCode', 'Description', 'Quantity', 'InvoiceDate',
       'UnitPrice', 'CustomerID', 'Country'],
      dtype='str')
>>> df.dtypes
InvoiceNo              object
StockCode              object
Description            object
Quantity                int64
InvoiceDate    datetime64[us]
UnitPrice             float64
CustomerID            float64
Country                   str
dtype: object
>>> df.isnull().sum()
InvoiceNo           0
StockCode           0
Description      1454
Quantity            0
InvoiceDate         0
UnitPrice           0
CustomerID     135080
Country             0
dtype: int64
>>> df.head()
  InvoiceNo StockCode  ... CustomerID         Country
0    536365    85123A  ...    17850.0  United Kingdom
1    536365     71053  ...    17850.0  United Kingdom
2    536365    84406B  ...    17850.0  United Kingdom
3    536365    84029G  ...    17850.0  United Kingdom
4    536365    84029E  ...    17850.0  United Kingdom

[5 rows x 8 columns]
>>> df.to_csv(
...     "datasets/online+retail/online_retail.csv",
...     index=False
... )
```
Based on the above dataset inspection, I was able to answer key questions such as 
* How many columns are there in the dataset?
* How many rows?
* What are the column names?
* What datatype does each column have?
* Which columns contains `NULL` values and how many are they?
3. Loading the dataset into postgreSQL
### Creating the schema that will outline the structure of the dataset
```sql
CREATE SCHEMA IF NOT EXISTS retail;
```
### Designing the table that will hold the data imported from the csv
