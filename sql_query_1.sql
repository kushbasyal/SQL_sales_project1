
DROP TABLE IF EXISTS sales;
CREATE TABLE sales 
           (
              transactions_id INT primary key,
			  sale_date DATE,
			  sale_time TIME,
			  customer_id INT,
			  gender VARCHAR(25),
			  age INT,
			  category VARCHAR(35),
			  quantity INT,
			  price_per_unit FLOAT,
			  cogs FLOAT,
		      total_sale FLOAT
		   );
		   
SELECT * FROM sales
LIMIT 100;

SELECT 
      COUNT(*) 
FROM sales;

-- Check for the null values
SELECT * FROM sales
where 
      transactions_id IS NULL
	  OR
	  sale_date IS NULL
	  OR
	  sale_time IS NULL
	  OR
	  gender IS NULL
	  OR
	  category IS NULL
	  OR
	  quantity IS NULL
	  OR
	  price_per_unit IS NULL
	  OR
	  cogs IS NULL
	  OR
	  total_sale IS NULL
	  ;
-- Since we have three null values in price_per_unit, cogs and total_sales, deleting these columns won't afffect in analysis
-- Delete the columns having null values

DELETE FROM sales
where 
     transactions_id IS NULL
	  OR
	  sale_date IS NULL
	  OR
	  sale_time IS NULL
	  OR
	  gender IS NULL
	  OR
	  category IS NULL
	  OR
	  quantity IS NULL
	  OR
	  price_per_unit IS NULL
	  OR
	  cogs IS NULL
	  OR
	  total_sale IS NULL;

-- Data Exploration
-- Calculate the total number of records
SELECT COUNT(*) as Total_sales FROM sales;

-- Find the total number of unique customers

SELECT COUNT(DISTINCT customer_id) AS Total_Customers FROM sales;

-- What is the total number of unique categories in the table?

SELECT COUNT(DISTINCT category) AS Total_Categories FROM sales;

-- Data Analysis

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT * FROM sales 
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022

SELECT * from sales
WHERE category = 'Clothing'
AND quantity > 3
AND TO_CHAR(sale_date, 'YYYY-MM')= '2022-11';

-- Q.3 Write an SQL query to calculate the sum of sales and total orders for each category

SELECT category,
SUM(total_sale) AS Total_Sales,
COUNT(total_sale) AS Total_Orders
FROM sales
GROUP BY category;


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'beauty' category

SELECT
ROUND(AVG(age),2) as Average_Beauty_Age
FROM sales
WHERE category = 'Beauty';

-- Q.5 write a SQL query to find all transactions where total_sale is greater than 1000

SELECT * FROM sales
where total_sale > 1000;

--Q.6 Write a SQL query to find the total number of transactions (transactions_id) made by each gender to each category

SELECT gender,category, count(transactions_id) AS  Total_transactions
FROM sales
group by gender,category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

WITH ranked_sales AS (
   SELECT 
     EXTRACT(YEAR FROM sale_date) as year,
	 EXTRACT(MONTH FROM sale_date) as month,
	 AVG(total_sale) AS average_sale,
	 RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as ranks
	 from sales
	 group by year, month
)
SELECT year,month,average_sale FROM ranked_sales
WHERE ranks = 1;

-- Write a SQL query to find the top 5 customers based on the highest total sales

SELECT customer_id, SUM(total_sale) as Highest_sales
FROM sales
GROUP BY customer_id
ORDER BY Highest_sales DESC
LIMIT 5;

-- Q.9 Write down a SQL query to find the number of unique customers who purchased items from each category

SELECT
       category,
	   count(DISTINCT customer_id) as unique_customers
FROM sales 
GROUP BY category;

--Q.10 Write a SQl query to create each shift and number of orders(Example Morning <12, Afternoon between 12 and 17, Evening >17)

WITH hourly_sales AS(
    SELECT *,
         CASE
	         WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		     WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		     ELSE 'Evening'
	     END as shift
FROM sales
)
SELECT
      shift,
	  count(*) as Total_Orders
FROM hourly_sales
GROUP BY shift;

select * from sales;

-- End-- 



