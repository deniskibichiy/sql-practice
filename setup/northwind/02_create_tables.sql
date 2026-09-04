CREATE TABLE northwind.customers (
    customer_id VARCHAR(50),
    company_name VARCHAR(50),
    contact_name VARCHAR(50),
    contact_title VARCHAR(50),
    address VARCHAR(50),
    city VARCHAR(50),
    region VARCHAR(50),
    postal_code VARCHAR(50),
    country VARCHAR(50),
    phone VARCHAR(50),
    fax VARCHAR(50)
);

CREATE TABLE northwind.orders (
    order_id INT PRIMARY KEY,
    customer_id VARCHAR(50),
    employee_id SMALLINT,
    order_date DATE,
    required_date DATE,
    shipped_date DATE,
    shipped_VIA SMALLINT,
    freight NUMERIC(10,2),
    ship_name VARCHAR(100),
    ship_address VARCHAR(255),
    ship_city VARCHAR(100),
    ship_region VARCHAR(100),
    ship_postal_code VARCHAR(20),
    ship_country VARCHAR(100)
);