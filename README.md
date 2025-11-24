# Pizza Sales Dashboard

**A data-driven Tableau dashboard built from a MySQL pizza sales dataset** — visualize sales trends, top performers, category breakdowns and operational KPIs to optimize inventory, promotions and store-hours strategy.

---

## Preview

![Dashboard overview](/mnt/data/5d29cd1b-0b50-481c-9c12-77b5628f3c14.png)

![Detailed view](/mnt/data/b2272fae-0498-497d-90f5-e2b04f424a72.png)

---

## Table of Contents

1. Project Overview
2. Key Features & KPIs
3. Data Model (table: `pizza_sales`)
4. SQL Queries (ready-to-run)
5. How to Reproduce
6. Dashboard Design Notes & Insights
7. Recommendations
8. License & Contact

---

## 1. Project Overview

This project transforms raw pizza order data stored in MySQL into a polished Tableau dashboard that helps stakeholders quickly answer business questions such as:

* Which pizzas generate the most revenue and orders?
* What are peak hours and busiest weeks for operations?
* How does pizza size & category contribute to revenue?
* Which SKUs should we promote or deprecate?

The dashboard surfaces high-level KPIs, trends (hourly, weekly), distribution charts, and top/bottom sellers by revenue, quantity and orders.

---

## 2. Key Features & KPIs

**KPIs shown**

* Total Revenue
* Average Order Value (AOV)
* Total Pizzas Sold
* Total Orders
* Average Pizzas per Order

**Interactive visuals**

* Hourly stacked bars for pizzas sold (by category)
* Weekly orders trend (line/area)
* Donut chart for category revenue split
* Bar charts: Top 5 / Bottom 5 by Revenue, Quantity, Orders
* Size distribution (Large, Medium, Small, etc.)
* Side panel: business context and takeaways

---

## 3. Data Model

**Primary table:** `pizza_sales`

Typical columns (example):

* `order_id` (string / int) — unique order identifier
* `order_date` (DATE) — date of order
* `order_time` (TIME) — time of order
* `pizza_name` (VARCHAR) — SKU / pizza name
* `pizza_category` (VARCHAR) — e.g. Classic, Chicken, Supreme, Veggie
* `pizza_size` (VARCHAR) — e.g. Small, Medium, Large, X-Large
* `quantity` (INT) — number of pizzas in the row
* `unit_price` (DECIMAL) — per pizza price
* `total_price` (DECIMAL) — quantity * unit_price (or invoice-level price)
* other columns: `store_id`, `customer_id`, `discount`, `payment_type` (optional)

> Adjust column names/types to match your source CSV/ETL.

---

## 4. SQL Queries (ready-to-run)

Below are the core SQL queries used to power the dashboard. They assume your `order_date` is a `DATE` type and `order_time` is `TIME`.

```sql
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

-- Average Pizzas Per Order
select round(sum(quantity) / count(distinct order_id), 2) as Avg_Pizzas_per_order
from pizza_sales;

-- Hourly Trend for Total Pizzas Sold
select extract(hour from order_time) as Hours, sum(quantity) as Total_pizzas_sold
from pizza_sales
group by extract(hour from order_time)
order by extract(hour from order_time);

-- Weekly Trend for Total Orders
select extract(week from order_date) as week_num, extract(year from order_date) as year_num,
       count(distinct order_id) as total_orders
from pizza_sales
group by 1, 2
order by 1, 2;

-- Percentage of Sales by Pizza Category
select pizza_category, round(sum(total_price), 2) as total_revenue,
       round(sum(total_price) * 100/ (select sum(total_price) from pizza_sales), 2) as pcat_split
from pizza_sales
group by 1
order by 3 desc;

-- Percentage of Sales by Pizza Size
select pizza_size, round(sum(total_price), 2) as total_revenue,
       round(sum(total_price)*100/ (select sum(total_price) from pizza_sales), 2) as psize_split
from pizza_sales
group by 1
order by 3 desc;

-- Top 5 Best Sellers by Revenue
select pizza_name, round(sum(total_price), 2) as total_revenue
from pizza_sales
group by 1
order by 2 desc
limit 5;

-- Bottom 5 Best Sellers by Revenue
select pizza_name, round(sum(total_price), 2) as total_revenue
from pizza_sales
group by 1
order by 2
limit 5;

-- Top 5 Best Sellers by Quantity
select pizza_name, sum(quantity) as total_pizzas_sold
from pizza_sales
group by 1
order by 2 desc
limit 5;

-- Top 5 Best Sellers by Total Orders
select pizza_name, count(distinct order_id) as total_orders
from pizza_sales
group by 1
order by 2 desc
limit 5;
```

> Tip: If your `order_date` is stored as `VARCHAR` in `dd-mm-yyyy` format, convert it before analyses:

```sql
update pizza_sales
set order_date = str_to_date(order_date, '%d-%m-%Y');
alter table pizza_sales modify order_date DATE;
alter table pizza_sales modify order_time TIME;
```

---

## 5. How to Reproduce

### Prerequisites

* MySQL (or compatible) instance
* Tableau Desktop (or Tableau Public) for dashboarding
* CSV / raw data file (example: `pizza_sales.csv`)

### Steps

1. Create the database & table:

```sql
create database Pizza_DB;
use Pizza_DB;
-- create table `pizza_sales` (match your columns to the schema above)
```

2. Import CSV into `pizza_sales` (MySQL Workbench / `LOAD DATA INFILE` / GUI import).
3. Clean dates if required (see conversion tip above).
4. Connect Tableau to your MySQL database (Tableau → Connect → MySQL).
5. Build the following extracts/calculations in Tableau:

   * `Hour` = HOUR([order_time])
   * `Week` = WEEK([order_date])
   * `AOV` = SUM([total_price]) / COUNTD([order_id])
6. Create sheets and layout described in the dashboard screenshots and publish or export the workbook.

---

## 6. Dashboard Design Notes & Insights

* Use stacked bars by category for hourly pizza mix to understand SKU composition across dayparts.
* Smoothing weekly trend lines highlights seasonal peaks (e.g. holidays or December spikes).
* Donut charts work well for communicating category splits while leaving center space for overall revenue.
* Show numerical KPIs with clear units (K for thousands) and consistent rounding.

**Observed business signals (from the dashboard sample):**

* Peak lunch and dinner hours create a clear two-peak pattern — optimize staffing accordingly.
* Classic and Large-size pizzas contribute the highest share of revenue.
* Certain SKUs (top 5) drive a disproportionate share of revenue — consider focused promotions.

---

Happy to help — tell me which next step you want! 🎯
