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
* The designed table is informed by the learned structure of the csv dataset and available at [04_create_online_retail_table.sql](`../setup/04_create_online_retail_table.sql`)

### Ingestion of the data into postgreSQL
1. Data cleaning to make sure that the csv file is compatible with the defined schema using pandas
```python
import pandas as pd

df = pd.read_excel("datasets/online+retail/Online Retail.xlsx")
df["CustomerID"] = df["CustomerID"].astype("Int64")
```
* The above step was necessary because initially I converted the xlsx to csv without converting the `CustomerID` data type to integer. Since the column contained `NULL` values, pandas export represented it with `float64` while in my schema I had designated the `customer_id` field's datatype as `INTEGER`.

2. Importing the csv file into postgreSQL
```bash
\COPY retail.online_retail
FROM '/home/denis/repos_two/sql-practice/datasets/online+retail/online_retail.csv'
WITH (FORMAT csv, HEADER true);
```
### Data type compatibility during ingestion

A key lesson from the first PostgreSQL ingestion attempt was that the PostgreSQL data type must be compatible with the **actual values being loaded**, not merely with what the values conceptually represent.

Although `CustomerID` conceptually represents an integer identifier, Pandas initially represented it as `float64` because the column contained `NULL` values. Consequently, the exported CSV contained values such as `17850.0`, which PostgreSQL could not directly load into an `INTEGER` column.

This resulted in the following error:

`invalid input syntax for type integer: "17850.0"`

The issue demonstrated the importance of inspecting and cleaning source data before ingestion. I resolved it by converting the `CustomerID` column to Pandas' nullable integer type (`Int64`) before exporting the data to CSV.

**Key takeaway:** The destination database schema should be designed according to the intended meaning of the data, but the source data must also be transformed into a representation that is compatible with the destination data types before ingestion.
### Successful CSV ingestion into PostgreSQL

After resolving the `CustomerID` data type mismatch, the cleaned CSV was successfully imported into the `retail.online_retail` PostgreSQL table.

The ingestion returned:

`COPY 541909`

The imported row count was then verified using `COUNT(*)`, confirming that all 541,909 records were loaded successfully.
### Summarizing data with aggregate functions
* The aggregate functions of concern include:
1. `SUM()`
2. `AVG`
3. `MIN()`
4. `MAX()`
5. `COUNT()`
* The aggregrate functions typically come after the `SELECT` keyword.
### how they are used in queries
```sql

SELECT AVG(budget)
FROM films;
--- returns average of all budget
SELECT SUM(budget)
FROM films

SELECT MIN(budget)
SELECT MAX(budget)
SELECT COUNT()
```
### which ones and how they work in non-numeric functions
* Only `SUM()` and `AVG()` must be used with numeric fields. The rest can work with datatypes that are not numbers.
`MIN()` <-> `MAX()`: will behave differently based on what is being handled

1. Alphabet A<-> Z
2. 1715 <-> 2022
3. 0 <-> 100

```sql
SELECT MIN(country)
FROM films
--- Afghanistant
SELECT MAX(country) AS max_country
FROM films
--- West Germany
```
## 26-7-2026: Summarizing subsets of data
1. Using `WHERE` with aggregate functions
```sql
SELECT MAX(budget) AS max_budget
FROM films
WHERE release_year = 2010;
```
2. Rounding off values
```sql
SELECT ROUND(AVG(budget), 2)
FROM films
WHERE release_year = 2010;

---negative parameters in `ROUND()` 
SELECT ROUND(AVG(budget), -5)
FROM films
WHERE release_year = 2010;
--- causes the rounding to be done to the nearest 10,000
--- 41100000
```

### Aliasing with Arithmetics
* -, +, * , /
```sql 
SELECT (4+3)
SELECT (4-2)
SELECT (4/3)
SELECT (4*3)
```
* The difference between arithmetic and aggregate functions is that arithmetic functions perform the operations on the records horizontally while aggregate functions perform the operations on fields vertically
* Aliases must be used with arithmetic functions since the sql does not provide defined fields when it produces results from arithmetic querries.
```sql 
SELECT (gross - budget) AS profit
FROM films
```
### Order of execution when arithmetic operations are involved
1. Step 1: `FROM`
2. Step 2: `WHERE`
3. Step 3: `SELECT`
4. Step 4: `LIMIT`
5.
* Aliases defined in the `SELECT` clause cannot be used in the `WHERE` clause due to the order of execution

## 2026-07-27: Sorting and grouping results
* Makes the data easier to understand
1. Sorting results with `ORDER BY`: sort results of one or more fields. Written after FROM if written on its own


