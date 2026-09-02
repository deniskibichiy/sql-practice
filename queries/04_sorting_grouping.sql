-- ============================================
-- 2026-07-30: Sorting and Grouping Practice
-- Dataset: Online Retail
-- Table: retail.online_retail
-- Focus: ORDER BY, GROUP BY, HAVING
-- ============================================


-- ============================================
-- SECTION 1: SORTING WITH ORDER BY
-- ============================================

-- Q1:
-- Find the 20 most expensive products based on unit price.
-- Return stock_code, description, and unit_price.
-- Exclude records where unit_price is NULL.
-- Sort from highest to lowest price.
SELECT stock_code, description, unit_price
FROM retail.online_retail
WHERE unit_price IS NOT NULL
ORDER BY unit_price DESC;

/*
  stock_code  |             description             | unit_price 
--------------+-------------------------------------+------------
 M            | Manual                              |    38970.0
 AMAZONFEE    | AMAZON FEE                          |   17836.46
 AMAZONFEE    | AMAZON FEE                          |   16888.02
 AMAZONFEE    | AMAZON FEE                          |   16453.71
 AMAZONFEE    | AMAZON FEE                          |   13541.33

*/

-- Q2:
-- Find the 20 transactions with the largest quantities.
-- Return invoice_no, stock_code, quantity, and country.
-- Sort from highest to lowest quantity.
SELECT invoice_no, stock_code, quantity, country
FROM retail.online_retail
ORDER BY quantity DESC
LIMIT 20;
/*
 invoice_no | stock_code | quantity |    country     
------------+------------+----------+----------------
 581483     | 23843      |    80995 | United Kingdom
 541431     | 23166      |    74215 | United Kingdom
 578841     | 84826      |    12540 | United Kingdom
*/
-- Q3:
-- Find the 20 cheapest products.
-- Return stock_code, description, and unit_price.
-- Exclude products with a unit price of zero.
-- Sort from lowest to highest price.
SELECT stock_code, description, unit_price
FROM retail.online_retail
WHERE unit_price > 0
ORDER BY unit_price
LIMIT 20;
*/
  stock_code  |             description             | unit_price 
--------------+-------------------------------------+------------
 BANK CHARGES | Bank Charges                        |      0.001
 PADS         | PADS TO MATCH ALL CUSHIONS          |      0.001
 PADS         | PADS TO MATCH ALL CUSHIONS          |      0.001
 PADS         | PADS TO MATCH ALL CUSHIONS          |      0.001
 D            | Discount                            |       0.01
 84347        | ROTATING SILVER ANGELS T-LIGHT HLDR |       0.03
*/

-- Q4:
-- Find transactions from the United Kingdom.
-- Sort them first by quantity from highest to lowest,
-- then by unit_price from highest to lowest.
-- Return invoice_no, quantity, unit_price, and country.
-- Return only the first 20 results.
SELECT invoice_no, quantity, unit_price, country
FROM retail.online_retail
WHERE country = 'United Kingdom'
ORDER BY quantity DESC, unit_price DESC
LIMIT 20;
/*
 invoice_no | quantity | unit_price |    country     
------------+----------+------------+----------------
 581483     |    80995 |       2.08 | United Kingdom
 541431     |    74215 |       1.04 | United Kingdom
 578841     |    12540 |        0.0 | United Kingdom
 542504     |     5568 |        0.0 | United Kingdom
 573008     |     4800 |       0.21 | United Kingdom
*/
-- ============================================
-- SECTION 2: GROUPING WITH GROUP BY
-- ============================================

-- Q5:
-- How many transactions are recorded for each country?
-- Return country and the number of transactions.
-- Sort from the country with the most transactions
-- to the country with the fewest.
SELECT country, COUNT(*) AS transaction_count
FROM retail.online_retail
GROUP BY country
ORDER BY COUNT(*) DESC;
/*
       country        | transaction_count 
----------------------+-------------------
 United Kingdom       |            495478
 Germany              |              9495
 France               |              8557
 EIRE                 |              8196
*/
-- Q6:
-- How many distinct customers are associated with each country?
-- Return country and the number of distinct customers.
-- Sort from highest to lowest.
SELECT COUNT(DISTINCT customer_id) AS customer_count, country
FROM retail.online_retail
GROUP BY country
ORDER BY customer_count DESC;

