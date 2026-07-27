-- ============================================
-- 2026-07-25: Text Filtering Practice
-- Dataset: Online Retail
-- Table: retail.online_retail
-- Focus: LIKE, NOT LIKE, IN, NULL filtering
-- ============================================


-- ============================================
-- SECTION 1: LIKE with %
-- ============================================

-- Q1: Find all products whose descriptions begin with 'WHITE'.
-- Return description.
SELECT description
FROM retail.online_retail
WHERE description LIKE 'WHITE%';

-- Q2: Find all products whose descriptions end with 'SET'.
-- Return description.
SELECT description 
FROM retail.online_retail
WHERE description LIKE '%SET';

-- Q3: Find all products whose descriptions contain 'BAG' anywhere.
-- Return stock_code and description.

SELECT description, stock_code
FROM retail.online_retail
WHERE description LIKE '%BAG%';
```bash
             description             | stock_code 
-------------------------------------+------------
 CHARLOTTE BAG DOLLY GIRL DESIGN     | 22661
 JUMBO BAG PINK POLKADOT             | 22386
 STRAWBERRY CHARLOTTE BAG            | 20723
```
-- Q4: Find all products whose descriptions contain 'CHRISTMAS'.
-- Return stock_code and description.

SELECT description, stock_code
FROM retail.online_retail
WHERE description LIKE '%CHRISTMAS%';
```bash
            description             | stock_code 
-------------------------------------+------------
 PAPER CHAIN KIT 50'S CHRISTMAS      | 22086
 TRADITIONAL CHRISTMAS RIBBONS       | 85049A
 CHRISTMAS LIGHTS 10 REINDEER        | 22941
```
-- ============================================
-- SECTION 2: LIKE with _
-- ============================================

-- Q5: Find descriptions where the second character is 'A'.
-- Return description.

SELECT description 
FROM retail.online_retail
WHERE description LIKE '_A%';

```bash
             description             
-------------------------------------
 HAND WARMER UNION JACK
 BATH BUILDING BLOCK WORD
 PAPER CHAIN KIT 50'S CHRISTMAS 
 ```

-- Q6: Find descriptions where the third character is 'T'.
-- Return description.
SELECT description 
FROM retail.online_retail
WHERE description LIKE '__T%';
```bash
             description             
-------------------------------------
 SET 7 BABUSHKA NESTING BOXES
 BATH BUILDING BLOCK WORD
 SET/2 RED RETROSPOT TEA TOWELS 
 ```

-- Q7: Find descriptions that begin with exactly three characters
-- followed by the word 'BAG'.
-- Return description.
-- ============================================
-- Exploring which countries are available within this dataset
-- ============================================
SELECT DISTINCT country
FROM retail.online_retail;

SELECT COUNT(DISTINCT country)
FROM retail.online_retail;
-- 38 countries
-- ============================================
-- SECTION 3: NOT LIKE
-- ============================================

-- Q8: Find products whose descriptions do not contain 'BAG'.
-- Return stock_code and description.

SELECT stock_code, description
FROM retail.online_retail
WHERE description NOT LIKE '%BAG%';

```bash
  stock_code  |             description             
--------------+-------------------------------------
 85123A       | WHITE HANGING HEART T-LIGHT HOLDER
 71053        | WHITE METAL LANTERN
 84406B       | CREAM CUPID HEARTS COAT HANGER
```
-- Q9: Find products whose descriptions do not begin with 'WHITE'.
-- Return description.
SELECT description
FROM retail.online_retail
WHERE description NOT LIKE 'WHITE%';

```
             description             
-------------------------------------
 CREAM CUPID HEARTS COAT HANGER
 KNITTED UNION FLAG HOT WATER BOTTLE
 RED WOOLLY HOTTIE WHITE HEART.
 SET 7 BABUSHKA NESTING BOXES
```
-- Q10: Find products whose descriptions do not end with 'SET'.
-- Return description.