```sql
SELECT title, budget
FROM films
--- Default is ascending order
WHERE budget IS NOT NULL
ORDER BY title DESC; --- sort by title alphabetically to sort the results in descending order
```
* It is not compulsory to select the fields we are sorting on but it is important to include the field used for sorting for the sake of clarity
* `ORDER BY` can be used to sort multiple fields. In this case the fields will be sorted by first field, then the subsequent fields 
* The second sorting field can be thought of as a tie-breaker
```sql 
SELECT title, wins, imdb_score
FROM best_movies
ORDER BY wins DESC, imdb_score DESC;
```
### Order of execution when ORDER BY is used
1. Step 1: `FROM`
2. Step 2: `WHERE`
3. Step 3: `SELECT`
4. step 4: `ORDER BY`
5. Step 5: `LIMIT`
### Grouping data
* Summarizing data for a particular group of results
```sql
SELECT certification, COUNT(title) AS title_count
FROM films 
GROUP BY certification;## 2026-07-27: Sorting and grouping results
* Makes the data easier to understand
1. `ORDER BY`: sort results of one or more fields. Written after FROM if written on its own

```sql
SELECT title, budget
FROM films
ORDER BY budget; --- Default is ascending order
WHERE budget IS NOT NULL
ORDER BY title DESC; --- sort by title alphabetically to sort the results in descending order
```
* It is not compulsory to select the fields we are sorting on but it is important to include the field used for sorting for the sake of clarity
* `ORDER BY` can be used to sort multiple fields. In this case the fields will be sorted by first field, then the subsequent fields 
* The second sorting field can be thought of as a tie-breaker
```sql 
SELECT title, wins, imdb_score
FROM best_movies
ORDER BY wins DESC, imdb_score DESC;
```
### Order of execution when ORDER BY is used
1. Step 1: `FROM`
2. Step 2: `WHERE`
3. Step 3: `SELECT`
4. step 4: `ORDER BY`
5. Step 5: `LIMIT`
### Grouping data
* Summarizing data for a particular group of results
```sql
SELECT certification, COUNT(title) AS title_count
FROM films 
GROUP BY certification;
```
* SQL returns an error if a field is selected and is not in the `GROUP BY` clause. 
```sql 
SELECT certification, title
FROM films
GROUP BY certification;
--- films.title must appear in the `GROUP BY` clause for it to be used in aggregate function

SELECT 
    certification, 
    COUNT(title) AS count_title
FROM films
GROUP BY certification
```
* `GROUP BY` can be used on multiple fields
```sql 
SELECT certification, language, COUNT(title) AS title_count
FROM films
GROUP BY certification, language;
```
* `GROUP BY` can be used together with `ORDER BY` to enhance summary statistics
```sql
SELECT 
    certification,
    COUNT(title) AS title_count
FROM films
GROUP BY certification
ORDER BY title_count DESC;
```
### Order of execution
1. Step 1: `FROM`
2. Step 2: `GROUP BY`
3. Step 3: `WHERE`
4. Step 3: `SELECT`
5. Step 4: `ORDER BY`
5. Step 4: `LIMIT`

```sql
-- Find the release_year, country, and max_budget, then group and order by release_year and country
SELECT release_year, country, MAX(budget) AS max_budget
FROM films
GROUP BY release_year, country
---Using the films table: which release_year had the most language diversity?
SELECT release_year, COUNT(DISTINCT language) AS distinct_languages
FROM films
GROUP BY release_year
ORDER BY distinct_languages DESC;
```
### Filtering grouped data
* In SQL we can't filter aggregate functions with `WHERE` clauses.
* `HAVING` clause: special clause available to groups 
```sql 
SELECT 
    release_year,
    COUNT(title) AS title_count
FROM films
GROUP BY release_year
HAVING COUNT(title) > 10;
```
### Order of execution
1. FROM
2. WHERE
3. GROUP BY
4. HAVING
5. SELECT
6. ORDER BY 
7. LIMIT
```sql
--- In what years was the average film duration over two hours?
SELECT release_year
FROM films
GROUP BY release_year
HAVING AVG(duration) > 120;
--- Find the country with the most diverse certifications
-- Select the country and distinct count of certification as certification_count
SELECT country, COUNT(DISTINCT certification) AS certification_count
FROM films
-- Group by country
GROUP BY country
-- Filter results to countries with more than 10 different certifications
HAVING COUNT(DISTINCT certification) > 10
-- Select the country and average_budget from films
SELECT country, AVG(budget) AS average_budget
FROM films
-- Group by country
GROUP BY country
-- Filter to countries with an average_budget of more than one billion
HAVING AVG(budget) > 1000000000
-- Order by descending order of the aggregated budget
ORDER BY average_budget DESC;
--- In this exercise, you'll write a query that returns the average budget and gross earnings for films each year after 1990 if the average budget is greater than 60 million.

