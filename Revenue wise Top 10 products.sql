-- Write TOP 10 products by revenue query.
select product_name,
	product_id,
	SUM(sales) as revenue 
from superstore
group by product_name,product_id
order by revenue desc
LIMIT 10;