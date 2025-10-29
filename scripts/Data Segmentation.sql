-- Advanced Analytics Project--
---/* DATA SEGMENTATION *\---

/* Segment products into cost ranges and count 
how many products fall into each segment*/
WITH product_segments AS (
			SELECT 
			product_key,
			product_name,
			cost,
			CASE WHEN cost < 100 THEN 'Below 100'
				 WHEN cost BETWEEN 100 AND 500 THEN '100-500'
				 WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
				 ELSE 'Above 1000'
				END AS cost_range
FROM gold.dim_products)

SELECT
			cost_range,
			COUNT(product_key) As total_products
			From product_segments
			GROUP BY cost_range
ORDER BY total_products DESC;


/* Group customers into three segments based on their spending behavior:
- VIP: Customers with at least 12 months of history and spending more than €5,000. 
- Regular: Customers with at least 12 months of history but spending €5,000 or less. 
- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/

WITH Customer_Spending As (
SELECT
		c.customer_id,
		SUM(sales_amount) as total_spending,
		MIN(order_date) as first_order,
		MAX(order_date) as last_order,
		DATEDIFF(month, MIN(order_date), MAX(order_date)) As lifespan
FROM gold.fact_sales f
 LEFT JOIN gold.dim_customers c
 ON f.customer_id = c.customer_id
 GROUP BY c.customer_id),

Customer_segmentation As (
		 SELECT 
		 customer_id,
		 CASE WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
			  WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'REGULAR'
			  ELSE 'NEW'
		END AS customer_segment
 FROM Customer_Spending ) 

 SELECT  
 customer_segment,
 COUNT(DISTINCT customer_id) As total_customer
 From Customer_segmentation
 GROUP BY customer_segment
 ORDER BY total_customer DESC;