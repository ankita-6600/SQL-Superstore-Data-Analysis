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
