/*Part I — Core joins
1. Customer order history

Return every customer who has placed an order.

Display:

customer_id
company_name
order_id
order_date
ship_country

Do not include customers without orders.
*/
SELECT c.customer_id, c.company_name, o.order_id, o.order_date, o.ship_country
FROM northwind.customers as c 
INNER JOIN northwind.orders as o 
ON c.customer_id = o.customer_id;
/*
2. Employees and their customers

Display every employee who has processed at least one order.

Return:

employee_id
employee_name
customer_count

customer_count must count distinct customers.
*/
SELECT e.employee_id,  e.first_name, COUNT(DISTINCT o.customer_id) AS customer_counT
FROM northwind.orders AS o 
INNER JOIN northwind.employees AS e
USING (employee_id)
GROUP BY e.employee_id, e.first_name
ORDER BY customer_count DESC;
/*
3. Products and suppliers

Return every product together with:

product_name
category_name
supplier_name
supplier_country

Sort by category and then product name.
*/

SELECT p.product_name, p.category_name, s.supplier_name, s.supplier_country
FROM northwind.products AS p 
INNER JOIN northwind.suppliers AS s
ON p.supplier_id = s.supplier_id
ORDER BY c.category_name, s.product_name;

/*
4. Complete order analysis

For every order, display:

order_id
customer_name
employee_name
shipper_name
order_date
freight

This should require at least three joins.
*/
SELECT o.order_id, c.contact_name AS customer_name, CONCAT(e.first_name,' ', e.last_name) AS employee_name, s.company_name AS shipper_name, o.order_date, o.freight
FROM northwind.orders as o 
INNER JOIN northwind.employees as e 
USING(employee_id)
INNER JOIN northwind.customers as c 
USING (customer_id)
INNER JOIN northwind.shippers as s 
ON o.shipped_VIA = s.shipper_id
LIMIT 20;

/*
Part II — Joins + aggregation
5. Customer spending

Calculate the total amount spent by every customer.

Use order_details and calculate:

quantity × unit_price × (1 - discount)

Return:

customer_id
company_name
total_spending

Sort from highest to lowest.
*/

SELECT o.customer_id, c.company_name, c.contact_name, SUM(od.quantity * od.unit_price * (1 - od.discount)) AS total_spending
FROM northwind.orders as o 
INNER JOIN northwind.customers AS c
USING(customer_id)
INNER JOIN northwind.order_details AS od
USING(order_id)
GROUP BY o.customer_id, c.company_name, c.contact_name
ORDER BY total_spending DESC;

/*
6. Employee revenue

Determine how much revenue each employee has generated.

Return:

employee_id
employee_name
number_of_orders
total_revenue
average_order_value

Only include employees whose total revenue exceeds 10,000.
*/
SELECT e.employee_id, CONCAT(e.first_name, ' ',e.last_name) AS employee_name, COUNT(*) AS number_of_orders, SUM((od.quantity * od.unit_price * (1 - od.discount))) AS total_revenue, AVG((od.quantity * od.unit_price * (1 - od.discount))) AS average_order_value
FROM northwind.employees AS e 
INNER JOIN northwind.orders as o 
USING(employee_id)
INNER JOIN northwind.order_details as od 
USING (order_id)
GROUP BY e.employee_id, CONCAT(e.first_name, ' ',e.last_name)
HAVING AVG((od.quantity * od.unit_price * (1 - od.discount))) > 100
ORDER BY total_revenue DESC;


/*
7. Category performance

For each product category, calculate:

category_name
products_sold
units_sold
total_revenue

Order by revenue descending.
 */
 
 /*
Part III — Subqueries

Now stop thinking immediately about joins. These questions are specifically designed to make you consider whether a subquery is appropriate.
*/

/*
8. Above-average freight

Find all orders whose freight is greater than the average freight across all orders.

Return:

order_id
customer_id
freight

You should obtain the average using a subquery.
*/

/*
9. Customers above average

Find customers whose total spending is greater than the average customer spending.

Return:

customer_id
company_name
total_spending

This will require aggregation plus a subquery.
*/

/*
10. Most expensive products

Find products whose unit price is greater than the average unit price of all products.

Return:

product_id
product_name
unit_price

Sort from highest price to lowest.
*/

/*
11. Employees above average

Find employees whose number of orders is greater than the average number of orders per employee.

Return:

employee_id
employee_name
order_count

Be careful about how you calculate the average.
*/

