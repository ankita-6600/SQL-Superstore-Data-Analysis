-- Write Month-over-Month Sales Growth query.
-- (MoM Growth % = ((Current Month Sales - Prev Month Sales)/prev month sales) * 100
WITH monthly_sales AS (
	SELECT TO_CHAR(order_date, 'YYYY-MM') AS year_month, 
		SUM(sales) AS total_sales
	FROM superstore
	GROUP BY TO_CHAR(order_date, 'YYYY-MM')
)

SELECT year_month,
	total_sales,
	LAG(total_sales,1) OVER (ORDER BY year_month) AS prev_month_sales,
	ROUND(((total_sales-LAG(total_sales,1) OVER (ORDER BY year_month))
		/LAG(total_sales,1) OVER (ORDER BY year_month))::numeric *100,2) AS MoM_Growth
FROM monthly_sales;