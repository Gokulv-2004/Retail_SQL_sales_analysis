use retail_project;
select * from retail_sales limit 10;

show columns  from retail_sales;
select * from retail_sales where age is null ;
select * from retail_sales where sale_date is null ;

-- DATA Cleaning --

SELECT 
    *
FROM
    retail_sales
WHERE
    transactions_id IS NULL
        OR sale_date IS NULL
        OR Sale_time IS NULL
        OR customer_id IS NULL
        OR gender IS NULL
        OR age IS NULL
        OR category IS NULL
        OR quantiy IS NULL
        OR price_per_unit IS NULL
        OR cogs IS NULL
        OR total_sale IS NULL; 
        
        --- deleting nuLL columns (3 columns ) ---
        
delete 
FROM
    retail_sales
WHERE
    transactions_id IS NULL
        OR sale_date IS NULL
        OR Sale_time IS NULL
        OR customer_id IS NULL
        OR gender IS NULL
        OR age IS NULL
        OR category IS NULL
        OR quantiy IS NULL
        OR price_per_unit IS NULL
        OR cogs IS NULL
        OR total_sale IS NULL; 
        
#-- data exploration --


-- how many  sales have  done 
select count(*) as Total_sales  from retail_sales ;

-- how many unique customer we have 
select count( distinct customer_id) as Total_customer  from retail_sales ;

-- how many catergory 
select distinct category as Category  from retail_sales ;


-- DATA ANALYSIS // PROBLEM  TO SOLVE 
--  1 . Write a sql Query to retrieve all columns for sales mad on "2022 -11-05 "
SELECT 
    *
FROM
    retail_sales
WHERE
    sale_date = '2022-11-05 '; 

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and  in the month of Nov-2022
SELECT 
    *
FROM
    retail_sales
WHERE
    category = 'clothing'
        AND sale_date LIKE '2022-11-%';  

-- Q.2(A) Write a SQL query to retrieve all transactions where the category is 'Clothing' 
-- and the quantity sold is less than 10 in the month of Nov-2022
SELECT 
    *
FROM
    retail_sales
WHERE
    category = 'clothing' AND quantiy <= 10
        AND sale_date LIKE '2022-11-%';  

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
    category, SUM(total_sale) AS Total_sales ,
    count(*) as total_Orders
FROM
    retail_sales
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT 
    gender, ROUND(AVG(age) ,2) as AVG_AGE
FROM
    retail_sales
WHERE
    category = 'Beauty'
GROUP BY 1;


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT 
    *
FROM
    retail_sales
WHERE
    total_sale >= 1000;
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
    category, gender, COUNT(*) AS Total_Trans
FROM
    retail_sales
GROUP BY category , gender 
order by 1;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT sales_year, month_no, avg_sale
FROM (
    SELECT
        YEAR(sale_date) AS sales_year,
        MONTH(sale_date) AS month_no,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (
            PARTITION BY YEAR(sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS sales_rank
    FROM retail_sales
    GROUP BY 1, 2
) AS t1
WHERE sales_rank = 1;
    
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
select customer_id ,
sum(total_sale) as Total_sales
 from retail_sales 
 group by 1 order by 2 desc limit 5 ;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
 select
 category,
 count( distinct(customer_id)) 
  from retail_sales 
  group by category;
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
with Hourly_sales
as (
select * , 
case 
	when extract(hour from sale_time ) <12 then 'morning'
    when extract( hour from sale_time) between 12 And 17 then 'Afternoon '
    else ' Evening '
    end as Shift 
     from retail_sales 
    ) 
    select 
    shift , 
    count(*)  as total_order 
    from Hourly_sales 
    group by shift 
   

