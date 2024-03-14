-- Create a schema for the Project 2 Session 17
CREATE schema if not EXISTS project2;

-- Create a dimension table for customers
CREATE TABLE project2.customer_dimension (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    phone_number VARCHAR(20)
);

-- Create a dimension table for products
CREATE TABLE project2.product_dimension (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price NUMERIC(10, 2)
);

-- Create a time dimension table

CREATE TABLE project2.time_dimension (
    date_id SERIAL PRIMARY KEY,
    day_of_week VARCHAR(10),
    month VARCHAR(10),
    quarter VARCHAR(10),
    year INT
);

-- Create a fact table for sales

CREATE TABLE project2.sales_fact (
    sale_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES project2.customer_dimension(customer_id),
    product_id INT REFERENCES project2.product_dimension(product_id),
    date_id INT REFERENCES project2.time_dimension(date_id),
    quantity INT,
    revenue NUMERIC(12, 2)
);

-- Create indexes for better query performance
CREATE INDEX idx_sales_customer ON project2.sales_fact(customer_id);
CREATE INDEX idx_sales_product ON project2.sales_fact(product_id);
CREATE INDEX idx_sales_date ON project2.sales_fact(date_id);


-- Insert data into customer_dimension
INSERT INTO project2.customer_dimension (customer_name, email, phone_number)
SELECT
    'Customer ' || generate_series(1, 100),
    'customer' || generate_series(1, 100) || '@example.com',
    '+1234567890' || generate_series(1, 100)
FROM generate_series(1, 100);

-- Insert data into product_dimension
INSERT INTO project2.product_dimension (product_name, category, price)
SELECT
    'Product ' || generate_series(1, 100),
    'Category ' || (generate_series(1, 100) % 5 + 1),  -- Assuming 5 categories
    random() * 100
FROM generate_series(1, 100);

-- Insert data into time_dimension
INSERT INTO project2.time_dimension (day_of_week, month, quarter, year)
SELECT
    to_char(CURRENT_DATE - generate_series(1, 100), 'Dy'),
    to_char(CURRENT_DATE - generate_series(1, 100), 'Mon'),
    to_char(CURRENT_DATE - generate_series(1, 100), 'Q'),
    EXTRACT(YEAR FROM CURRENT_DATE - generate_series(1, 100))
FROM generate_series(1, 100);

-- Insert data into sales_fact
INSERT INTO project2.sales_fact (customer_id, product_id, date_id, quantity, revenue)
SELECT
    (random() * 100 + 1)::int,
    (random() * 100 + 1)::int,
    (random() * 100 + 1)::int,
    (random() * 10 + 1)::int,
    (random() * 1000)::numeric(12, 2)
FROM generate_series(1, 100);


-- CHECK TABLES 
select * from project2.customer_dimension;

select * from project2.product_dimension;

select * from project2.time_dimension;

select * from project2.sales_fact order by date_id asc;

-- BUSINESS QUESTION
select 
	SUM(quantity * revenue) as total_revenue
from project2.sales_fact as sf
left join project2.time_dimension as td on sf.date_id = td.date_id 
where td.month = 'Jan' and td.year = 2024;
