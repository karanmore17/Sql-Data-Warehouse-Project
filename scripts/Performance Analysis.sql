-- Advanced Analytics Project--
---/* Performance Analysis *\---

/* Analzye the yearly performance of products by comparing their sales
to both the average sales performance of the product and the previous year's sales */


WITH yearly_pdt_sls As (
			SELECT
			YEAR(f.order_date) as order_year,
			p.product_name,
			SUM(f.sales_amount) as current_sales
			FROM gold.fact_sales f
			LEFT JOIN gold.dim_products p
			ON p.product_key = f.product_key
			WHERE order_date IS NOT NULL
			GROUP BY YEAR(order_date), p.product_name
) 
SELECT 
		order_year,
		product_name,
		current_sales,
AVG(current_sales) OVER ( PARTITION BY product_name ) As  avg_sls,
current_sales - AVG(current_sales) OVER ( PARTITION BY product_name ) As Diff_avg_sls,
CASE 
		WHEN current_sales - AVG(current_sales) OVER ( PARTITION BY product_name ) > 0 THEN 'Above Avg'
		WHEN current_sales - AVG(current_sales) OVER ( PARTITION BY product_name ) < 0 THEN 'Below Avg'
		Else 'Avg'
		END AS Avg_Change,
		-- Year Over Year Analysis --
		LAG (current_sales) OVER ( PARTITION BY product_name ORDER BY order_year) pvsyr_sls,
current_sales - LAG (current_sales) OVER ( PARTITION BY product_name ORDER BY order_year) As diff_pvs_sls,
CASE 
		WHEN current_sales - LAG (current_sales) OVER ( PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
		WHEN current_sales - LAG (current_sales) OVER ( PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
		Else 'No Change'
		END AS pvsyr_change
FROM yearly_pdt_sls
ORDER BY product_name, order_year;
