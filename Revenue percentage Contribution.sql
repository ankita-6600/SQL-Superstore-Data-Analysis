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