/*
Part IV — Set operations

Now deliberately use set theory
12. Customers who shipped to different countries

Produce two sets:

Customers whose registered country is Germany.
Customers whose orders were shipped to Germany.

Use a set operation to determine which customer IDs appear in both sets.*/


/*
13. Countries represented in both datasets

Return country names that appear in both:

customers.country
suppliers.country

Use INTERSECT.

Your result should contain one column:

country
*/
/*
14. Countries with customers but no suppliers

Find countries that appear among customers but not among suppliers.

Use EXCEPT.

Return:

country
*/

/*
15. Combine employee and customer countries

Create a result containing countries represented by either:

customers, or
suppliers.

Duplicates should appear only once.

Use UNION.
*/

/*

Part V — Anti-joins and existence

These are particularly important because they force you to understand the difference between JOIN, NOT EXISTS, and set operations.

16. Customers who never ordered

Find all customers who have never placed an order.

Solve it twice:

A. Using LEFT JOIN

B. Using NOT EXISTS

Return:

customer_id
company_name
country

Compare the two queries.
*/

/*

17. Products never ordered

Find products that have never appeared in order_details.

Return:

product_id
product_name
unit_price

Solve it using NOT EXISTS.
*/

/*

18. Suppliers with no products

Find suppliers who have no products associated with them.

Return:

supplier_id
company_name
country

Use either NOT EXISTS or an appropriate outer join.
*/

/*
Part VI — Complex relational reasoning
19. Customers buying above-average products

Find customers who have purchased at least one product whose unit price is greater than the average product price.

Return distinct:

customer_id
company_name

You will need to traverse something like:

customers
    ↓
orders
    ↓
order_details
    ↓
products

and compare product prices against an aggregate obtained separately.
*/

/*
20. Customers who bought from every category

Find customers who have purchased products from every product category in the database.

Return:

customer_id
company_name

This is intentionally difficult. Think carefully about:

number of categories purchased by customer
        VS
total number of categories

A combination of joins, COUNT(DISTINCT ...), and a subquery is appropriate.
*/

/*
21. Employee with the highest revenue

Determine the employee who generated the highest total revenue.

Return:

employee_id
employee_name
total_revenue

Do not simply use ORDER BY ... LIMIT 1 on the raw orders. First determine revenue per employee, then identify the maximum.

Try solving it using a subquery.
*/

/*
22. Products more expensive than their category average

For every product, determine whether its unit price is greater than the average price of products within its own category.

Return only products satisfying the condition:

product_name
category_name
unit_price
category_average_price

This is a good test of correlated subqueries or an equivalent join-based solution.
*/

/*
Part VII — Final challenge
23. The Northwind "elite customers"

Identify customers who satisfy all three conditions:

Their total spending is above the average customer spending.
They have placed more orders than the average number of orders per customer.
They have purchased products from at least three different categories.

Return:

customer_id
company_name
order_count
total_spending
category_count

Sort by total spending descending.

You will probably need:

JOINs
+
GROUP BY
+
COUNT(DISTINCT)
+
subqueries
*/

/*
Final challenge: choose the technique

For each of the following, solve the problem using the technique that you think is most appropriate.

24. Same result, different technique

Find customers who have placed at least one order.

Solve this using:

A. INNER JOIN
B. EXISTS
C. IN with a subquery

Then compare the three queries.
*/

/*

25. Same result, set theory

Find customer countries that are also supplier countries.

Solve it using:

A. INTERSECT
B. INNER JOIN

Explain why both can produce the same conceptual result even though they operate differently.
*/

/*
26. Final relational problem

Find all customers who:

have placed an order;
have purchased at least one product from the Beverages category;
have total spending above the average spending of all customers;
have never purchased a product supplied by a supplier from the USA.

Return:

customer_id
company_name
country
total_spending
*/

/*
This is the capstone. Do not start writing SQL immediately. First break the problem into smaller result sets:

Set 1 → customers with orders
Set 2 → customers who bought Beverages
Set 3 → customers above average spending
Set 4 → customers who bought from US suppliers

Final result
    ↓
Set 1
∩ Set 2
∩ Set 3
− Set 4

You can then decide whether implementing those sets literally with INTERSECT/EXCEPT is cleaner than using JOIN/EXISTS/subqueries.
*/