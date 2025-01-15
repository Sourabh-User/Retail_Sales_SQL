--CREATE DATABASE sql_project_p1--
CREATE DATABASE sql_project_p1;

--CREATE TABLE retail_sales--
CREATE TABLE retail_sales 
					   (transactions_id INT PRIMARY KEY,	
						sale_date	DATE,
						sale_time	TIME,
						customer_id	INT,
					    gender	    VARCHAR(15),
						age	        INT,
						category    VARCHAR(15),
						quantity	    INT,
						price_per_unit	FLOAT,
						cogs	        FLOAT,
						total_sales		FLOAT
						);

--DATA CLEANING--
DELETE FROM retail_sales 
WHERE  
	transactions_id IS NULL
	OR
	sale_date IS NUll
	OR
	sale_time IS NUll
	OR
	customer_id IS NUll
	OR
	gender  IS NULL
	OR
	category IS NUll
	OR
	quantity IS NUll
	OR 
	cogs IS NUll
	OR
	total_sales IS NULL;

--DATA EXPLORATION--

--HOW MANY SALES WE HAVE ?--
SELECT COUNT (*) AS total_sales  FROM retail_sales

--HOW MANY CUSTOMERS WE HAVE ?--
SELECT COUNT (DISTINCT customer_id) AS total_customer FROM retail_sales

--DATA ANALYSIS &  BUSINESS KEY PROBLEM & ANSWERS--

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05--
SELECT * 
FROM retail_sales 
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than & equals to 4 in the month of Nov-2022
SELECT * FROM retail_sales 
WHERE category = 'Clothing' 
AND quantity >= 4
AND TO_CHAR (sale_date,'YYYY-MM') = '2022-11';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category--
SELECT category , 
SUM(total_sales) AS net_sales 
FROM retail_sales 
GROUP BY category;

--Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.--
SELECT AVG (age)
FROM retail_sales
WHERE category ='Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * 
FROM retail_sales 
WHERE total_sales > 1000  
GROUP BY transactions_id;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT gender , category, 
COUNT (transactions_id) 
AS total_transactions 
FROM retail_sales 
GROUP BY gender, category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT 
	year,
	month
FROM( 
	SELECT 
	EXTRACT (YEAR FROM sale_date) AS year,
	EXTRACT (MONTH FROM sale_date) AS month,
	AVG (total_sales) AS avg_sale,
	RANK () OVER (PARTITION BY EXTRACT (YEAR FROM sale_date) ORDER BY AVG (total_sales) DESC) AS rank
	FROM retail_sales
	GROUP BY year , month) AS t1

WHERE rank =1 ;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT 
	customer_id,
	SUM(total_sales) AS total_sale
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sale DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
	COUNT (DISTINCT (customer_id)),
	category
FROM retail_sales
GROUP BY 2;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift

-- End of project