/* 
 customer_count |       country        
----------------+----------------------
           3950 | United Kingdom
             95 | Germany
             87 | France
             31 | Spain
             25 | Belgium
*/


-- Q7:
-- What is the average unit price for each country?
-- Return country and average unit price.
-- Sort from highest to lowest average unit price.
SELECT AVG(unit_price) AS average_unit_price, country
FROM retail.online_retail
GROUP BY country
ORDER BY average_unit_price DESC;
/*
  average_unit_price  |       country        
----------------------+----------------------
 109.6458078602620087 | Singapore
  42.5052083333333333 | Hong Kong
   8.5829756418696511 | Portugal
   6.3023633440514469 | Cyprus
   6.0303311258278146 | Canada
   6.0120257826887661 | Norway
*/
-- Q8:
-- What is the total quantity of products associated with each country?
-- Return country and total quantity.
-- Sort from highest to lowest total quantity.
SELECT country, SUM(quantity) AS total_quantity
FROM retail.online_retail 
GROUP BY country
ORDER BY total_quantity DESC;
/*
       country        | total_quantity 
----------------------+----------------
 United Kingdom       |        4263829
 Netherlands          |         200128
 EIRE                 |         142637
 Germany              |         117448
 France               |         110480
*/
-- Q9:
-- How many transactions occurred for each stock code?
-- Return stock_code and transaction count.
-- Sort from highest to lowest transaction count.
-- Return the top 20 stock codes.
SELECT COUNT(stock_code) AS transaction_count, stock_code
FROM retail.online_retail
GROUP BY stock_code
ORDER BY transaction_count DESC
LIMIT 20;
/*
 transaction_count | stock_code 
-------------------+------------
              2313 | 85123A
              2203 | 22423
              2159 | 85099B
              1727 | 47566
              1639 | 20725
              1502 | 84879
*/


-- ============================================
-- SECTION 3: GROUP BY WITH MULTIPLE FIELDS
-- ============================================

-- Q10:
-- How many transactions occurred for each country and stock code?
-- Return country, stock_code, and transaction count.
-- Sort by country alphabetically and transaction count
-- from highest to lowest within each country.

SELECT country, stock_code, COUNT(stock_code) AS transaction_count
FROM retail.online_retail
GROUP BY country
ORDER BY country, transaction_count;



-- Q11:
-- What is the average unit price for each country and stock code?
-- Return country, stock_code, and average unit price.
-- Sort from highest to lowest average unit price.
SELECT country, stock_code, AVG(unit_price) AS average_unit_price
FROM retail.online_retail
GROUP BY country, stock_code
ORDER BY average_unit_price DESC;

-- Q12:
-- How many transactions are associated with each country
-- and whether a CustomerID is present or missing?
-- Return country and an appropriate customer-status grouping.
-- Sort the results by country and transaction count.
SELECT country, COUNT(*) AS num_transactions, COUNT(customer_id) AS cust_id_present
FROM retail.online_retail
GROUP BY country;

-- ============================================
-- SECTION 4: GROUP BY + ORDER BY
-- ============================================

-- Q13:
-- Which 10 countries have the highest average unit price?
-- Return country and average unit price.
SELECT country, AVG(unit_price) AS average_unit_price
FROM retail.online_retail
GROUP BY country
ORDER BY average_unit_price DESC;

-- Q14:
-- Which 10 countries have the largest total quantity sold?
-- Return country and total quantity.
SELECT country, SUM(quantity) AS total_qnty
FROM retail.online_retail
GROUP BY country
ORDER BY total_qnty DESC;

-- Q15:
-- Which 20 stock codes appear in the greatest number of transactions?
-- Return stock_code and transaction count.
SELECT stock_code, COUNT(stock_code) AS transaction_count
FROM retail.online_retail
GROUP BY stock_code
ORDER BY transaction_count DESC
LIMIT 20;

-- Q16:
-- Which 20 products have the highest average unit price?
-- Return stock_code, description, and average unit price.
-- Group appropriately to avoid incorrectly combining
-- different products.
SELECT stock_code, description, ROUND(AVG(unit_price), 2) AS avg_unit_price 
FROM retail.online_retail
GROUP BY stock_code, description
ORDER BY avg_unit_price DESC
LIMIT 20;

-- ============================================
-- SECTION 5: HAVING
-- ============================================

