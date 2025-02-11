--Creating the data definition for the table
CREATE TABLE df_orders(
	order_id INT PRIMARY KEY,
	order_date DATE,
	ship_mode VARCHAR(20),
	segment VARCHAR(20),
	country VARCHAR(20),
	city VARCHAR(20),
	"state" VARCHAR(20),
	postal_code VARCHAR(20),
	region VARCHAR(20),
	category VARCHAR(20),
	sub_category VARCHAR(20),
	product_id VARCHAR(50),
	cost_price INT,
	list_price INT,
	quantity INT,
	discount_percent DOUBLE PRECISION,
	discount DOUBLE PRECISION,
	sale_price DOUBLE PRECISION,
	profit DOUBLE PRECISION
)

--see the table after loading
SELECT * FROM df_orders

--Find top 10 higest revenue generating products
SELECT
	product_id, 
	SUM(sale_price * quantity) AS sales
FROM df_orders
GROUP BY product_id 
ORDER BY sales DESC
LIMIT 10


--Top 5 highest selling products in each region
WITH CTE AS (
SELECT region, product_id, SUM(sale_price) AS sales
FROM df_orders
GROUP BY region, product_id
)
SELECT *
FROM (
SELECT *,
ROW_NUMBER() OVER(PARTITION BY region ORDER BY sales DESC) AS rank_p
FROM cte
)
WHERE rank_p <=5


--Month over month growth comparison for all years
WITH CTE AS (
SELECT 
	EXTRACT(YEAR FROM ORDER_DATE) AS ORDER_YEAR,
	EXTRACT(MONTH FROM ORDER_DATE) AS ORDER_MONTH,
	SUM(SALE_PRICE*QUANTITY) AS SALES
FROM DF_ORDERS
GROUP BY EXTRACT(YEAR FROM ORDER_DATE), EXTRACT(MONTH FROM ORDER_DATE)
)
SELECT 
    order_month,
    SUM(CASE WHEN order_year = 2022 THEN sales ELSE 0 END) AS sales_2022,
    SUM(CASE WHEN order_year = 2023 THEN sales ELSE 0 END) AS sales_2023
FROM cte
GROUP BY order_month
ORDER BY order_month;

--Finds the month with highest sales for each category
WITH CTE AS (
SELECT
	CATEGORY,
	TO_CHAR(ORDER_DATE, 'YYYYMM') AS ORDER_YEAR_MONTH,
	SUM(SALE_PRICE*QUANTITY) AS SALES
FROM DF_ORDERS
GROUP BY CATEGORY, TO_CHAR(ORDER_DATE, 'YYYYMM')
ORDER BY ORDER_YEAR_MONTH, SALES DESC
)
SELECT *
FROM (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY CATEGORY ORDER BY SALES) RANK_P
	FROM CTE
)
WHERE RANK_P = 1


--Which sub category has the highest growth by profit in 2023 compared to 2022
WITH cte AS (
    SELECT 
        sub_category,
        EXTRACT(YEAR FROM order_date) AS order_year,
        SUM(sale_price * quantity) AS sales
    FROM df_orders
    GROUP BY sub_category, EXTRACT(YEAR FROM order_date)
),
cte2 AS (
    SELECT 
        sub_category,
        SUM(CASE WHEN order_year = 2022 THEN sales ELSE 0 END) AS sales_2022,
        SUM(CASE WHEN order_year = 2023 THEN sales ELSE 0 END) AS sales_2023
    FROM cte 
    GROUP BY sub_category
)
SELECT *,
       (sales_2023 - sales_2022) AS sales_growth
FROM cte2
ORDER BY sales_growth DESC
LIMIT 1;


---Let's do some analysis 
--1. Sales Performance Analysis

--Total revenue and profit
SELECT
	SUM(SALE_PRICE * QUANTITY) AS TOTAL_REVENUE,
	SUM(PROFIT * QUANTITY) AS TOTAL_PROFIT
FROM DF_ORDERS

--Revenue and profit by year
SELECT 
	EXTRACT(YEAR FROM ORDER_DATE) AS YEARS,
	SUM(SALE_PRICE * QUANTITY) AS TOTAL_REVENUE,
	SUM(PROFIT * QUANTITY) AS TOTAL_PROFIT
