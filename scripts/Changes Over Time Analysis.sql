-- Advanced Analytics Project--
---/* Changes Over Time Analysis *\---

--- Analyzes Sales Over Time ---
SELECT
		order_date,
		SUM(sales_amount) as Total_Sales
		FROM gold.fact_sales
		WHERE order_date IS NOT NULL
		GROUP BY order_date
ORDER BY order_date;

-- Analyze Sales Over Year --
SELECT
		YEAR(order_date) as Order_Year,
		SUM(sales_amount) as Total_Sales,
		COUNT(DISTINCT customer_id) as Total_Customers,
		SUM(quantity) as Total_Quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)  -- It Gives Us High Level overview insights 
ORDER BY YEAR(order_date); -- which helps with strategic decision making

-- Analyze Sales Over Months & Years --

SELECT
		YEAR(order_date) as Order_Year,
		MONTH(order_date) as Order_Month,
		SUM(sales_amount) as Total_Sales,
		COUNT(DISTINCT customer_id) as Total_Customers,
		SUM(quantity) as Total_Quantity
FROM gold.fact_sales
		WHERE order_date IS NOT NULL
		GROUP BY YEAR(order_date) , MONTH(order_date) 
		ORDER BY YEAR(order_date) ,MONTH(order_date);