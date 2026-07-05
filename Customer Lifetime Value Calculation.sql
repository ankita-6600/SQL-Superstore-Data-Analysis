-- Write CTE for Customer Lifetime Value.
-----Method1: With CTE
WITH CustomerLifetimeValue AS (
	SELECT customer_id, customer_name,
		COUNT(DISTINCT order_id) AS total_orders,
		ROUND(SUM(sales)::numeric, 2) AS lifetime_revenue,
		ROUND(SUM(profit)::numeric, 2) AS lifetime_profit,
		ROUND(AVG(sales)::numeric, 2) AS avg_order_value,
		MIN(order_date) AS first_order_date,
		MAX(order_date) AS last_order_date
	FROM superstore
	GROUP BY customer_id, customer_name
)

SELECT * FROM CustomerLifetimeValue
ORDER BY lifetime_revenue DESC;

----Method2: Without CTE
SELECT customer_id, customer_name,
	COUNT(DISTINCT order_id) AS total_orders,
	ROUND(SUM(sales)::numeric, 2) AS lifetime_revenue,
	ROUND(SUM(profit)::numeric, 2) AS lifetime_profit,
	ROUND(AVG(sales)::numeric, 2) AS avg_order_value,
	MIN(order_date) AS first_order_date,
	MAX(order_date) AS last_order_date
FROM superstore
GROUP BY customer_id, customer_name
ORDER BY lifetime_revenue DESC;

----Method3: Using Window Function 
-- (If you want to show every order while also displaying the customer's lifetime revenue on each row:)
SELECT customer_id, customer_name, order_id, order_date, sales, 
	ROUND(SUM(sales) OVER (PARTITION BY customer_id)::numeric, 2) AS lifetime_revenue
FROM superstore;

----Method4: Using a Temporary Table.
-- This is helpful if you'll reuse the results multiple times in the same session.
CREATE TEMP TABLE customer_clv AS 
	SELECT customer_id, customer_name, 
		ROUND(SUM(sales)::numeric, 2) AS lifetime_revenue
	FROM superstore
	GROUP BY customer_id, customer_name;

SELECT * FROM customer_clv
ORDER BY lifetime_revenue DESC;

----Also Segment the customers by the lifetime revenue.
WITH CustomerLifeTimeValue AS (
	SELECT customer_id, customer_name, 
		ROUND(SUM(sales)::numeric, 2) AS lifetime_revenue
	FROM superstore
	GROUP BY customer_id, customer_name
)

SELECT customer_id, customer_id, lifetime_revenue,
	CASE 
		WHEN lifetime_revenue >= 10000 THEN 'High Value Customer'
		WHEN lifetime_revenue >= 5000 THEN 'Medium Value Customer'
		ELSE 'Low Value Customer'
	END
FROM CustomerLifeTimeValue
ORDER BY lifetime_revenue DESC;

