-- ============================================================
-- Sales Performance Dashboard — SQL Analysis
-- Dataset: Superstore Sales (~9,800 records)
-- ============================================================

-- ------------------------------------------------------------
-- 1. Setup: Create database and enable local file loading
-- ------------------------------------------------------------
CREATE DATABASE sales_project;
USE sales_project;

SET GLOBAL local_infile = 1;
SELECT @@local_infile;  -- should return 1

-- ------------------------------------------------------------
-- 2. Create table matching the Superstore dataset schema
-- ------------------------------------------------------------
CREATE TABLE orders (
    row_id INT,
    order_id VARCHAR(20),
    order_date VARCHAR(20),
    ship_date VARCHAR(20),
    ship_mode VARCHAR(50),
    customer_id VARCHAR(20),
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    country VARCHAR(50),
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code VARCHAR(20),
    region VARCHAR(50),
    product_id VARCHAR(50),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(255),
    sales DECIMAL(10,2)
);

-- ------------------------------------------------------------
-- 3. Load CSV data into the table
-- Note: update the file path to match your local file location
-- ------------------------------------------------------------
LOAD DATA LOCAL INFILE 'train_clean.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- Verify the load
SELECT COUNT(*) FROM orders;
SELECT * FROM orders LIMIT 10;
DESCRIBE orders;

-- ------------------------------------------------------------
-- 4. Fix date format (source data is DD-MM-YYYY as text)
-- ------------------------------------------------------------
ALTER TABLE orders ADD COLUMN order_date_fixed DATE;
UPDATE orders SET order_date_fixed = STR_TO_DATE(order_date, '%d-%m-%Y');

-- ============================================================
-- ANALYSIS QUERIES
-- ============================================================

-- 1) Total revenue by region
SELECT region, SUM(sales) AS total_sales
FROM orders
GROUP BY region
ORDER BY total_sales DESC;

-- 2) Top 10 products by sales
SELECT product_name, SUM(sales) AS total_sales
FROM orders
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 10;

-- 3) Sales by category and sub-category
SELECT category, sub_category, SUM(sales) AS total_sales
FROM orders
GROUP BY category, sub_category
ORDER BY category, total_sales DESC;

-- 4) Monthly sales trend
SELECT DATE_FORMAT(order_date_fixed, '%Y-%m') AS month, SUM(sales) AS monthly_sales
FROM orders
GROUP BY month
ORDER BY month;

-- 5) Top 10 customers by revenue
SELECT customer_name, SUM(sales) AS total_sales
FROM orders
GROUP BY customer_name
ORDER BY total_sales DESC
LIMIT 10;