SELECT release_year, AVG(budget) AS avg_budget, AVG(gross) AS avg_gross
FROM films
WHERE release_year > 1990
GROUP BY release_year
HAVING AVG(budget) > 60000000
-- Order the results from highest to lowest average gross and limit to one
ORDER BY avg_gross DESC
LIMIT 1;
```
### Summary of intermediate SQL
1. Selecting with `COUNT` and `LIMIT`
2. Filtering with `WHERE`, `BETWEEN`, `AND`, `OR`, `LIKE`, `NOT LIKE`, `IN`, `%`, `_`, `IS NULL`, `IS NOT NULL`
3. `ROUND` and aggregate functions
4. Sorting and grouping
5. Handling errors, handling missing values.
## 2026- 07- 31
### Joining data in sql
* Primary keys play a critical role in joins.
* You can join on a key field on a key field or any other field.
1. `INNER JOIN` looks for records in both tables which match on a given field
```sql
SELECT prime_ministers.country, prime_ministers.continent, prime_minister, president
FROM presidents
INNER JOIN prime_ministers
ON presidents.country = prime_ministers.country;

SELECT * 
FROM cities
-- Inner join to countries
INNER JOIN countries
-- Match on country codes
ON countries.code = cities.country_code;

-- Select name fields (with alias) and region 
SELECT cities.name AS city, countries.name AS country, region
FROM cities
INNER JOIN countries
ON cities.country_code = countries.code;

-- Select fields with aliases
SELECT c.code AS country_code, c.name, e.year, e.inflation_rate
FROM countries AS c
-- Join to economies (alias e)
INNER JOIN economies AS e
-- Match on code field using table aliases
ON c.code = e.code;
```
2. `USING` clause can be used instead of `ON` keyword when both the field names being joined on are the same.
```sql
SELECT c.name AS country, l.name AS language, official
FROM countries AS c
INNER JOIN languages AS l
-- Match using the code column
USING(code);
```
### Defining Relationships
* **One to many:** A single entity is associated with several entities. This is the most common relationship type, where one record in a table can be associated with multiple records in another. For example, a single artist can produce many songs, similar to how Jane Austen, an author, has written multiple books.

* **One-to-One Relationships:** These relationships involve a uniqu pairing between records in two tables. An example is fingerprint, where each person has unique fingerprint, illustrating the 1-t0-1 relationship between an individual and his fingerprint.

* **Many-to-Many Relationships:** Multiple records in a table can related to multiple records in another. 

## 2026-08-01: Multiple Joins
### Chaining joins
* A powerfu feature of SQL is that multiple joins can be combined and ran on a single query.
```sql
SELECT * 
FROM left_table 
INNER JOIN right_table
ON left_table.id = right_table.id
INNER JOIN another_table
ON left_table.id = another_table.id;

-- e.g

SELECT p1.country, p1.continent, president, prime_minister, pm_start
FROM prime_ministers AS P1
INNER JOIN presidents as p2
USING(country)
INNER JOIN prime_minister_terms as p3
USING (prime_minister);
```
### Joining on multiple keys
* It is not always the case that in SQL, tables being joined together have values in the field in one table that correspond to only one instance in the table being joined to. In some cases, the field being joined on meets the query criteria on multiple records. 

* We can limit the records returned by supplying an additional key to join on using the `AND` clause. 

```bash
# Economies
econ_id	code	year	income_group	gdp_percapita	gross_savings	inflation_rate	total_investment	unemployment_rate	exports	imports
1	AFG	2010	Low income	539.667	37.133	2.179	30.402	null	46.394	24.381

#Countries
code	name	continent	region	surface_area	indep_year	local_name	gov_form	capital	cap_long	cap_lat
AFG	Afghanistan	Asia	Southern and Central Asia	652090	1919	Afganistan/Afqanestan	Islamic Emirate	Kabul	69.1761	34.5228
NLD	Netherlands	Europe	Western Europe	41526	1581	Nederland	Constitutional Monarchy	Amsterdam	4.89095	52.3738
# populations
pop_id	country_code	year	fertility_rate	life_expectancy	size
20	ABW	2010	1.704	74.95354	101597
19	ABW	2015	1.647	75.573586	103889
```
### Exercise in consideration of the tables above
1. Suppose you are interested in the relationship between fertility and unemployment rate. Join tables to return the country name, year, fertility rate, and unemployment rate in a single result from the countries, populations, and economies table
```sql
SELECT name, e.year, fertility_rate, unemployment_rate
FROM countries AS c
INNER JOIN populations AS p
ON c.code = p.country_code
INNER JOIN economies AS e
ON c.code = e.code
-- Add an additional joining condition such that you are also joining on year
	AND e.year = p.year;

