CREATE DATABASE penjualan;
CREATE SCHEMA global;

CREATE TABLE global.customer (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    phone_number VARCHAR(20)
);

CREATE TABLE global.product (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price NUMERIC(10, 2)
);

CREATE TABLE global.time (
    date_id SERIAL PRIMARY KEY,
    day_of_week VARCHAR(10),
    month VARCHAR(10),
    quarter VARCHAR(10),
    year INT
);

CREATE TABLE global.sales (
    sale_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES global.customer(customer_id),
    product_id INT REFERENCES global.product(product_id),
    date_id INT REFERENCES global.time(date_id),
    quantity INT,
    revenue NUMERIC(12, 2)
);


CREATE INDEX idx_sales_customer ON global.sales(customer_id);
CREATE INDEX idx_sales_product ON global.sales(product_id);
CREATE INDEX idx_sales_date ON global.sales(date_id);



-- Insert data into customer
INSERT INTO global.customer (customer_name, email, phone_number)
SELECT
    'Customer ' || generate_series(1, 100),
    'customer' || generate_series(1, 100) || '@example.com',
    '+1234567890' || generate_series(1, 100)
FROM generate_series(1, 100);

-- Insert data into product
INSERT INTO global.product (product_name, category, price)
SELECT
    'Product ' || generate_series(1, 100),
    'Category ' || (generate_series(1, 100) % 5 + 1),  -- Assuming 5 categories
    random() * 100
FROM generate_series(1, 100);

-- Insert data into time
INSERT INTO global.time (day_of_week, month, quarter, year)
SELECT
    to_char(CURRENT_DATE - generate_series(1, 100), 'Dy'),
    to_char(CURRENT_DATE - generate_series(1, 100), 'Mon'),
    to_char(CURRENT_DATE - generate_series(1, 100), 'Q'),
    EXTRACT(YEAR FROM CURRENT_DATE - generate_series(1, 100))
FROM generate_series(1, 100);

-- Insert data into sales
INSERT INTO global.sales (customer_id, product_id, date_id, quantity, revenue)
SELECT
    (random() * 100 + 1)::int,
    (random() * 100 + 1)::int,
    (random() * 100 + 1)::int,
    (random() * 10 + 1)::int,
    (random() * 1000)::numeric(12, 2)
FROM generate_series(1, 100);
