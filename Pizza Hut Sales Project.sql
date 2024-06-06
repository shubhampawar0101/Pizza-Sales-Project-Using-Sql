-- Q1)Retrieve the total number of orders placed
select count(order_id) from orders;

-- Q2) Calculate the total revenue generated from pizza sales.
select round(sum(pizzas.price * order_details.quantity),2) as total_sale 
from order_details
join pizzas on pizzas.pizza_id = order_details.pizza_id;

-- Q3) Identify the highest-priced pizza.
select pizza_types.name, pizzas.price
from pizza_types
join pizzas on pizzas.pizza_type_id = pizza_types.pizza_type_id
order by pizzas.price desc
limit 1;

-- Q4) Identify the most common pizza size ordered.
select pizzas.size, count(order_details.order_details_id) as order_count
from pizzas
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizzas.size
order by order_count desc
limit 1;

-- Q5) List the top 5 most ordered pizza types along with their quantities.
select pizza_types.name, sum(order_details.quantity) as total_quantity
from pizza_types 
join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id 
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name
order by total_quantity desc
limit 5;


-- Set 2) 
-- Q1) Join the necessary tables to find the total quantity 
--     of each pizza category ordered.
select pizza_types.category, sum(order_details.quantity) total_quantity
from pizza_types
join pizzas on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category
order by total_quantity desc;

-- Q2)Determine the distribution of orders by hour of the day.
 select hour(time), count(order_id) as total_order
 from orders
 group by hour(time)
 order by total_order desc;
 
 -- Q3)Join relevant tables to find the category-wise distribution of pizzas.
select * from pizza_types;
select category, count(name) 
from pizza_types
group by category;

-- Q4) Group the orders by date and calculate the average number of pizzas ordered per day.
select avg(quantity) from 
(select orders.date, sum(order_details.quantity) as quantity
from orders
join order_details on order_details.order_id = orders.order_id
group by orders.date) as order_quantity;

-- Q5) Determine the top 3 most ordered pizza types based on revenue. 
select pizza_types.name, sum(order_details.quantity * pizzas.price) as total_revenue
from pizza_types
join pizzas on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name
order by total_revenue desc
limit 3;


-- Set 3)
-- Q1) Calculate the percentage contribution of each pizza type to total revenue.
select pizza_types.category, 
round(sum(order_details.quantity * pizzas.price) / (select round(sum(pizzas.price * order_details.quantity),2) as total_sale 
from order_details
join pizzas on pizzas.pizza_id = order_details.pizza_id) *100,2) as revenue_total
from pizza_types
join pizzas on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category
order by revenue_total;

-- Q2)Analyze the cumulative revenue generated over time.
select date,
round(sum(total_revenue) over(order by date), 2)  as cumulative
from
(select orders.date, sum(order_details.quantity * pizzas.price) as total_revenue 
from orders
join order_details on order_details.order_id = orders.order_id 
join pizzas on pizzas.pizza_id = order_details.pizza_id
group by orders.date) as total_sales;


-- Q3)Determine the top 3 most ordered pizza types based on 
--    revenue for each pizza category.
select name, total_revenue 
from 
(select category, name, total_revenue,
rank() over(partition by category order by total_revenue desc) as rn
from 
(select pizza_types.category, pizza_types.name, 
sum(order_details.quantity * pizzas.price) as total_revenue
from pizza_types
join pizzas on pizzas.pizza_type_id = pizza_types.pizza_type_id 
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category, pizza_types.name) as a) as b
where rn <=3;