SELECT description 
FROM retail.online_retail
WHERE description NOT LIKE '%SET';
/*
             description             
-------------------------------------
 WHITE HANGING HEART T-LIGHT HOLDER
 WHITE METAL LANTERN
 CREAM CUPID HEARTS COAT HANGER
*/

-- ============================================
-- SECTION 4: IN
-- ============================================

-- Q11: Find all transactions from:
-- France, Germany, and Spain.
-- Return invoice_no and country.
SELECT invoice_no, country
FROM retail.online_retail
WHERE country IN ('France', 'Germany', 'Spain');
/*
 invoice_no | country 
------------+---------
 536370     | France
 536370     | France
 536370     | France
 536370     | France
 536370     | France
*/
-- Q12: Find all transactions from:
-- France, Germany, Spain, and Italy.
-- Return invoice_no, description, and country.
SELECT invoice_no, description, country
FROM retail.online_retail
WHERE country IN('France', 'Germany', 'Spain','Italy');
/*
 invoice_no |             description             | country 
------------+-------------------------------------+---------
 536370     | ALARM CLOCK BAKELIKE PINK           | France
 536370     | ALARM CLOCK BAKELIKE RED            | France
 536370     | ALARM CLOCK BAKELIKE GREEN          | France
 536370     | PANDA AND BUNNIES STICKER SHEET     | France
*/
-- Q13: Find all transactions involving these stock codes:
-- 85123A, 71053, 84406B, and 84029G.
-- Return stock_code and description.
SELECT stock_code, description
FROM retail.online_retail
WHERE stock_code IN ('85123A','71053', '84406B','84029G');
/*
 stock_code |             description             
------------+-------------------------------------
 85123A     | WHITE HANGING HEART T-LIGHT HOLDER
 71053      | WHITE METAL LANTERN
 84406B     | CREAM CUPID HEARTS COAT HANGER
 84029G     | KNITTED UNION FLAG HOT WATER BOTTLE
*/
-- ============================================
-- SECTION 5: NULL VALUES
-- ============================================

-- Q14: How many transactions have no CustomerID?
-- Return the result with a meaningful alias.
SELECT COUNT(*) AS none_CustomerID_transactions
FROM retail.online_retail
WHERE customer_id IS NULL;
/*
 none_customerid_transactions 
------------------------------
                       135080
*/
-- Q15: How many transactions have a CustomerID?
-- Return the result with a meaningful alias.
SELECT COUNT(*) AS CustomerID_transactions
FROM retail.online_retail
WHERE customer_id IS NOT NULL;
/*
 customerid_transactions 
-------------------------
                  406829
(1 row)
*/

-- Q16: How many transactions have no Description?

SELECT COUNT(*) AS none_description_transaction
FROM retail.online_retail
WHERE description IS NULL;
/*
 none_description_transaction 
------------------------------
                         1454
*/

-- Q17: How many transactions have both:
-- a missing CustomerID AND a missing Description?
SELECT COUNT(*) AS none_descr_c_id_transactions
FROM retail.online_retail
WHERE description IS NULL
    AND customer_id IS NULL;
/*
 none_descr_c_id_transactions 
------------------------------
                         1454
(1 row)

*/
-- Q18: Find transactions where CustomerID is missing
-- but Description is available.
-- Return invoice_no, description, and customer_id.
SELECT invoice_no, description, customer_id
FROM retail.online_retail
WHERE description IS NOT NULL 
    AND customer_id IS NULL;
/*
 invoice_no |             description             | customer_id 
------------+-------------------------------------+-------------
 536544     | TEA COSY RED  STRIPE                |            
 536876     | DAIRY MAID TOASTRACK                |            
 541424     | JUMBO STORAGE BAG SUKI              |            
 541424     | SKULL SHOULDER BAG                  | 
 */
-- ============================================
-- SECTION 6: COMBINING FILTERS
-- ============================================

