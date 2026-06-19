--data analysis

-- Q1. Find the top 10 best-value products based on the discount percentage.
	SELECT name, mrp, discountpercent
	FROM zepto
	ORDER BY discountpercent DESC
	LIMIT 10;

--Q2.What are the Products with High MRP but Out of Stock
	SELECT DISTINCT name, mrp, outofstock
	FROM zepto
	WHERE outofstock = 'true' and mrp > 300
	ORDER BY mrp ;
	
