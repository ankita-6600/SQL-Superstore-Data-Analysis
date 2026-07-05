FROM/JOIN >> WHERE >> GROUP BY >> HAVING >> SELECT >> DISTINCT >> ORDER BY >> LIMIT/OFFSET

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
