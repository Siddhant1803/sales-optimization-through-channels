create database SupplyChain;

SELECT * FROM supplychain.beverage_sales_data;

## 1. Sales Volume : Total units sold, reflecting market demand.
select format_number(sum(order_qty)) as Sales_Volume from beverage_sales_data;

## 2. Monthly Sales Trends

SELECT 
	DATE_FORMAT(dt_transaction, '%Y-%m') AS month, 
	format_number(SUM(sales)) AS total_sales
from beverage_sales_data
GROUP BY month
order by month asc;

## 3. Top selling product

SELECT 
	product_item_id,
    format_number(SUM(order_qty)) AS total_sales_volume
FROM 
	beverage_sales_data
group by 
	product_item_id
ORDER BY 
	total_sales_volume DESC
LIMIT 10;

## 4. slow moving products
SELECT 
	product_item_id,
    format_number(SUM(order_qty)) AS total_sales_volume
FROM 
	beverage_sales_data
group by 
	product_item_id
ORDER BY 
	total_sales_volume asc
LIMIT 10;
 
## 5. order frequency 

SELECT 
	DATE(dt_transaction) AS date, 
    COUNT(*) AS order_count
FROM 
	beverage_sales_data
GROUP BY date 
order by date asc;

## 6. Market Penetration Rate: Percentage of new products sold compared to all products, indicating success of launches.

select 
    (select sum(order_qty) from beverage_sales_data
     where new_product_tag = "New")
    /
    (select sum(order_qty) from beverage_sales_data) * 100
    as New_Product_Order_Pct;


## 7. Discount Impact: Average discount provided and its effect on sales volume and profitability.
#discount is not given when ordered quantity is less that 50

#discount is given when ordered quantity is greater than 50
select format_number(sum(order_qty)) as sales_volume_without_discount, 
	   format_number(sum(profit)) as profit_with_discount
       from beverage_sales_data
	   where discount = 0; 

#Combine effect of discount on sales volume and profit 
select sum(order_qty) as sales_volume_with_discount, 
	   sum(profit) as profit_with_discount
       from beverage_sales_data
	   where discount in (5,8,10);
       

## 8. Product Mix Diversity: Variety of products sold, indicating market reach and consumer preference diversity.

SELECT 
    product_item_id AS Distinct_Product, 
    SUM(order_qty) AS Sales_Volume,
    CONCAT(ROUND(SUM(order_qty) / (SELECT SUM(order_qty) FROM beverage_sales_data) * 100, 2), '%') AS Percentage_Of_Total_Sales
FROM 
    beverage_sales_data
GROUP BY 
    product_item_id
order by 
	Percentage_Of_Total_Sales desc;


## 9.Geographic Market Share: Sales distribution across different regions, showing market dominance.

#Sales by country
SELECT 
    country,
    FORMAT_NUMBER(SUM(sales)) AS Total_Sales,
    FORMAT_NUMBER(SUM(profit)) AS Total_Profits
FROM
    beverage_sales_data
GROUP BY country
ORDER BY Total_Sales;
    
#sales by state
select
    state,
    format_number(sum(sales)) as Total_Sales, 
    format_number(sum(profit)) as Total_Profits
from 
	beverage_sales_data
group by 
	state
order by
	Total_Sales;
    
#sales by city
select
    city,
    format_number(sum(sales)) as Total_Sales, 
    format_number(sum(profit)) as Total_Profits
from 
	beverage_sales_data
group by 
	city
order by
	Total_Profits;
    
## 10. Sales Channel Effectiveness: Performance of different sales channels in terms of volume and profitability.
select 
	sales_channel,
    format_number(sum(sales)) as Sales_Volume,
    format_number(sum(profit)) as Profits
from 
	beverage_sales_data
group by 
	sales_channel
order by 
	Sales_Volume;
    
 
    
## 11. How different channels of distribution are contributing to overall sales.

select 
	channel_type,
    format_number(sum(sales)) as Total_sales
from
	beverage_sales_data
group by
	channel_type
order by 
	Total_sales asc;
    

## 12. What are the top brands selling across each channel?
 
select
	brand,
    format_number(sum(order_qty)) as Total_quantity_sold 
from beverage_sales_data
group by brand 
order by Total_quantity_sold
limit 5;


## 13. How is our cost per unit and average margin percentage distributed across channels?

select 
	channel_type,
	cost_per_unit,
    avg(margin_percentage)
from beverage_sales_data
group by channel_type;


## 14. What kind of packaging is making the most profit across different channels? 
##     Is there any packaging type that we need to consider?


SELECT 
    channel_type,
    packaging_type,
    SUM(profit) AS total_profit
FROM 
    beverage_sales_data
GROUP BY 
	channel_type,
    packaging_type
ORDER BY 
    total_profit DESC;
    
## 15. How are tetra packs performing across the country in terms of Sales and Profits?

SELECT
    country,
    state,
    city,
    SUM(order_qty) AS total_sales_quantity,
    SUM(sales) AS total_sales_value,
    SUM(profit) AS total_profit
FROM 
    beverage_sales_data
WHERE 
    packaging_type = 'TETRAPACKS'
GROUP BY 
    country, state, city
ORDER BY 
    total_profit DESC;