FROM DF_ORDERS
GROUP BY YEARS

--Region that has highest revenue
SELECT
	REGION,
	SUM(SALE_PRICE * QUANTITY) AS REVENUE
FROM DF_ORDERS
GROUP BY REGION
ORDER BY REVENUE DESC

--Region with highest profit
SELECT
	REGION,
	SUM(PROFIT * QUANTITY) AS TOTAL_PROFIT
FROM DF_ORDERS
GROUP BY REGION
ORDER BY TOTAL_PROFIT DESC

--Monthly trends for revenue and profit
SELECT 
    TO_CHAR(ORDER_DATE, 'YYYYMM') AS MONTH,
    SUM(SALE_PRICE * QUANTITY) AS MONTHLY_REVENUE
FROM DF_ORDERS
GROUP BY MONTH
ORDER BY MONTH;

SELECT 
    TO_CHAR(ORDER_DATE, 'YYYYMM') AS MONTH,
    SUM(PROFIT * QUANTITY) AS MONTHLY_PROFIT
FROM DF_ORDERS
GROUP BY MONTH
ORDER BY MONTH;


--let's go with the Product Performance Analysis

--Top 5 selling products with their units sold, category and sub category
SELECT 
	PRODUCT_ID,
	CATEGORY, 
	SUB_CATEGORY,
	SUM(QUANTITY) AS TOTAL_UNITS_SOLD,
	SUM(SALE_PRICE*QUANTITY) AS REVENUE
FROM DF_ORDERS
GROUP BY CATEGORY, SUB_CATEGORY, PRODUCT_ID
ORDER BY REVENUE DESC
LIMIT 5

--Most profitable products
SELECT 
	PRODUCT_ID,
	SUM(PROFIT*QUANTITY) AS TOTAL_PROFIT
FROM DF_ORDERS
GROUP BY PRODUCT_ID
ORDER BY TOTAL_PROFIT DESC
LIMIT 5

--Best selling product categories
SELECT
	CATEGORY,
	SUM(SALE_PRICE * QUANTITY) AS REVENUE
FROM DF_ORDERS
GROUP BY CATEGORY
ORDER BY REVENUE DESC 

--TOP 5 selling sub categories
SELECT
	SUB_CATEGORY,
	SUM(SALE_PRICE * QUANTITY) AS REVENUE
FROM DF_ORDERS
GROUP BY SUB_CATEGORY
ORDER BY REVENUE DESC 
LIMIT 5

--Discount and pricing analysis

--How do discount affects sales ? 
SELECT
	DISCOUNT_PERCENT,
	COUNT(ORDER_ID) AS ORDERS_COUNT,
	SUM(SALE_PRICE*QUANTITY) AS REVENUE_GENERATED
FROM DF_ORDERS
GROUP BY DISCOUNT_PERCENT


--Profit margin for each category
SELECT
	CATEGORY,
	SUM(PROFIT*QUANTITY) AS TOTAL_PROFIT,
	AVG(PROFIT * QUANTITY / NULLIF(SALE_PRICE*QUANTITY, 0) * 100) AS AVG_PROFIT_MARGIN
FROM DF_ORDERS
GROUP BY CATEGORY
ORDER BY AVG_PROFIT_MARGIN DESC


--Customer order analysis
-- What is the order distribution by customer segment?
SELECT 
	SEGMENT,
	COUNT(ORDER_ID) AS TOTAL_ORDERS,
	SUM(SALE_PRICE*QUANTITY) AS TOTAL_REVENUE
FROM DF_ORDERS
GROUP BY SEGMENT
ORDER BY TOTAL_REVENUE DESC

--Time based Trends
--Days with their order counts and revenue
SELECT 
    EXTRACT(DOW FROM order_date) AS day_of_week,
    COUNT(order_id) AS total_orders,
	SUM(SALE_PRICE * QUANTITY) AS REVENUE
FROM DF_ORDERS
GROUP BY day_of_week
ORDER BY total_orders DESC;



