# Pizza Sales Database
-- creating database for Pizza Sales (Pizza_DB).
create database Pizza_DB;

-- get info about datatypes of columns.
describe pizza_sales;

-- updating the date format of order_date column.
update pizza_sales
set order_date = str_to_date(order_date, "%d-%m-%Y");

-- modifying the datatype of order_date column to date.
alter table pizza_sales
modify order_date Date;

-- modifying the datatype of order_time column to time.
alter table pizza_sales
modify order_time Time;

-- to view the data of the pizza_sales table(48620 rows)
select * from pizza_sales;


# KPIs
# Requirements.


-- Total revenue
select round(sum(total_price), 3) as Total_Revenue
from pizza_sales;


-- Average Order Value
select round(sum(total_price)/count(distinct order_id), 3) as Avg_order_Value 
from pizza_sales;


-- Total Pizzas sold
select sum(quantity) as Total_pizza_sold from pizza_sales;


-- Total Orders
select count(distinct order_id) as Total_orders from pizza_sales;


-- Average Pizzas Per Order:
select 
	round(sum(quantity) / count(distinct order_id), 2) as Avg_Pizzas_per_order
from pizza_sales;


-- Hourly Trend for Total Pizzas Sold
select 
	extract(hour from order_time) as Hours, 
	sum(quantity) as Total_pizzas_sold
from pizza_sales
group by extract(hour from order_time)
order by extract(hour from order_time);


-- Weekly Trend for Total Orders
select 
	extract(week from order_date) as week_num, 
	extract(year from order_date) as year_num,
    count(distinct order_id) as total_orders
from pizza_sales
group by 1, 2
order by 1, 2;


-- Yearly, Weekly, Monthly Pizza Orders Trends
select 
	extract(year from order_date) as yr,
    extract(month from order_date) as mth,
    extract(week from order_date) as weekNum,
    round(count(distinct order_id), 2) as total_revenue
from pizza_sales
group by 1, 2, 3
order by 1, 2, 3;

select * from pizza_sales;
-- Percentage of Sales by Pizza Category
select 
	pizza_category, 
    round(sum(total_price), 2) as total_revenue,
    round(sum(total_price) * 100/ (select sum(total_price) from pizza_sales), 2) as pcat_split
from pizza_sales
group by 1
order by 3 desc;


-- Percentage of Sales by Pizza Size
select 
	pizza_size,
    round(sum(total_price), 2) as total_revenue,
    round(sum(total_price)*100/ (select sum(total_price) from pizza_sales), 2) as psize_split
from pizza_sales
group by 1
order by 3 desc;


-- Total Pizzas Sold by Pizza Category
select 
	pizza_category,
    sum(quantity) as total_pizzas_sold
from pizza_sales
group by 1
order by 2 desc;


-- Top 5 Best Sellers by Revenue
select
	pizza_name,
	round(sum(total_price), 2) as total_revenue
from pizza_sales
group by 1
order by 2 desc
limit 5;


-- Bottom 5 Best Sellers by Revenue
select
	pizza_name,
	round(sum(total_price), 2) as total_revenue
from pizza_sales
group by 1
order by 2
limit 5;

-- Top 5 Best Sellers by Quantity
select 
	pizza_name,
	sum(quantity) as total_pizzas_sold
from pizza_sales
group by 1
order by 2 desc
limit 5;


-- Bottom 5 Best Sellers by Quantity
select 
	pizza_name,
	round(sum(quantity), 2) as total_pizzas_sold
from pizza_sales
group by 1
order by 2 
limit 5;


-- Top 5 Best Sellers by Total Orders
select
	pizza_name,
    count(distinct order_id) as total_orders
from pizza_sales
group by 1
order by 2 desc
limit 5;


-- Bottom 5 Best Sellers by Total Orders
select
	pizza_name,
    count(distinct order_id) as total_orders
from pizza_sales
group by 1
order by 2 
limit 5;