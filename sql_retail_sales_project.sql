-- =====================================================
-- PROJECT: Retail Sales Analysis using SQL
-- DATABASE: sql_project_p2
-- PURPOSE: Data Cleaning and Business Analysis
-- =====================================================

-- Step 1: Create a new database
CREATE DATABASE sql_project_p2;

-- Step 2: Use the created database
USE sql_project_p2;

-- =====================================================
-- Step 3: Create the retail_sales table
-- This table stores transaction-level retail sales data
-- =====================================================
CREATE TABLE retail_sales (
    transaction_id INT PRIMARY KEY,      -- Unique transaction ID
    sale_date DATE,                       -- Date of sale
    sale_time TIME,                       -- Time of sale
    customer_id INT,                      -- Unique customer ID
    gender VARCHAR(15),                   -- Gender of customer
    age INT,                              -- Age of customer
    category VARCHAR(15),                 -- Product category
    quantity INT,                         -- Quantity sold
    price_per_unit FLOAT,                 -- Price per unit
    cogs FLOAT,                           -- Cost of goods sold
    total_sale FLOAT                      -- Total sale value
);

-- =====================================================
-- Step 4: Initial Data Exploration
-- =====================================================

-- View all records in the table
SELECT * FROM retail_sales;

-- Count total number of records
SELECT COUNT(*) FROM retail_sales;

-- =====================================================
-- Step 5: Data Cleaning
-- Check for records containing NULL values
-- =====================================================
SELECT * FROM retail_sales
WHERE transaction_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR gender IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

-- Disable safe updates to allow DELETE operation
SET SQL_SAFE_UPDATES = 0;

-- Delete records with NULL values
DELETE FROM retail_sales
WHERE transaction_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR gender IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

-- =====================================================
-- Step 6: Basic Analysis
-- =====================================================

-- Total number of sales transactions
SELECT COUNT(*) AS total_sales FROM retail_sales;

-- Total number of unique customers
SELECT COUNT(DISTINCT customer_id) AS unique_customers FROM retail_sales;

-- List of unique product categories
SELECT DISTINCT category FROM retail_sales;

-- =====================================================
-- Step 7: Business Questions and Analysis
-- =====================================================

-- Q1: Retrieve all sales made on a specific date (2022-11-05)
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- -----------------------------------------------------

-- Q2: Total quantity sold for Clothing category
SELECT 
    category,
    SUM(quantity) AS total_quantity
FROM retail_sales
WHERE category = 'clothing'
GROUP BY category;

-- -----------------------------------------------------

-- Q3: Total sales and total orders for each category
SELECT
    category,
    SUM(total_sale) AS net_sale,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;

-- -----------------------------------------------------

-- Q4: Average age of customers who purchased Beauty products
SELECT
    ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'beauty';

-- -----------------------------------------------------

-- Q5: Transactions where total sales value is greater than 1000
SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- -----------------------------------------------------

-- Q6: Number of transactions by gender in each category
SELECT 
    category,
    gender,
    COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY category, gender;

-- -----------------------------------------------------

-- Q7: Best-selling month (based on average sales) for each year
SELECT *
FROM (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rank_value
    FROM retail_sales
    GROUP BY year, month
) AS ranked_months
WHERE rank_value = 1;

-- -----------------------------------------------------

-- Q8: Top 5 customers based on highest total sales
SELECT 
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- -----------------------------------------------------

-- Q9: Number of unique customers in each category
SELECT 
    category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;

-- -----------------------------------------------------

-- Q10: Number of orders by shift (Morning, Afternoon, Evening)
WITH hourly_sale AS (
    SELECT *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;

-- =====================================================
-- End of Retail Sales SQL Project
-- =====================================================






