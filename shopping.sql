create database customer_behavior;
use customer_behavior;
select *from customer;

##1what is thetotal revnue genrated by male vs.female customer
select gender ,sum(purchase_amount)as Revenue
from customer
group by Gender;

##2which customer used discount but still spent more than the average purchase amount
select customer_id,purchase_amount
from customer
where Discount_Applied='yes' and
purchase_amount>=(select avg(purchase_amount) from customer);

##3which are the top5 product with highest rating
select item_purchased,round(avg(review_rating),2)
from customer
group by item_purchased
order by avg(review_rating)desc limit 5;

##4compare avrage purchase amount between standard and express shipping
select shipping_type ,round(avg(Purchase_Amount),2)
from customer
where shipping_type in('standard','express')
group by Shipping_Type;

##5 Do subscribe customer spent more?compare average spend & total revenue between suscribers and non suscribers
select subscription_status,
round(avg(purchase_amount),2)as avg_spend,
round(sum(purchase_amount),2)as revenue
from customer
group by subscription_status
order by revenue,avg_spend;

##6which 5 products havethe highest percentage of purchase amount with discount applied
select item_purchased,
sum(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS discount_rate
from customer
group by item_purchased
order by discount_rate DESC
LIMIT 5;

##7Segment customers into new,returning and loya based on their  total no. of previous purchases,
## show the count of each segment ##here we are classifing to diffrent segments based on pp
with customer_type as(select customer_id,Previous_Purchases,
CASE 
WHEN Previous_Purchases  =1 THEN 'new'
WHEN Previous_Purchases BETWEEN 2 AND 10 THEN 'Returning'
ELSE 'Loyal'
END AS customer_segment
from customer)
select customer_segment,count(*)as "No. of customers"
from customer_type
group by customer_segment;

##8 what are the top3 most purchased productes within each category
with item_counts as (
select category ,item_purchased,
COUNT(customer_id) as total_orders,
ROW_NUMBER() over(partition by category order by count(customer_id)desc)as item_rank
from customer
group by category,item_purchased)
select item_rank,category,item_purchased,total_orders
from item_counts
where item_rank<=3;

##9Are customers who are repeat (more tan 5 pp)buyers also likely to subscribe
select subscription_status,
count(customer_id)as repeat_buyers
from customer
where Previous_Purchases>5
group by subscription_status;

##10 what is the revenue contribution of each age group?
select age_group,sum(purchase_amount)as revenue
from customer
group by age_group
order by revenue desc;
