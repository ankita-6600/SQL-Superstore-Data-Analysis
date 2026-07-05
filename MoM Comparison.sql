-- Write a query to find MoM comparison using LEAD() and LAG().
----Method1: Using LAG() - This compares the current month with the previous month.
WITH MonthlySales AS (
	SELECT DATE_TRUNC('month', order_date) AS order_month,
		ROUND(SUM(sales)::numeric, 2) AS total_sales
	FROM superstore
	GROUP BY DATE_TRUNC('month', order_date)
)

SELECT order_month, total_sales,
	LAG(total_sales) OVER (ORDER BY order_month) AS prev_month_sales,
	total_sales - LAG(total_sales) OVER (ORDER BY order_month) AS sales_difference,
	ROUND(
		((total_sales - LAG(total_sales) OVER (ORDER BY order_month)) * 100) / LAG(total_sales) OVER (ORDER BY order_month)::numeric, 2
		) AS MoM_Growth_percentage
FROM MonthlySales
ORDER BY order_month;	

----Method2: Using LEAD() - This compares the current month with the next month.
WITH MonthlySales AS (
	SELECT DATE_TRUNC('month', order_date) AS order_month,
		ROUND(SUM(sales)::numeric, 2) AS total_sales
	FROM superstore
	GROUP BY DATE_TRUNC('month', order_date)
)

SELECT order_month, total_sales, 
	LEAD(total_sales) OVER (ORDER BY order_month) AS next_month_sales,
	LEAD(total_sales) OVER (ORDER BY order_month) - total_sales AS sales_difference
FROM MonthlySales
ORDER BY order_month;

----Method3: Using both LEAD() and LAG() - This shows previous month, current month, and next month in a single result.
WITH MonthlySales AS (
	SELECT DATE_TRUNC('month', order_date) AS order_month,
		ROUND(SUM(sales)::numeric, 2) AS total_sales
	FROM superstore
	GROUP BY DATE_TRUNC('month', order_date)
)

SELECT
    order_month,
    total_sales,
    LAG(total_sales) OVER (ORDER BY order_month) AS previous_month_sales,
    LEAD(total_sales) OVER (ORDER BY order_month) AS next_month_sales
FROM MonthlySales
ORDER BY order_month;



