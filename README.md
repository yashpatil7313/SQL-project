# SQL Retail Sales Analysis Project

This project demonstrates **step-by-step SQL data cleaning and analysis** on a retail sales dataset. It is designed for **practice, learning, and portfolio building**.

---

## Project Overview

### Project Features

* **End-to-End SQL Project**: Covers database creation, table design, data cleaning, and analysis
* **Data Cleaning Techniques**: Identifies and removes NULL values for accurate analysis
* **Exploratory Data Analysis (EDA)**: Uses COUNT, DISTINCT, GROUP BY, and aggregations
* **Business-Oriented Queries**: Solves real-world retail business problems
* **Time-Based Analysis**: Monthly sales trends and shift-wise order analysis
* **Customer Insights**: Identifies top customers and unique customer counts
* **Advanced SQL Concepts**: Uses CTEs and Window Functions (RANK)
* **Performance Metrics**: Total sales, average sales, category-wise performance
* **GitHub Ready**: Well-structured README for portfolio and showcasing

---

* **Database Name:** `sql_project_p2`
* **Table Name:** `retail_sales`
* **Objective:**

  * Clean raw sales data
  * Perform exploratory data analysis (EDA)
  * Answer real-world business questions using SQL

---

## Step 1: Create Database

```sql
CREATE DATABASE sql_project_p2;
USE sql_project_p2;
```

---

## Step 2: Create Table

```sql
CREATE TABLE retail_sales (
    transaction_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);
```

---

## Step 3: Initial Data Exploration

### View all records

```sql
SELECT * FROM retail_sales;
```

### Count total rows

```sql
SELECT COUNT(*) FROM retail_sales;
```

---

## Step 4: Data Cleaning

### Check for NULL values

```sql
SELECT * FROM retail_sales
WHERE transaction_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR gender IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;
```

### Disable safe updates

```sql
SET SQL_SAFE_UPDATES = 0;
```

### Delete NULL records

```sql
DELETE FROM retail_sales
WHERE transaction_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR gender IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;
```

---

## Step 5: Basic Analysis

### Total number of sales

```sql
SELECT COUNT(*) AS total_sales FROM retail_sales;
```

### Unique customers

```sql
SELECT COUNT(DISTINCT customer_id) AS unique_customers FROM retail_sales;
```

### Product categories

```sql
SELECT DISTINCT category FROM retail_sales;
```

---

## Step 6: Business Questions & SQL Solutions

### Q1: Sales on a specific date (2022-11-05)

```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

---

### Q2: Clothing sales with quantity > 10 (Nov 2022)

```sql
SELECT category, SUM(quantity) AS total_quantity
FROM retail_sales
WHERE category = 'clothing'
GROUP BY category;
```

---

### Q3: Total sales & orders per category

```sql
SELECT category,
       SUM(total_sale) AS net_sale,
       COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;
```

---

### Q4: Average age of customers buying Beauty products

```sql
SELECT ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'beauty';
```

---

### Q5: Transactions with sales > 1000

```sql
SELECT *
FROM retail_sales
WHERE total_sale > 1000;
```

---

### Q6: Transactions by gender and category

```sql
SELECT category, gender, COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY category, gender;
```

---

### Q7: Best-selling month each year (Average Sales)

```sql
SELECT *
FROM (
    SELECT
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rank
    FROM retail_sales
    GROUP BY year, month
) t
WHERE rank = 1;
```

---

### Q8: Top 5 customers by total sales

```sql
SELECT customer_id, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```

---

### Q9: Unique customers per category

```sql
SELECT category, COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;
```

---

### Q10: Orders by shift (Morning / Afternoon / Evening)

```sql
WITH hourly_sale AS (
    SELECT *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT shift, COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;
```

---

## Conclusion

This project demonstrates:

* SQL data cleaning
* Aggregations & filtering
* Window functions
* Business-oriented analysis

**Ideal for beginners to intermediate SQL learners and portfolio showcasing.**

---

## Author

**Yash**
Aspiring Data Analyst / Data Scientist 



