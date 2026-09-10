/*
INNER JOIN — Match orders with customers

Display each order together with the customer's company name and contact name.

Required columns:

order_id
customer_id
company_name
contact_name
order_date
freight
*/
SELECT o.order_id, c.customer_id, c.company_name, c.contact_name, o.order_date, o.freight
FROM northwind.orders as o 
INNER JOIN northwind.customers as c 
USING(customer_id)
LIMIT 10;

/*
INNER JOIN — Customer shipping comparison
Show each order and compare the customer's registered country with the country where the order was shipped.

Required columns:

order_id
company_name
customer_country
ship_country

Only return orders where the two countries are different.
*/

SELECT order_id, customer_id, company_name, contact_name, order_date, freight 
FROM northwind.orders
INNER JOIN northwind.customers
USING (customer_id)
LIMIT 10;

/*

LEFT JOIN — Find customers without orders

Return all customers, including those who have never placed an order.

Required columns:

customer_id
company_name
order_id

Identify which customers have no matching order.
*/

SELECT c.customer_id, c.company_name, o.order_id
FROM northwind.customers AS c
INNER JOIN northwind.orders AS O
ON c.customer_id = o.customer_id
LIMIT 20;

/*

INNER JOIN + Filtering

Find all orders placed by customers from Germany.

Required columns:

order_id
company_name
contact_name
customer_country
order_date
freighT */

SELECT o.order_id, c.company_name, c.contact_name, c.country, o.order_date, o.freight 
FROM northwind.orders AS o
INNER JOIN northwind.customers AS c
ON o.customer_id = c.customer_id
LIMIT 20;

/*
JOIN + GROUP BY — Customer order summary

For every customer who has placed at least one order, calculate:

customer_id
company_name
total_orders
total_freight
average_freight

Order the results by total_orders from highest to lowest.
*/

SELECT c.customer_id, COUNT(o.order_id) AS total_orders, SUM(o.freighT) AS total_freight, AVG(o.freight) AS average_freight
FROM northwind.orders AS o
INNER JOIN northwind.customers as c 
ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY total_orders DESC 
LIMIT 20;

SELECT COUNT(customer_id) AS customers_per_region, region
FROM northwind.customers
GROUP BY region


sql_practice-> ON c.region
