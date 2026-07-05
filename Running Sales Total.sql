-- Write Running Total using SUM() OVER

SELECT month_wise,running_total FROM (
	SELECT TO_CHAR(order_date,'YYYY-MM') AS month_wise,
		sales,
		ROUND(SUM(sales) OVER (ORDER BY TO_CHAR(order_date,'YYYY-MM'))::numeric,2) AS running_total
	FROM superstore) t
GROUP BY month_wise,running_total
ORDER BY month_wise;