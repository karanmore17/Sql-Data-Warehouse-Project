-- Exploratory Data Analysis --
/* DIMENSION EXPLORATION */

-- Explore All Countries Our Customers Come From.
SELECT DISTINCT country
from gold.dim_customers;

-- Explore All Categories "THE MAJOR DIVISIONS"
SELECT DISTINCT category, subcategory, product_name FROM gold.dim_products
ORDER BY 1,2,3;