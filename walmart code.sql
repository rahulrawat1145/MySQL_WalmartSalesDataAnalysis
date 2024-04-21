-- --------------------------------------------------STEP I - Creating a Database --------------------------------------------------------

CREATE DATABASE IF NOT EXISTS SalesDataWalmart;				

-- Creating a table named "sales" and adding coloumns with seperate datatypes 		
													
CREATE TABLE IF NOT EXISTS sales(
invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
branch VARCHAR(5) NOT NULL,
city VARCHAR(30) NOT NULL,
customer_type VARCHAR(30) NOT NULL,
gender VARCHAR(10) NOT NULL, 
product_line VARCHAR(100) NOT NULL,
unit_price DECIMAL(10, 2) NOT NULL,
quantity INT NOT NULL,
VAT	FLOAT NOT NULL,
total DECIMAL(12, 4) NOT NULL,
date DATE NOT NULL,
time TIME NOT NULL,
payment_method VARCHAR(15) NOT NULL,
cogs DECIMAL(10, 2) NOT NULL,
gross_margin_pct FLOAT,
gross_income DECIMAL(12, 4) NOT NULL,
rating FLOAT NOT NULL
);

-- Now populating the table "Sales" with the values from the WalmartSalesData.csv file using "import records from external files.
-- sales table is now populated with entries from the .csv file.

-- --------------------------------------------------STEP II - Adding new columns --------------------------------------------------------

-- Adding a "time_of_day" column, depending on the time of the day.

SELECT 
	time,
    (CASE
		WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
	END
	) AS time_of_day
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (
	CASE
		WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
		WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
		ELSE "Evening"
	END
);

-- Adding a "day_name" column reflecting the day when the transaction occured.

SELECT 
	date,
    DAYNAME(date) AS day_name
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);
UPDATE sales 
SET 
    day_name = DAYNAME(date);

-- Adding a "month_name" column reflecting the month when the transaction occured.

SELECT 
	date,
	MONTHNAME(date) as month_name
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR (10);
UPDATE sales
SET month_name = MONTHNAME(date);

-- --------------------------------------------------STEP III - Answering the Business Questions --------------------------------------------------------

-- Q1) How many unique cities does the data have?

SELECT
	DISTINCT city 
FROM sales;

-- Q2) There are three branches A,B and C. Which city has what type of branches?

SELECT
	DISTINCT city,
    branch
FROM sales;

-- Q3) How many unique product lines does the data have?

SELECT COUNT(DISTINCT product_line)
FROM sales;

-- Q4) What is the most common payment method?

SELECT * FROM sales;

SELECT 
	payment_method,
	COUNT(payment_method) AS count
FROM sales
GROUP BY payment_method
ORDER BY count DESC;

-- Q5) What is the most selling product line?

SELECT
	product_line,
    COUNT(product_line) AS count
FROM sales
GROUP BY product_line
ORDER BY count DESC;

-- Q6) What is the total revenue by month?

SELECT
	month_name AS month,
    SUM(total) AS total_revenue
FROM sales
GROUP BY month
ORDER BY total_revenue DESC;

-- Q7) What month had the largest COGS?

SELECT
	month_name AS month,
    SUM(cogs) AS cogs
FROM sales
GROUP BY month
ORDER BY cogs DESC;
    
-- Q8) What product line had the largest revenue?  
        
SELECT 
	product_line,
    SUM(total) as revenue
FROM sales
GROUP BY product_line
ORDER BY revenue DESC;

-- Q9) What is the city with the largest revenue?

SELECT 
	branch,
	city,
    SUM(total) as revenue
FROM sales
GROUP BY city, branch
ORDER BY revenue DESC;
    
-- Q10) What product line had the largest VAT?

SELECT 
	product_line,
    AVG(VAT) AS avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;

-- Q11) What are the total sales in each product line?    
 
 SELECT 
	product_line,
    SUM(total) as total_sales
    FROM sales
GROUP BY product_line
ORDER BY total_sales;

-- Q12) Which branch sold more products than average product sold?

SELECT 
	branch,
    SUM(quantity) as qty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);

-- Q13) What is the most common product line by gender?

SELECT 
	gender,
	product_line,
    COUNT(gender) AS total_count
FROM sales
GROUP BY gender, product_line
ORDER BY total_count DESC;

-- Q14) What is the average rating of each product line?

SELECT 
	product_line,
    ROUND(AVG(rating),2) as avg_rating
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;

-- Q15) Number of sales made in each time of the day per weekday?

SELECT 
	time_of_day,
    COUNT(*) AS total_sales
FROM sales
WHERE day_name = "Monday"
GROUP BY time_of_day
ORDER BY total_sales DESC;

-- Q16) Which of the customer types brings the most revenue?

SELECT 
	customer_type,
    SUM(total) AS revenue
FROM sales
GROUP BY customer_type
ORDER BY revenue DESC;

-- Q17) Which city has the largest tax percent/ VAT (Value Added Tax)?

SELECT 
	city,
    AVG(VAT) AS VAT
FROM sales
GROUP BY city
ORDER BY VAT DESC;

-- Q18) Which customer type pays the most in VAT?

SELECT
	customer_type,
    AVG(VAT) AS VAT_max
FROM sales
GROUP BY customer_type
ORDER BY VAT_max DESC;

-- Q19) How many unique customer types does the data have?

SELECT 
	DISTINCT(customer_type)
FROM sales;

-- Q20) How many unique payment methods does the data have?

SELECT 
	DISTINCT(payment_method)
FROM sales;

-- Q21) What is the most common customer type in terms of quantity?

SELECT 
	customer_type,
    SUM(quantity) AS qty
FROM sales
GROUP BY customer_type
ORDER BY qty DESC;

-- Q22) Which customer type buys the most ?

SELECT 
    customer_type, COUNT(*) AS customer_count
FROM
    sales
GROUP BY customer_type;

-- Q23) What is the gender of most of the customers?

SELECT 
	gender,
    COUNT(*) as gender_count
FROM sales
GROUP BY gender
ORDER BY gender_count DESC;

-- Q24) What is the gender distribution per branch?

SELECT 
	gender,
    COUNT(*) as gender_count
FROM sales
WHERE branch = "C"
GROUP BY gender
ORDER BY gender_count DESC;

-- Q25) Which time of the day do customers give most ratings?

SELECT
	time_of_day,
	AVG(rating) as rating
FROM sales
GROUP BY time_of_day
ORDER BY rating DESC;

-- Q26) Which time of the day do customers give most ratings per branch?

SELECT
	branch,
	time_of_day,
	AVG(rating) as rating
FROM sales
WHERE branch= "C"
GROUP BY time_of_day
ORDER BY rating DESC;

-- Q27) Which day of the week has the best avg ratings?

SELECT
	day_name,
    AVG(rating) as avg_rating
FROM sales
GROUP BY day_name
ORDER BY avg_rating DESC;

-- Q28) Which day of the week has the best average ratings per branch?

SELECT
	branch,
	day_name,
    AVG(rating) as avg_rating
FROM sales
WHERE branch = "A"
GROUP BY day_name
ORDER BY avg_rating DESC;





