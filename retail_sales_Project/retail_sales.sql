 -- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
         SELECT * FROM retail_sales 
		 WHERE sale_date = '2022-11-05';
		 
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
         SELECT *
		FROM retail_sales
		WHERE category = 'Clothing'
		AND sale_date >= DATE '2022-11-01'
		AND sale_date < DATE '2022-12-01'
		AND quantity >= 4;
		 
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
         SELECT  sum(total_sale), category 
		 FROM retail_sales 
		 GROUP BY category;
 
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
        SELECT avg(age) AS age, 
		WHERE category = 'Beauty';
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
       SELECT * FROM retail_sales	   
	   WHERE total_sale > 1000;
	   
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
        SELECT category, gender,COUNT(*) as total_trans
		FROM retail_sales
		GROUP BY category, gender
		ORDER BY category;
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
        SELECT year,month,avg_sale
		FROM 
		(    
		SELECT 
		EXTRACT(YEAR FROM sale_date) as year,
		EXTRACT(MONTH FROM sale_date) as month,
		AVG(total_sale) as avg_sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
		FROM retail_sales
		GROUP BY year, month
		) as best
		WHERE rank = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
		SELECT customer_id,SUM(total_sale) as total_sales
		FROM retail_sales
		GROUP BY customer_id
		ORDER BY total_sales DESC
		LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
		SELECT category,COUNT(DISTINCT customer_id) as unique_cid
		FROM retail_sales
		GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
		WITH hourly_sale AS
		(
		SELECT *,
		CASE
			WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
			WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
		END as shift
		FROM retail_sales
		)
		SELECT shift,
		COUNT(*) as total_orders    
		FROM hourly_sale
		GROUP BY shift;

-- End of project

