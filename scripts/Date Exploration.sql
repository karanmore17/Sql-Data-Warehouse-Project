-- Exploratory Data Analysis --
/* DATE EXPLORATION */

-- Identify the earliest & latest dates ( Boundaries ) 
--Find the Date of the First & last Order
-- How many years of sales are available
SELECT 
        MIN(order_date) as first_order_date,
        MAX(order_date) as last_order_date,
        DATEDIFF(year,MIN(order_date),MAX(order_date)) as order_range_years
FROM gold.fact_sales;


-- Find the Youngest & Oldest Customer--
SELECT 
    MIN(birth_date) as oldest_customer,
    MAX(birth_date) as youngest_customer,
    DATEDIFF(year,MIN(birth_date), GETDATE()) as oldest_age,
    DATEDIFF(year,MAX(birth_date), GETDATE()) as youngest_age
FROM gold.dim_customers;
