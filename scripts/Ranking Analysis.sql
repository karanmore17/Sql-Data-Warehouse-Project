-- Exploratory Data Analysis --
/* Ranking Analysis */ --

-- Which 5 products generate the highest Revenue ??
SELECT TOP 5 
        p.product_id,
        p.product_number,
        p.product_name,
        SUM(f.sales_amount) as Total_Revenue
        FROM gold.fact_sales f 
        LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
        GROUP BY p.product_id, p.product_number, p.product_name
ORDER BY Total_Revenue DESC;

-- What are the 5 worst-performing products in terms of sales ??
SELECT TOP 5 
        p.product_name,
        SUM(f.sales_amount) as total_Revenue
        FROM gold.fact_sales f 
        LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
        GROUP BY  p.product_name
ORDER BY total_Revenue;

-- Which are the best 5 product subcategories that generate the highest Revenue ??
SELECT TOP 5 
        p.subcategory,
        SUM(f.sales_amount) as Total_Revenue
        FROM gold.fact_sales f
        LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
        GROUP BY p.subcategory
ORDER BY Total_Revenue DESC;

-- Which TOP 5 products generate the highest Revenue ( Give Ranking )
SELECT *
FROM 
(
SELECT  
        p.product_name,
        SUM(f.sales_amount) as Total_Revenue,
        ROW_NUMBER() OVER( ORDER BY SUM(f.sales_amount)DESC) as rank_products
        FROM gold.fact_sales f 
        LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
        GROUP BY p.product_name
)t
WHERE rank_products <=5; 

-- FIND the TOP 10 customers who have generated the highest revenue 

SELECT TOP 10
        c.customer_id,
        c.first_name,
        c.last_name,
        SUM(f.sales_amount) AS Total_Revenue
        From 
        gold.dim_customers c
        LEFT JOIN gold.fact_sales f
        ON f.customer_id = c.customer_id
        GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY Total_Revenue DESC;

-- 3 customers with fewest orders placed
SELECT TOP 3
        c.customer_id,
        c.first_name,
        c.last_name,
        COUNT(DISTINCT f.order_number) AS Total_Orders
        From 
        gold.dim_customers c
        LEFT JOIN gold.fact_sales f
        ON f.customer_id = c.customer_id
        GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY Total_Orders;

-- THE END :) --