FROM/JOIN >> WHERE >> GROUP BY >> HAVING >> SELECT >> DISTINCT >> ORDER BY >> LIMIT/OFFSET

-- Write TOP 10 products by revenue query.
select product_name,
	product_id,
	SUM(sales) as revenue 
from superstore
group by product_name,product_id
order by revenue desc
LIMIT 10;

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

-- Write Best/Worst Region Performance query. 
---------(Based on the metric: Profit,Sales,Profit Margin,Growth, etc)
select * from superstore;

------Based on sales
WITH RegionSales AS(
	SELECT region,
		SUM(sales) AS total_sales 
	FROM superstore
	GROUP BY region
),

RankedRegions AS(
	SELECT region, total_sales,
		RANK() OVER (ORDER BY total_sales DESC) AS sales_rank_desc,
		RANK() OVER (ORDER BY total_sales ASC) AS sales_rank_asc
	FROM RegionSales
)

SELECT region,total_sales,
	(CASE
		WHEN sales_rank_desc = 1 THEN 'Best Performing Region'
		WHEN sales_rank_asc = 1 THEN 'Worst Performing Region'
	END) AS performance
FROM RankedRegions
WHERE sales_rank_desc = 1
OR sales_rank_asc = 1;

------Based on Profit
WITH RegionProfit AS(
	SELECT region,SUM(profit) AS total_profit FROM superstore
	GROUP BY region
),

RankedRegions AS(
	SELECT region, total_profit,
		RANK() OVER (ORDER BY total_profit DESC) AS profit_rank_desc,
		RANK() OVER (ORDER BY total_profit ASC) AS profit_rank_asc
	FROM RegionProfit
)

SELECT region,total_profit,
	CASE
		WHEN profit_rank_desc = 1 THEN 'Best Performing Region'
		WHEN profit_rank_asc = 1 THEN 'Worst Performing Region'
	END AS performance
FROM RankedRegions
WHERE profit_rank_desc = 1
OR profit_rank_asc = 1;


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

-- Write Revenue % Contribution using Window function.
------Revenue % by Region
SELECT region,SUM(sales) as region_revenue,
	ROUND(
		(SUM(sales) * 100.00/SUM(SUM(sales)) OVER ())::numeric
	, 2) AS revenue_contribution_percent
FROM superstore
GROUP BY region
ORDER BY region_revenue DESC;
-- SUM(SUM(sales)) OVER () - Gives the total revenue (grand total revenue)

-- Write Running Total using SUM() OVER

SELECT month_wise,running_total FROM (
	SELECT TO_CHAR(order_date,'YYYY-MM') AS month_wise,
		sales,
		ROUND(SUM(sales) OVER (ORDER BY TO_CHAR(order_date,'YYYY-MM'))::numeric,2) AS running_total
	FROM superstore) t
GROUP BY month_wise,running_total
ORDER BY month_wise;

-- Write Product ranking using RANK().
select * from superstore;

WITH product_revenue AS (
	SELECT product_name,
		category,
		SUM(sales) as total_revenue 
	FROM superstore
	GROUP BY product_name,category
	)

SELECT product_name,
	category,
	total_revenue,
	RANK() OVER (ORDER BY total_revenue DESC) AS rank_over_sales,
	RANK() OVER (PARTITION BY category ORDER BY total_revenue DESC) AS rank_partition_category_over_sales
FROM product_revenue;

-- Write LAG() query for inactive customers.
select * from superstore

----- First Query
WITH OrderGaps AS (
    SELECT
        customer_id,
        order_date,
        LAG(order_date) OVER (
            PARTITION BY customer_id
            ORDER BY order_date
        ) AS prev_order_date
    FROM superstore
)

SELECT
    customer_id,
    prev_order_date,
    order_date,
    (order_date - prev_order_date) AS inactive_days,
    'Inactive_Customer' AS customer_status
FROM OrderGaps
WHERE (order_date - prev_order_date) > 180
ORDER BY customer_id, order_date;