-- Get an overview of the Data
select * from swiggy
limit 10;

-- get the total rows of Data 
select count(*) from swiggy;

-- 01 HOW MANY RESTAURANTS HAVE A RATING GREATER THAN 4.5?
select count(DISTINCT restaurant_name) as high_rated_restaurants from swiggy
where rating > 4.5;

-- Get the restaurant names as well
select DISTINCT restaurant_name,rating,cost_per_person  from swiggy
where rating > 4.5
order by cost_per_person desc;

-- 02 WHICH IS THE TOP 1 CITY WITH THE HIGHEST NUMBER OF RESTAURANTS?

select city,count(distinct restaurant_name) as number_of_restaurants
from swiggy
group by city
order by number_of_restaurants desc 
limit 1;

-- 03 HOW MANY RESTAURANTS SELL( HAVE WORD "PIZZA" IN THEIR NAME)?

select * from swiggy
limit 10;

select count(distinct restaurant_name) as Selling_pizza 
from swiggy
where restaurant_name like '%pizza%'
limit 5;

-- 04 WHAT IS THE MOST COMMON CUISINE AMONG THE RESTAURANTS IN THE DATASET?
select cuisine, count(*) as number_rest
from swiggy
group by cuisine
order by number_rest desc;

-- shows the distinct restaurants with most comman cuisine
select cuisine, count(distinct restaurant_name) as number_rest
from swiggy
group by cuisine
order by number_rest desc;

-- 05 WHAT IS THE AVERAGE RATING OF RESTAURANTS IN EACH CITY?
select city, avg(rating) as avg_rating
from swiggy
group by city
limit 5;

-- 06 WHAT IS THE HIGHEST PRICE OF ITEM UNDER THE 'RECOMMENDED' MENU CATEGORY FOR EACH RESTAURANT?
select restaurant_name, menu_category,max(price) as most_expensive
from swiggy
where menu_category = 'RECOMMENDED'
group by restaurant_name, menu_category;

-- 07 FIND THE TOP 5 MOST EXPENSIVE RESTAURANTS THAT OFFER CUISINE OTHER THAN INDIAN CUISINE. 
select distinct restaurant_name, cost_per_person
from swiggy
where cuisine <> 'INDIAN'
order by cost_per_person desc
limit 5;

-- 08 FIND THE RESTAURANTS THAT HAVE AN AVERAGE COST WHICH IS HIGHER THAN THE TOTAL AVERAGE COST OF ALL    
-- RESTAURANTS TOGETHER.

select * from swiggy
limit 10;

-- USING SUBQUERY
select distinct restaurant_name,cost_per_person
from swiggy
where cost_per_person > (select avg(cost_per_person) as total_avg_cost
				  from swiggy);

				
-- USING CTE
with avg_rest as (
					select restaurant_name,avg(cost_per_person) as avg_cost
					from swiggy
					group by restaurant_name
),
total as (
				  select avg(cost_per_person) as total_avg_cost
				  from swiggy
)					
select distinct restaurant_name,a.avg_cost,t.total_avg_cost from avg_rest a
join total t
ON a.avg_cost  > t.total_avg_cost;

-- 09 RETRIEVE THE DETAILS OF RESTAURANTS THAT HAVE THE SAME NAME BUT ARE LOCATED IN DIFFERENT CITIES.

select distinct t1.restaurant_name, t1.city, t2.city
from swiggy t1 join swiggy t2
ON t1.restaurant_name = t2.restaurant_name
and t1.city <> t2.city; 

-- 10 WHICH RESTAURANT OFFERS THE MOST NUMBER OF ITEMS IN THE 'MAIN COURSE' CATEGORY?
select * from swiggy
limit 10;

select  distinct restaurant_name
from swiggy;

select distinct restaurant_name, count(item) as max_items
from swiggy
where menu_category = 'MAIN COURSE'
group by restaurant_name
order by max_items desc
limit 1;

-- 11 LIST THE NAMES OF RESTAURANTS THAT ARE 100% VEGEATARIAN IN ALPHABETICAL ORDER OF RESTAURANT NAME

-- below query is incorrect
select distinct restaurant_name,veg_or_nonveg
from swiggy
where veg_or_nonveg = 'Veg';

/* 
below query show that a restaurant has both 'Veg' and 'Non-veg' option from data table. Therfore, a basic query cannot be used to solve this question.

Exmaple :
'Tandoor Hut', 'Non-veg'
'Tandoor Hut', 'Veg'
*/

select distinct restaurant_name,veg_or_nonveg
from swiggy
group by veg_or_nonveg,restaurant_name;

-- ACTUAL Query
select distinct restaurant_name,
	(count(case when veg_or_nonveg = 'Veg' THEN 1 end)*100/count(*)) as veg_percentage
from swiggy
group by restaurant_name
having veg_percentage = 100.00
order by restaurant_name;

-- 12 WHICH IS THE RESTAURANT PROVIDING THE LOWEST AVERAGE PRICE FOR ALL ITEMS?
select restaurant_name, round(avg(price) ,2)as avg_price_per_restautant
from swiggy
group by restaurant_name
order by avg_price_per_restautant
limit 1;

-- 13 WHICH TOP 5 RESTAURANT OFFERS HIGHEST NUMBER OF CATEGORIES?
select restaurant_name, count(distinct menu_category) as most_variety
from swiggy
group by restaurant_name
order by most_variety desc
limit 5;

-- 14 WHICH RESTAURANT PROVIDES THE HIGHEST PERCENTAGE OF NON-VEGEATARIAN FOOD?
select * from swiggy
limit 10;

select distinct restaurant_name,
					count(case when veg_or_nonveg = 'veg' then 'it is veg' end) as veg_food,
                    count(case when veg_or_nonveg = 'non-veg' then 'it is non-veg' end) as non_veg_food
from swiggy
group by restaurant_name;

select distinct restaurant_name,
					(count(case when veg_or_nonveg = 'veg' then 1 end)*100/count(*)) as veg_food,
                    (count(case when veg_or_nonveg = 'non-veg' then 1 end)*100/count(*)) as non_veg_food
from swiggy
group by restaurant_name
order by non_veg_food desc;

select distinct restaurant_name,
					(count(case when veg_or_nonveg = 'non-veg' THEN 1 end)*100/count(*)) as non_veg_percentage
from swiggy
group by restaurant_name
order by non_veg_percentage desc
limit 1;

-- 15 Determine the Most Expensive and Least Expensive Cities for Dining:
select * from swiggy
limit 10;

select city, max(cost_per_person) as most_expensive, min(cost_per_person) as least_expensive
from swiggy
group by city
order by most_expensive desc;

-- using CTE
with CityExpense as (
select city,
		max(cost_per_person) as most_expensive, 
        min(cost_per_person) as least_expensive
from swiggy
group by city
)
select * 
from CityExpense
order by most_expensive desc;


-- 16 Calculate the Rating Rank for Each Restaurant Within Its City

with Restaurant_ranking as (
select distinct restaurant_name,city,rating,
	   dense_rank() over(partition by city order by rating desc) as ranking
from swiggy
)
select restaurant_name,city,rating,ranking
from Restaurant_ranking
where ranking = 1;