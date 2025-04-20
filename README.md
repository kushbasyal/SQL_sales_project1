# Project Documentation

## Sales Data Analysis

This project involves analyzing sales data from the `sales` table using SQL queries. Below are the steps for creating the table, performing data exploration, and running analysis queries to gather insights about the sales performance.

### 1. Table Creation

The first step is to create the `sales` table with various columns that store relevant transaction details.

```sql
-- Create the sales table
DROP TABLE IF EXISTS sales;

CREATE TABLE sales 
(
    transactions_id INT PRIMARY KEY,        
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
```

### 2. Data Exploration Queries

#### a. Write a query to view the first 100 records:

```sql
SELECT * FROM sales
LIMIT 100;
```

#### b. Write a query to find the total number of records:

```sql
SELECT COUNT(*) 
FROM sales;
```

#### c. Write a query to check for the null values in any column:

```sql
SELECT * FROM sales
WHERE 
    transactions_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR gender IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR price_per_unit IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;
```

#### d. Write a query to delete all the records with null values:

```sql
DELETE FROM sales
WHERE 
    transactions_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR gender IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR price_per_unit IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;
```

#### e. Write a query to count the total number of records after cleanup:

```sql
SELECT COUNT(*) as Total_sales 
FROM sales;
```

#### f. Write a query to find the total number of unique customers:

```sql
SELECT COUNT(DISTINCT customer_id) AS Total_Customers 
FROM sales;
```

#### g. Write a query to find the total number of unique categories:

```sql
SELECT COUNT(DISTINCT category) AS Total_Categories 
FROM sales;
```

### 3. Data Analysis Queries

#### a. Write a query to retrieve all columns for sales made on '2022-11-05':

```sql
SELECT * FROM sales 
WHERE sale_date = '2022-11-05';
```

#### b. Write a query to retrieve transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022:

```sql
SELECT * FROM sales
WHERE category = 'Clothing'
AND quantity > 3
AND TO_CHAR(sale_date, 'YYYY-MM')= '2022-11';
```

#### c. Write a query to calculate the sum of sales and total orders for each category:

```sql
SELECT category,
SUM(total_sale) AS Total_Sales,
COUNT(total_sale) AS Total_Orders
FROM sales
GROUP BY category;
```

#### d. Write a query to find the average age of customers who purchased items from the 'Beauty' category:

```sql
SELECT
ROUND(AVG(age),2) as Average_Beauty_Age
FROM sales
WHERE category = 'Beauty';
```

#### e. Write a query to find all transactions where total_sale is greater than 1000:

```sql
SELECT * FROM sales
WHERE total_sale > 1000;
```

#### f. Write a query to find the total number of transactions made by each gender to each category:

```sql
SELECT gender, category, COUNT(transactions_id) AS Total_transactions
FROM sales
GROUP BY gender, category;
```

#### g. Write a query to calculate the average sale for each month and find the best-selling month in each year:

```sql
WITH ranked_sales AS (
   SELECT 
     EXTRACT(YEAR FROM sale_date) as year,
     EXTRACT(MONTH FROM sale_date) as month,
     AVG(total_sale) AS average_sale,
     RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as ranks
     FROM sales
     GROUP BY year, month
)
SELECT year, month, average_sale 
FROM ranked_sales
WHERE ranks = 1;
```

#### h. Write a query to find the top 5 customers based on the highest total sales:

```sql
SELECT customer_id, SUM(total_sale) as Highest_sales
FROM sales
GROUP BY customer_id
ORDER BY Highest_sales DESC
LIMIT 5;
```

#### i. Write a query to find the number of unique customers who purchased items from each category:

```sql
SELECT
    category,
    COUNT(DISTINCT customer_id) as unique_customers
FROM sales 
GROUP BY category;
```

#### j. Write a query to create each shift (Morning < 12, Afternoon between 12 and 17, Evening > 17) and count the number of orders:

```sql
WITH hourly_sales AS (
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
    COUNT(*) as Total_Orders
FROM hourly_sales
GROUP BY shift;
```

### 4. Final Query to View All Sales Records

```sql
SELECT * FROM sales;
```

## 5. Key Insights and Observations

Based on the sales data analysis, here are some notable insights:

- **Top-Selling Categories:** Categories such as *Clothing* and *Beauty* recorded higher total sales and order volumes, indicating strong customer demand.
- **High-Value Customers:** The top 5 customers contributed significantly to overall sales, highlighting the importance of customer segmentation for loyalty programs.
- **Sales Timing Trends:** Most sales occur during the *Afternoon* and *Evening* shifts, suggesting strategic opportunities for targeted promotions during peak hours.
- **Age Demographics:** The average age of customers in the *Beauty* category suggests that middle-aged individuals are the primary buyers, useful for targeted marketing.
- **Monthly Trends:** Some months outperform others in terms of average sales; understanding seasonal patterns can guide stock and marketing decisions.
- **Gender Preferences:** Sales data by gender and category show differing shopping behavior, which can help personalize marketing strategies.
- **Customer Reach:** Each category attracts a unique set of customers, emphasizing the need to diversify offerings to expand the customer base.

These findings can be leveraged for better business decision-making, marketing strategies, inventory management, and overall customer experience improvement.