```
## Outer Joins
* Outer joins can obtain records from other tables even when matches are not found for the fields being joined on.
### LEFT JOIN or LEFT OUTER JOIN
* Left jonis will return all records in the left table, and those records in the right table that match on the joining field provided.  If there is no match, the result is `NULL` on the side of the right table. 
* For example, when joining the a table of countries with a table of capitals using `LEFT JOIN`, all countries will be listed, including those without a capital in the dataset. 
```sql 
SELECT p1.country, primen_minister, president
FROM prime_ministers AS p1
LEFT JOIN presidents AS p2
USING(country);
--- Selects all countries with prime ministers and presidents if they do or null if they don't have.
```

```sql
--- return all countries in the cities table regardless of whether or not they have a match on the countries table.
SELECT 
	c1.name AS city, 
    code, 
    c2.name AS country,
    region, 
    city_proper_pop
FROM cities AS c1
-- Join right table (with alias)
LEFT JOIN countries as c2
ON c1.country_code = c2.code
ORDER BY code DESC;

--use AVG() in combination with a LEFT JOIN to determine the average gross domestic product (GDP) per capita by region in 2010.

```

### RIGHT JOIN OR RIGHT OUTER JOIN
* Does the reverse. All records are returned for the right table even when matches are not found on the left table in the matching field. Null values are returned on the left value where there is no matching value on the right.
* Less commonly used because it can always be rewritten as `LEFT JOIN`
```sql

-- Modify this query to use RIGHT JOIN instead of LEFT JOIN
-- Modify this query to use RIGHT JOIN instead of LEFT JOIN
SELECT countries.name AS country, languages.name AS language, percent
FROM countries
LEFT JOIN languages
USING(code)
ORDER BY language;
--modified
SELECT countries.name AS country, languages.name AS language, percent
FROM languages
RIGHT JOIN countries
USING(code)
ORDER BY language;
```
# 04-08-2026: Loading the Northwind Dataset into PostgreSQL for Advanced SQL JOIN Operations

## Objectives of the Day

1. Complete the remaining SQL JOIN topics:

   * FULL JOIN
   * CROSS JOIN
   * SELF JOIN
2. Load the Northwind dataset into a local PostgreSQL database using an ETL workflow.
3. Document the complete loading process, including encountered errors and how they were resolved.
4. Begin solving realistic SQL problems that involve joining multiple related tables.
5. Prepare the database for more advanced SQL concepts including aggregation, subqueries, Common Table Expressions (CTEs), and window functions.

Dataset:
https://github.com/skaiworldwide-oss/import-northwind/blob/master/orders.csv

---

## FULL JOIN

`FULL JOIN` combines the behaviour of both `LEFT JOIN` and `RIGHT JOIN`.

It returns:

* every record from the left table,
* every record from the right table,
* matching rows merged together,
* `NULL` values wherever no corresponding match exists.

Unlike an `INNER JOIN`, records are never discarded simply because they do not have a matching key.

General syntax:

```sql
SELECT
    left_table.id,
    right_table.id
FROM left_table
FULL JOIN right_table
USING(id);

-- equivalent
FULL OUTER JOIN
```

Example:

```sql
SELECT
    p1.country,
    prime_minister,
    president
FROM prime_ministers AS p1
FULL JOIN presidents AS p2
ON p1.country = p2.country;
```

Suppose the data looked like this:

### countries

| code | country     |
| ---- | ----------- |
| AFG  | Afghanistan |
| ALB  | Albania     |
| NLD  | Netherlands |

### currencies

| code | basic_unit |
| ---- | ---------- |
| AFG  | Afghani    |
| ALB  | Lek        |
| USA  | Dollar     |

Result:

| country     | code | basic_unit |
| ----------- | ---- | ---------- |
| Afghanistan | AFG  | Afghani    |
| Albania     | ALB  | Lek        |
| Netherlands | NLD  | NULL       |
| NULL        | USA  | Dollar     |

Notice:

* Netherlands has no matching currency.
* USA has no matching country.
* Both are preserved.

This is exactly what distinguishes a FULL JOIN from an INNER JOIN.

---

## Practice

```sql
SELECT
    name AS country,
    code,
    region,
    basic_unit
