-- Advanced Analytics Project--
---/* Cumulative Analysis *\---

-- Calculate the total Sales per month 
-- And the running total of sales Over Time
SELECT
		order_date,
		Total_sales,
		SUM(Total_sales) OVER ( ORDER BY order_date ) As Running_total_sales,
		AVG(avg_price) OVER ( ORDER BY order_date ) As moving_avg
		FROM 
(
		SELECT
		 DATETRUNC( month, order_date ) as order_date,
		SUM(sales_amount) as Total_sales,
		AVG(price) as avg_price
		FROM gold.fact_sales
		WHERE order_date IS nOT NULL
		GROUP BY DATETRUNC( month, order_date )
) t