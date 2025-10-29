-- Advanced Analytics Project--
---/* Build Product Report *\---


/*
================================================================================================
================================================================================================
Product Report
================================================================================================
================================================================================================
Purpose:- This report consolidates key product metrics and behaviors.

Highlights:
		1. Gathers essential fields such as product name, category, subcategory, and cost.
		2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers. 
		3. Aggregates product-level metrics:
											- total orders
											- total sales
											- total quantity sold
											- total customers (unique)
		                                    - lifespan (in months)
		4. Calculates valuable KPIs:
		- recency (months since last sale)
		- average order revenue (AOR)
        - average monthly revenue
================================================================================================
================================================================================================
*/
 -- 1) Gathered essential fields for product insights in the base query --
					CREATE VIEW gold.report_products As 
					WITH base_query As (
SELECT 
			f.order_number,
			f.order_date,
			f.customer_id,
			f.sales_amount,
			f.quantity,
			p.product_key,
			p.product_name,
			p.category,
			p.subcategory,
			p.cost
FROM gold.fact_sales f
			LEFT JOIN gold.dim_products p
			ON f.product_key = p.product_key
			WHERE order_date IS NOT NULL ), -- Only consider valid sales dates


Product_Aggregations As (
/* ----------------------------------------------------------------------------------
2) Product Aggregations:- Summarizes key metrics at the product level
-------------------------------------------------------------------------------------*/
                  SELECT 
				  product_key,
				  product_name,
				  category,
				  subcategory,
				  cost,
				  DATEDIFF( month, MIN(order_date) ,MAX(order_date) ) As lifespan, -- lifespan (in months)
				  MAX(order_date) As last_sale_date,
				  COUNT(DISTINCT order_number) As total_orders, -- total orders
				  COUNT(DISTINCT customer_id) As total_customers, -- total customers (unique)
				  SUM( quantity) As total_quantity, -- total quantity sold
				  SUM(sales_amount) As total_revenue, -- total sales
				  ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF ( quantity, 0)), 1) As avg_selling_price
			FROM base_query 
			 GROUP BY
			      product_key,
				  product_name,
				  category,
				  subcategory,
				  cost)

/* ---------------------------------------------------------------
3) Final Query:- Combines all products results into one output 
-----------------------------------------------------------------*/
    SELECT
				  product_key,
				  product_name,
				  category,
				  subcategory,
				  cost,
				  last_sale_date,
				  DATEDIFF( MONTH, last_sale_date, GETDATE()) As recency_months,
				  CASE 
				        WHEN total_revenue > 50000 THEN 'High-Performers'
						WHEN total_revenue >= 10000 THEN 'Mid-Range'
					    ELSE 'Low-Performers'  
				  END AS product_segments,
				  lifespan,
				  total_orders,
				  total_revenue,
				  total_quantity,
				  total_customers,
				  avg_selling_price,
				  -- Average Order Revenue (AVO)
				  CASE 
				       WHEN total_orders = 0 THEN 0
					   ELSE total_revenue / total_orders
				  END As avg_order_revenue,
				  -- average monthly revenue
				  CASE 
				       WHEN lifespan = 0 THEN total_revenue
					   ELSE total_revenue / lifespan
				  END AS avg_monthly_revenue
	 FROM Product_Aggregations;

	 /* Product Report
================================================================================================
================================================================================================*/
			-- Example of Simple Analysis by using Product report --
   SELECT * FROM gold.report_products
   ORDER BY product_key;

   -- Advanced Analytics Project Completed :) --