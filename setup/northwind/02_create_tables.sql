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

CREATE TABLE northwind.regions(
    region_id SMALLINT PRIMARY KEY,
    region_description VARCHAR(50)
);

CREATE TABLE northwind.suppliers(
    supplier_id SMALLINT PRIMARY KEY,
    company_name VARCHAR(50),
    contact_name VARCHAR(50),
    contact_title VARCHAR(50),
    supplier_address VARCHAR(50),
    city VARCHAR(50),
    region VARCHAR(50),
    postal_code VARCHAR(50),
    country VARCHAR(50),
    phone VARCHAR(50),
    fax VARCHAR(50),
    homepage VARCHAR(100)
);

CREATE TABLE northwind.products(
    product_id SMALLINT PRIMARY KEY,
    product_name VARCHAR(50),
    supplier_id SMALLINT,
    category_id SMALLINT, 
    quantity_per_unit VARCHAR(50),
    unit_price NUMERIC,
    units_in_stock NUMERIC,
    units_on_order NUMERIC,
    reorder_level NUMERIC,
    discontinued SMALLINT
);

CREATE TABLE northwind.employee_territories (
    employee_id SMALLINT,
    territory_id VARCHAR(50)
); 

CREATE TABLE northwind.categories(
    category_id SMALLINT,
    category_name VARCHAR(50),
    description VARCHAR(100)
);

CREATE TABLE northwind.order_details(
    order_id SMALLINT,
    product_id SMALLINT,
    unit_price NUMERIC,
    quantity NUMERIC,
    discount SMALLINT
);

CREATE TABLE northwind.territories(
    territory_id SMALLINT,
    territory_description VARCHAR(50),
    region_id SMALLINT
);

CREATE TABLE northwind.shippers(
    shipper_id SMALLINT,
    company_name VARCHAR(50),
    phone VARCHAR(20)
);

CREATE TABLE northwind.employees (
    employee_id SMALLINT,
    last_name VARCHAR(30),
    first_name VARCHAR(30),
    title VARCHAR(30),
    address VARCHAR(50),
    city VARCHAR(30),
    region VARCHAR(30),
    country VARCHAR(30)
);