-- Q17:
-- Which countries have more than 1,000 transactions?
-- Return country and transaction count.
-- Sort from highest to lowest transaction count.
SELECT country, COUNT(*) AS transaction_count
FROM retail.online_retail
GROUP BY country
HAVING COUNT(*) > 1000
ORDER BY transaction_count DESC;
-- Q18:
-- Which countries have more than 100 distinct customers?
-- Return country and distinct customer count.
-- Sort from highest to lowest.
SELECT country, COUNT(DISTINCT customer_id) AS num_dist_cust 
FROM retail.online_retail
GROUP BY country 
--HAVING COUNT(DISTINCT customer_id) > 100
ORDER BY num_dist_cust;

-- Q19:
-- Which stock codes appear in more than 100 transactions?
-- Return stock_code and transaction count.
-- Sort from highest to lowest.
SELECT stock_code, COUNT(*)  AS transaction_count
FROM retail.online_retail
GROUP BY stock_code
HAVING COUNT(*) > 1500
ORDER BY transaction_count DESC;

-- Q20:
-- Which countries have an average unit price greater than 10?
-- Return country and average unit price.
-- Sort from highest to lowest.
SELECT country, ROUND(AVG(unit_price), 2) AS average_unit_price
FROM retail.online_retail
GROUP BY country
HAVING AVG(unit_price) > 1
ORDER BY average_unit_price DESC;
-- ============================================
-- SECTION 6: WHERE + GROUP BY + HAVING
-- ============================================

-- Q21:
-- For transactions from countries other than the United Kingdom,
-- which countries have more than 100 transactions?
-- Return country and transaction count.
-- Sort from highest to lowest.
SELECT country, COUNT(*) AS transaction_count
FROM retail.online_retail
WHERE country NOT LIKE 'United Kingdom'
GROUP BY country
ORDER BY transaction_count DESC;
-- Q22:
-- For products with a unit price greater than 5,
-- which countries have more than 500 qualifying transactions?
-- Return country and transaction count.
SELECT country, COUNT(*) AS transaction_count
FROM retail.online_retail
WHERE unit_price > 5
GROUP BY country
HAVING COUNT(*) > 500;

-- Q23:
-- For transactions where CustomerID is available,
-- which countries have more than 100 distinct customers?
-- Return country and distinct customer count.
SELECT country, COUNT(DISTINCT customer_id) AS distinct_customer_count
FROM retail.online_retail
GROUP BY country
HAVING COUNT(DISTINCT customer_id) > 100;

-- Q24: 
-- For transactions with a positive quantity,
-- which countries have a total quantity greater than 10,000?
-- Return country and total quantity.
-- Sort from highest to lowest.
SELECT country, COUNT(quantity) AS total_quantity
FROM retail.online_retail
GROUP BY country
HAVING COUNT(quantity) > 10000
ORDER BY total_quantity DESC;

-- ============================================
-- SECTION 7: BUSINESS QUESTIONS
-- ============================================

-- Q25:
-- The business wants to identify its most active markets.
-- Which 10 countries have the highest number of transactions?
-- Return country and transaction count.


-- Q26:
-- The business wants to identify markets with a large
-- customer base.
-- Which countries have at least 50 distinct customers?
-- Return country and distinct customer count.
-- Sort from highest to lowest.


-- Q27:
-- The business wants to identify products that are
-- frequently purchased.
-- Which 10 stock codes appear in the most transactions?
-- Return stock_code and transaction count.


-- Q28:
-- The business wants to identify countries where customers
-- tend to purchase higher-priced products.
-- Which countries have more than 100 transactions and
-- an average unit price greater than 10?
-- Return country, transaction count, and average unit price.
-- Sort by average unit price from highest to lowest.


-- Q29:
-- The business wants to identify countries with strong
-- sales volume.
-- Which countries have more than 1,000 transactions
-- and a total quantity greater than 50,000?
-- Return country, transaction count, and total quantity.


-- Q30 — FINAL CHALLENGE:
-- Identify the top 5 countries by transaction volume,
-- excluding the United Kingdom.
-- Only include countries with at least 100 distinct customers.
-- Return:
-- country
-- transaction_count
-- distinct_customers
-- total_quantity
-- average_unit_price
-- Sort by transaction_count from highest to lowest.