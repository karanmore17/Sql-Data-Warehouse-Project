-- Advanced Analytics Project--
---/* Part-To-Whole Analysis *\---

-- Which category contribute the most to overall  Sales--

WITH category_sales AS (
SELECT
			p.category,
			SUM(f.sales_amount) as total_sales
			FROM gold.fact_sales f
			LEFT JOIN gold.dim_products p
			ON p.product_key = f.product_key
			GROUP BY p.category
			)

			SELECT 
			category,
			total_sales,
			SUM(total_sales) OVER() as overall_sales,
			CONCAT(ROUND((CAST (total_sales As float) / SUM(total_sales) OVER())*100,2), '%') As pct_of_total
			FROM category_sales
			ORDER BY total_sales DESC;

-- Answer:- Bikes Category contributes the most to overall Sales --