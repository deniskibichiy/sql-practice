
# SQL Practice

This repository documents my journey learning and practicing SQL using PostgreSQL.

## Objectives

- Build strong SQL fundamentals
- Learn relational database concepts
- Practice analytical SQL
- Develop proficiency with PostgreSQL
- Apply SQL to real-world datasets
- Build foundations for Data Engineering and Backend Engineering

## Technology

- PostgreSQL
- SQL
- Git
- GitHub
- Ubuntu Linux

## Learning Progress

- [ ] SELECT and FROM
- [ ] WHERE
- [ ] ORDER BY
- [ ] Aggregate functions
- [ ] GROUP BY
- [ ] HAVING
- [ ] CASE statements
- [ ] JOINs
- [ ] Subqueries
- [ ] CTEs
- [ ] Window functions
- [ ] Data transformation
- [ ] Query optimization

## Datasets

Current practice datasets include public transport journey data.

## Projects

### TFL Public Transport Analysis

Using PostgreSQL to analyze public transport journey data and answer analytical questions using SQL.
## 05-08-2026: Reading the Northwind CSV files with pandas

### Problem encountered

This problem is encountered during the first stage of data extraction which is inspecting the source data to identify the structure which would then inform the schema. Attempting to load the `customers.csv` file using the default `pandas.read_csv()` settings resulted in the following error:

```text
pandas.errors.ParserError:
Error tokenizing data.
C error: Expected 1 fields in line 30, saw 2
```

### Cause

Initially, `pandas.read_csv()` assumed that the file was comma-separated because the `sep` parameter was not specified.

However, the Northwind dataset uses the pipe character (`|`) as the field delimiter rather than commas. As a result, pandas interpreted each row as a single column until it encountered commas within text fields (such as addresses), producing a parsing error.

The dataset also represents missing values using the literal string `NULL` instead of leaving fields empty.

### Solution

Specify the correct delimiter when reading the file:

```python
import pandas as pd

customers = pd.read_csv(
    "datasets/Northwind/customers.csv",
    sep="|",
    na_values="NULL"
)
```

If a file does not include a header row, provide the column names manually using the `names` parameter and set `header=None`.

### Key takeaway

Before importing any CSV dataset, inspect its structure to determine:

* The field delimiter (comma, pipe, semicolon, tab, etc.).
* Whether a header row is present.
* How missing values are represented.
* Whether text fields contain delimiter characters that require proper parsing.

Making these checks before loading a dataset helps prevent parsing errors and ensures the data is imported correctly.
