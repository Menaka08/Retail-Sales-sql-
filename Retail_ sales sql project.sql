SELECT * FROM Retail_Sales; 

EXEC sp_rename 'Retail_sales.quantiy', 'quantity', 'COLUMN';

SELECT TOP 10 * FROM Retail_Sales;

SELECT COUNT(*) FROM Retail_Sales 

SELECT CONVERT(VARCHAR(8), CAST('11:45:00' AS TIME), 108) AS formatted_time;

UPDATE Retail_Sales
SET sale_time = CONVERT(VARCHAR(8), CAST(sale_time AS TIME), 108);

select sale_time from Retail_Sales;

-- Data Cleaning

SELECT * FROM Retail_Sales; 

SELECT * FROM Retail_Sales
WHERE transactions_id IS NULL
       OR 
	  sale_date IS NULL
	  OR
	  sale_time IS NULL
	  or
	  gender is null
	  OR
	  category IS NULL
	  or
	  quantiy IS NULL
	  or
	  cogs IS NULL
	  OR total_sale IS NULL

DELETE FROM Retail_Sales
WHERE
   transactions_id IS NULL
       OR 
	  sale_date IS NULL
	  OR
	  sale_time IS NULL
	  or
	  gender is null
	  OR
	  category IS NULL
	  or
	  quantiy IS NULL
	  or
	  cogs IS NULL
	  OR total_sale IS NULL

-- Data Exploration

-- how many sales we have?
 
 SELECT count(total_sale) as total_sale from Retail_Sales;



 -- how many unique customers we have?

 select count(distinct customer_id) as total_sale from Retail_Sales;

 select distinct category from Retail_Sales


-- SOLVING BUSINESS PROBLEMS AND MY ANALYSIS & FINDING--

SELECT * FROM Retail_Sales; 

-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05

 SELECT *  FROM Retail_Sales
 WHERE sale_date = '2022-11-05';

 --2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022

SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    FORMAT(sale_date, 'yyyy-MM') = '2022-11'
    AND
    quantity >= 4;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.


SELECT category,
SUM(total_sale) as net_sale,
COUNT(*) AS total_orders
FROM Retail_Sales
group by category;



-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT  AVG(age) as avg_age
from Retail_Sales
where category = 'Beauty';


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM Retail_Sales
WHERE total_sale > 1000;


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT category, gender, count(transactions_id) as total_transaction   FROM Retail_Sales
group by gender, category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

WITH MonthlySales AS (
    SELECT 
        YEAR(sale_date) AS sale_year,
        MONTH(sale_date) AS sale_month,
        AVG(total_sale) AS avg_monthly_sale
    FROM retail_sales
    GROUP BY 
        YEAR(sale_date), 
        MONTH(sale_date)
),
RankedSales AS (
    SELECT 
        sale_year,
        sale_month,
        avg_monthly_sale,
        RANK() OVER (PARTITION BY sale_year ORDER BY avg_monthly_sale DESC) AS monthly_rank
    FROM MonthlySales
)
SELECT 
    sale_year,
    sale_month,
    avg_monthly_sale AS best_monthly_sale
FROM RankedSales
WHERE monthly_rank = 1
ORDER BY sale_year, sale_month;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT TOP 5 customer_id,
sum(total_sale) as total_sale
from Retail_Sales
group by customer_id
Order by total_sale;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT  category, COUNT(DISTINCT customer_id) as unique_customers
from Retail_Sales
GRoup by category;


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17) 

WITH hourly_sale AS (
    SELECT *,
        CASE
            WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
            WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;