-- Q19: Find products whose description contains 'BAG'
-- and were sold in France or Germany.
-- Return stock_code, description, and country.
SELECT stock_code, description, country
FROM retail.online_retail
WHERE country IN ('France','Germany')
    AND description LIKE '%BAG%';
/*
 stock_code |             description             | country 
------------+-------------------------------------+---------
 22661      | CHARLOTTE BAG DOLLY GIRL DESIGN     | France
 20712      | JUMBO BAG WOODLAND ANIMALS          | Germany
 20713      | JUMBO BAG OWLS                      | Germany
*/
-- Q20: Find transactions where:
-- Description contains 'SET'
-- AND Country is France, Germany, or Spain.
-- Return invoice_no, description, and country.

SELECT invoice_no, description, country
FROM retail.online_retail 
WHERE description LIKE '%SET%';
/*
 invoice_no |             description             |       country        
------------+-------------------------------------+----------------------
 536365     | SET 7 BABUSHKA NESTING BOXES        | United Kingdom
 536368     | JAM MAKING SET WITH JARS            | United Kingdom
 536370     | SET/2 RED RETROSPOT TEA TOWELS      | France
 536370     | ROUND SNACK BOXES SET OF4 WOODLAND  | France
*/
-- Q21: Find products whose description contains 'SET'
-- but does not contain 'BAG'.
-- Return stock_code and description.
SELECT stock_code, description
FROM retail.online_retail 
WHERE description NOT LIKE '%BAG%'
    AND description LIKE '%SET';
/*
 stock_code |             description             
------------+-------------------------------------
 84997B     | RED 3 PIECE RETROSPOT CUTLERY SET
 84997C     | BLUE 3 PIECE POLKADOT CUTLERY SET
 84519A     | TOMATO CHARLIE+LOLA COASTER SET
 84854      | GIRLY PINK TOOL SET
*/
-- Q22: Find transactions where:
-- Country is France, Germany, or Spain
-- AND Description contains 'BAG'
-- AND CustomerID is NOT NULL.
-- Return invoice_no, stock_code, description,
-- customer_id, and country.
SELECT invoice_no, stock_code, description
FROM retail.online_retail
WHERE country IN ('Germany','Spain', 'France')
    AND description LIKE '%BAG%'
    AND customer_id IS NOT NULL;
/*
 invoice_no | stock_code |             description             
------------+------------+-------------------------------------
 536370     | 22661      | CHARLOTTE BAG DOLLY GIRL DESIGN
 536527     | 20712      | JUMBO BAG WOODLAND ANIMALS
 536527     | 20713      | JUMBO BAG OWLS
 C536548    | 22333      | RETROSPOT PARTY BAG + STICKER SET
*/
-- ============================================
-- SECTION 7: COUNT(*) VS COUNT(column)
-- ============================================

-- Q23: Return the following in one query:
-- total_transactions
-- transactions_with_customer_id
-- transactions_without_customer_id


-- Q24: Return the following in one query:
-- total_transactions
-- transactions_with_description
-- transactions_without_description


-- ============================================
-- SECTION 8: FINAL BUSINESS QUESTIONS
-- ============================================

-- Q25: A retail analyst wants to investigate
-- bag-related products sold outside the United Kingdom.
-- Find transactions where:
-- Description contains 'BAG'
-- AND Country is NOT 'United Kingdom'.
-- Return invoice_no, description, and country.


-- Q26: Find transactions involving unknown customers
-- where the product description contains 'SET'.
-- Return invoice_no, description, and customer_id.


-- Q27: Find transactions from France, Germany, or Spain
-- where the description is available but does not contain 'BAG'.
-- Return invoice_no, description, and country.


-- Q28: Find transactions where the description:
-- starts with 'WHITE'
-- OR ends with 'SET'.
-- Return stock_code and description.


-- ============================================
-- END OF PRACTICE
-- ============================================