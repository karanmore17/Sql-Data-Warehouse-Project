-- Advanced Analytics Project--
---/* Build Customer Report *\---

/*
Customer Report
================================================================================================
================================================================================================
Purpose:
	- This report consolidates key customer metrics and behaviors

Highlights:
	1. Gathers essential fields such as names, ages, and transaction details. 
	2. Segments customers into categories (VIP, Regular, New) and age groups. 
	3. Aggregates customer-level metrics:
		- total orders
		- total sales
		- total quantity purchased
		- total products
		- lifespan (in months)
	4. Calculates valuable KPIs:
	- recency (months since last order)
	- average order value
	- average monthly spend 
=============================================================================================
*/
		CREATE VIEW gold.report_customers As
		WITH base_query As (
/* -------------------------------------------------------------------------------------------
1) Base Query:- Retrieves core columns from the table
--------------------------------------------------------------------------------------------*/
  SELECT 
		f.order_number,
		f.product_key,
		f.order_date,
		f.sales_amount,
		f.quantity,
		c.country,
		c.customer_key,
		c.customer_id,
		c.customer_number,
		CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
		DATEDIFF( year, c.birth_date, GETDATE()) As age
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_customers c
	ON f.customer_id = c.customer_id
	WHERE order_date IS NOT NULL ),

		customer_aggregations As (
/* -------------------------------------------------------------------------------------------
2) Customer Aggregations:- Summarizes key metrics at the customer level
--------------------------------------------------------------------------------------------*/
					SELECT
					customer_key,
					customer_number,
					customer_name,
					age,    
					COUNT(DISTINCT order_number) As total_orders,                   -- total orders
					SUM(sales_amount) As total_sales,		                        -- total sales
					SUM(quantity) As total_quantity,		                        -- total quantity purchased
					COUNT(DISTINCT product_key) As total_products,	                -- total products
					MAX(order_date) As last_order_date,
					DATEDIFF(month, MIN(order_date), MAX(order_date)) As lifespan	-- lifespan (in months)
              FROM base_query
              GROUP BY 
					customer_key, 
					customer_number, 
					customer_name, 
					age)

/* -----------------------------------------------------
3) Customer Segmentations & Calculating Valuable KPI'S
-------------------------------------------------------*/
					SELECT
						customer_key,
						customer_number,
						customer_name, 
						CASE 
							 WHEN age < 20 THEN 'Under 20'
							 WHEN age BETWEEN 20 AND 29 THEN '20-29'
							 WHEN age BETWEEN 30 AND 39 THEN '30-39'
							 WHEN age BETWEEN 40 AND 49 THEN '40-49'
							 ELSE '50 and Above'
						END AS age_group, --  Segments customers into categories based on age groups
						CASE 
							  WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
							  WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'REGULAR'
							  ELSE 'NEW'
						END AS customer_segment, -- Segments customers into categories (VIP, Regular, New) 
						DATEDIFF(month, last_order_date, GETDATE()) As recency,
						total_orders,                  
						total_sales,		                       
						total_quantity,		                       
						total_products,	           	
						lifespan,
						-- Compute Average Order Value (AVO)
						CASE 
						     WHEN total_sales = 0 THEN 0
							 ELSE total_sales / total_orders 
						END As avg_order_value,
						-- Compute Average Monthly Spend (AVS)
						CASE 
						     WHEN lifespan = 0 THEN total_sales
							 ELSE total_sales / lifespan
						END AS avg_monthly_spend
			FROM customer_aggregations;


		    /*Customer Report
================================================================================================
================================================================================================*/
			-- Example of Simple Analysis by using Customer report --
			SELECT 
			customer_segment,
			COUNT(customer_number) As total_customers,
			SUM(total_sales) As total_sales
			FROM gold.report_customers
			GROUP BY customer_segment
			ORDER BY total_customers DESC;