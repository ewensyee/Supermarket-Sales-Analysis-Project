-- Supermarket Sales Analysis Project
CREATE DATABASE supermarketsales;

--Create TABLE
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATE NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

use supermarketsales;

select * from sales;

-- Which branch generates the highest profit
SELECT branch, SUM(gross_income) as income
FROM sales
GROUP BY branch
ORDER BY income DESC;

-- which product line was most popular in the males section
SELECT gender, product_line, SUM(quantity) as quantity
FROM sales
WHERE gender = "Male"
GROUP BY gender, product_line
ORDER BY quantity DESC
LIMIT 1;

-- which product line generates the highest revenue
SELECT product_line, SUM(total) AS total
FROM sales
GROUP BY product_line
ORDER BY product_line DESC;

-- what is the distribution of customers by gender? does one gender spend more?
SELECT gender, SUM(total) AS total
FROM sales
GROUP BY gender
ORDER BY total DESC;

-- If average quantity of each product_line is above 5.5 then it's good else bad
SELECT product_line, AVG(quantity),
CASE 
	WHEN AVG(quantity) > 5.5 THEN "Good"
	ELSE "Bad"
END AS cases
FROM sales
GROUP BY product_line;

-- Which branch sold more products than the average product sold?
SELECT branch, SUM(quantity) as quantity, AVG(quantity)
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT
	AVG(quantity)
	FROM sales);

-- do members spend more than normal customers on average?
SELECT customer_type, AVG(total) AS total
FROM sales
GROUP BY customer_type
ORDER BY total DESC;

-- which month have the highest sales?
SELECT MONTH(date) AS month, SUM(total) AS total
FROM sales
GROUP BY month
ORDER BY total DESC;

-- which branch received the highest/lowest average ratings?
SELECT branch, AVG(rating) as rating
FROM sales
GROUP BY branch
ORDER BY rating DESC;

-- how much transactions was done using credit card?
SELECT COUNT(payment) AS payment
FROM sales
WHERE payment = "Credit card";

-- which payment type was used the most?
SELECT payment, COUNT(payment) AS payment
FROM sales
GROUP BY payment
ORDER BY payment DESC;

-- which customer type pays the most tax?
SELECT customer_type, SUM(tax_pct) AS tax
FROM sales
GROUP BY customer_type
ORDER BY tax DESC;

SELECT 
    product_line,
    SUM(quantity) AS total_quantity,
    SUM(total) AS total_revenue,
    CASE 
        WHEN SUM(total) > (SELECT AVG(total)*2 FROM sales) THEN 'Top Performer'
        WHEN SUM(total) > (SELECT AVG(total) FROM sales) THEN 'Above Average'
        ELSE 'Below Average'
    END AS performance_category
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

SELECT 
    product_line,
    SUM(total) AS revenue
FROM sales
GROUP BY product_line
HAVING SUM(total) >= (
    SELECT SUM(total)
    FROM sales
    GROUP BY product_line
    ORDER BY SUM(total) DESC
    LIMIT 1 OFFSET 2  -- 3rd highest revenue
);

-- which city has the highest average tax percentage
SELECT city, AVG(tax_pct) as Avg_Tax
FROM sales
GROUP BY city
ORDER BY Avg_tax DESC;
