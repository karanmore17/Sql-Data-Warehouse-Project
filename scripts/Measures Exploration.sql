        -- Exploratory Data Analysis --
        /* Measures Exploration */


    -- Find the Total Sales
    SELECT SUM(sales_amount) as Total_Sales FROM gold.fact_sales
    -- Find How Many Items are sold
    SELECT SUM(quantity) as Items_Sold FROM gold.fact_sales
    -- Find the Average Selling Price
    SELECT AVG(price) as Avg_price FROM gold.fact_sales
    -- Find the Total Number Of Orders
    SELECT COUNT(order_number) as Total_orders FROM gold.fact_sales
    -- Find the Total Number Of products
    SELECT COUNT(product_key) as Total_products FROM gold.dim_products
    -- Find the Total Number Of customers
    SELECT COUNT(customer_id) as Total_customers FROM gold.dim_customers
    -- Find the Total Number Of customers that has placed an order
    SELECT COUNT(DISTINCT customer_id) as Total_customers_with_orders FROM gold.dim_customers


-- Generate  Report That Shows all the key Metrics of the Business --

SELECT 'Total_Sales' As measure_name, SUM(sales_amount) as measure_value 
        FROM gold.fact_sales
        UNION ALL 
SELECT  'Total_Quantity' As measure_name, SUM(quantity) 
        FROM gold.fact_sales
        UNION ALL 
SELECT 'Average_price' As measure_name, AVG(price)  
        FROM gold.fact_sales
        UNION ALL 
SELECT 'Total_orders ' As measure_name, COUNT(order_number) 
        FROM gold.fact_sales
        UNION ALL 
SELECT 'Total_products ' As measure_name, COUNT(product_key) 
        FROM gold.dim_products
        UNION ALL
SELECT 'Total_customers' As measure_name, COUNT(customer_id) 
        FROM gold.dim_customers
        UNION ALL
SELECT 'Total_customers_with_orders' As measure_name, COUNT(DISTINCT customer_id)  
        FROM gold.dim_customers;