FROM countries
FULL JOIN currencies
USING(code)
WHERE region='North America'
   OR name IS NULL
ORDER BY region;
```

This query keeps

* all North American countries,
* every unmatched currency.

---

## Comparing FULL, LEFT and INNER JOIN

### FULL JOIN

Returns

* all countries
* all currencies
* NULL values for missing matches on either side

```sql
SELECT
    name AS country,
    code,
    region,
    basic_unit
FROM countries
FULL JOIN currencies
USING(code)
WHERE region='North America'
   OR name IS NULL;
```

---

### LEFT JOIN

Returns

* every country
* matching currency information only

```sql
SELECT
    name AS country,
    code,
    region,
    basic_unit
FROM countries
LEFT JOIN currencies
USING(code)
WHERE region='North America'
   OR name IS NULL;
```

Since `countries` is the left table, every country is preserved.

---

### INNER JOIN

Returns only records that exist in both tables.

```sql
SELECT
    name AS country,
    code,
    region,
    basic_unit
FROM countries
INNER JOIN currencies
USING(code)
WHERE region='North America'
   OR name IS NULL;
```

Any country without a currency and any currency without a country disappear from the result.

---

## Chaining FULL JOINs

SQL joins are not limited to two tables.

As long as tables share a common key, multiple joins can be chained together to produce richer datasets.

Suppose we also have a `languages` table.

```sql
SELECT
    c1.name AS country,
    region,
    l.name AS language,
    basic_unit,
    frac_unit
FROM countries AS c1
FULL JOIN languages AS l
USING(code)
FULL JOIN currencies AS c2
USING(code)
WHERE region LIKE 'M%esia';
```

This query combines information from

* countries
* languages
* currencies

into a single result set.

This idea is fundamental in relational databases because real-world information is intentionally split into multiple related tables.

---

## CROSS JOIN

A `CROSS JOIN` produces every possible combination of rows from two tables.

General syntax:

```sql
SELECT *
FROM table1
CROSS JOIN table2;
```

If

Table A contains **10** rows

and

Table B contains **5** rows,

the result contains

```
10 × 5 = 50 rows
```

Example:

```sql
SELECT
    prime_minister,
    president
FROM prime_ministers AS p1
CROSS JOIN presidents AS p2
WHERE p1.continent='Asia'
AND p2.continent='South America';
```

Typical use cases include

* generating combinations,
* scheduling,
* recommendation systems,
* simulation,
* exhaustive testing.

Unlike other joins, no matching column is required.

---

## SELF JOIN

A SELF JOIN joins a table to itself.

Since SQL cannot distinguish between two references to the same table, aliases are mandatory.

General syntax:

```sql
SELECT
    a.column,
    b.column
FROM table_name AS a
JOIN table_name AS b
ON a.id=b.id;
```

Example:

```sql
SELECT
    p1.country AS country1,
    p2.country AS country2,
    p1.continent
FROM prime_ministers AS p1
INNER JOIN prime_ministers AS p2
ON p1.continent=p2.continent
AND p1.country<>p2.country
LIMIT 10;
```

This query finds countries that belong to the same continent.

Common applications include

* employee-manager relationships,
* organisational hierarchies,
* prerequisite courses,
* recommendation graphs,
* comparing records within the same table.

---

# Transition to the Northwind Database

The previous exercises used small educational datasets to illustrate how different types of joins work.

The Northwind database introduces a realistic business scenario where nearly every query requires joining multiple related tables.

Some important relationships include:

```bash
Customers
      │
      │
Orders
      │
      │
Order Details
      │
      ├──────── Products
      │               │
      │               │
      │          Categories
      │
Employees
      │
Shippers
      │
Suppliers
```

Example questions that require joins include:

* Which customers placed the highest-value orders?
* Which employee processed the most orders?
* Which supplier provides products in each category?
* Which products generated the highest revenue?
* Which customers have never placed an order?

Answering these questions requires combining information spread across several related tables, making the Northwind database an excellent environment for mastering SQL joins.

---

# ETL Workflow for Loading Northwind into PostgreSQL

The loading process follows a simple ETL (Extract, Transform, Load) pipeline.

## Extract

* Download the Northwind dataset.
* Identify all CSV files.
* Inspect column names and data types.

## Transform

* Clean missing values.
* Standardize column formats.
* Convert dates and numeric fields where necessary.
* Ensure primary and foreign keys remain consistent.

## Load

* Create PostgreSQL tables.
* Define constraints.
* Import CSV files.
* Verify row counts.
* Test joins between related tables.
