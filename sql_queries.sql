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




