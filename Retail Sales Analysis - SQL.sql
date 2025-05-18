-- SQL RETAIL SALES ANALYSIS --

CREATE DATABASE SQL_PROJECT_P1;


-- CREATING TABLE --

CREATE TABLE retail_sales(
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(15),
	quantiy INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
)

SELECT * FROM retail_sales;


-- DATA OVERVIEW --

SELECT * FROM retail_sales
LIMIT 10;

SELECT COUNT(*) FROM retail_sales;


SELECT * FROM retail_sales WHERE transactions_id IS NULL;

SELECT * FROM retail_sales WHERE sale_date IS NULL;


DELETE FROM retail_sales
where transactions_id is null
or
sale_date is null
or
sale_time is null
or
gender is null
or
category is null
or
quantiy is null
or
cogs is null
or
total_sale is null;


-- DATA EXPLORATION --


-- How many sales we have? --

SELECT COUNT(*) FROM retail_sales;


-- How many unique customers we have? --

SELECT COUNT(DISTINCT customer_id) as total_sales FROM retail_sales;

SELECT DISTINCT category as Total_Category FROM retail_sales;



-- Data Analysis --


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

SELECT * FROM retail_sales
WHERE category = 'Clothing' 
AND quantiy > 3
AND sale_date BETWEEN '2022-11-01' and '2022-11-30';


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT category,
SUM(total_sale) as Net_Sale,
count(*) as total_orders
FROM retail_sales
GROUP BY 1;


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT round(AVG(age),2) as Average_Age FROM retail_sales
WHERE category = 'Beauty'


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM retail_sales
WHERE total_sale > 1000;


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT 
category,
gender,
COUNT(transactions_id) as Total_Transactions
FROM retail_sales
GROUP
BY
	category,
	gender
ORDER BY 1


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT 
	year,
	month,
	avg_sale
FROM 
(
SELECT 
EXTRACT(year from sale_date) as year,
EXTRACT(month from sale_date) as month,
AVG(total_sale) as avg_sale,
RANK() OVER(PARTITION BY EXTRACT(year from sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1,2
) as t1
WHERE rank = 1


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales.

SELECT
    customer_id,
    SUM(total_sale) AS total_sales
FROM
    retail_sales
GROUP BY
    customer_id
ORDER BY
    total_sales DESC
LIMIT 5;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT 
	category,
	COUNT(DISTINCT customer_id) as Distinct_customers
FROM retail_sales
GROUP BY category


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
(
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
	COUNT(*) as Total_orders FROM hourly_sale
GROUP BY shift;



-------------------- END OF PROJECT --------------------


