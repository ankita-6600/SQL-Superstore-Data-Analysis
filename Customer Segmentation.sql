-- Write Customer Segmentation query.
select * from superstore

WITH customer_base AS (
	SELECT customer_id,
		SUM(sales) AS total_revenue,
		COUNT(order_id) AS total_orders 
	FROM superstore
	GROUP BY customer_id
	),

	customer_segment AS (
	SELECT customer_id,total_revenue,
		(CASE
			WHEN total_revenue >= 1000 THEN 'VIP Customers'
			WHEN total_revenue >= 500 THEN 'High Value Customers'
			WHEN total_orders >= 5 THEN 'Regular Customers'
			ELSE 'Low Value Customers'
		END) AS segments
	FROM customer_base		
	)

SELECT segments,COUNT(customer_id) AS customer_count,
	ROUND(SUM(total_revenue)::numeric, 2) AS total_revenue,
	ROUND(AVG(total_revenue)::numeric, 2) AS avg_revenue_per_customer
FROM customer_segment
GROUP BY segments
ORDER BY total_revenue DESC;