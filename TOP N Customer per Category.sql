-- Write a query to find TOP 3 customers per category using ROW_NUMER()
WITH CustomerCategorySales AS (
	SELECT category, customer_id, customer_name,
		ROUND(SUM(sales)::numeric, 2) AS total_sales
	FROM superstore
	GROUP BY category, customer_id, customer_name
),
RankedCustomers AS (
	SELECT category, customer_id, customer_name, total_sales,
		ROW_NUMBER() OVER (PARTITION BY category ORDER BY total_sales DESC) AS rn
	FROM CustomerCategorySales
)

SELECT category, customer_id, customer_name, total_sales
FROM RankedCustomers
WHERE rn <= 3
ORDER BY category, rn;