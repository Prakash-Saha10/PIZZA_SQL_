create schema pizza;

create table pizza.order_deatils
(
order_details_id int not null,
order_id int not null,
pizza_id text,
quantity int not null,
primary key(order_details_id)
);

---retrive the total number of orders placed

select count(order_id) as total_orders from pizza.orders o ;


----calculate the total review generated from pizza sales

select round
(sum(od.quantity * p.price),2) 
as total_sales
from pizza.order_deatils od
join
pizza.pizzas p  on p.pizza_id = od.pizza_id


---higest pizzas price
select 
pt.name
,p.price 
FROM
pizza.pizza_types pt  join pizza.pizzas p 
on pt.pizza_type_id =p.pizza_type_id
order by p.price desc

--most common pizza orders
select 
p.size,
count ( od.order_details_id )as order_count
from pizza.pizzas p join
pizza.order_deatils od 
on p.pizza_id= od.pizza_id
group by p.size 
order by order_count desc ;

---list the top 5 most ordered pizza
---types along with their quantitites

select 
pt.name,sum(order_details.quantity) as quantity
from 
pizza.pizza_types pt 
join pizza.pizzas on pizza_type_id =.pizza.p.pizza_type_id
join  order_deatils on order_details.pizza id=pizzas.pizza_id
group by pt.name
order by quantity  desc 
limit 5;


-----determines the distribution of orders by hour of the day
 
select 
 hour ("time" time) as hour,count(order_id) as order_count
 from 
pizza.orders 
 group by hour(order_time)
 
 --join relevants tables to find the category wise distribution of pizza
 
 select category ,count(name) from pizza_types
 group by category ;
 
 --group orders by date and calculate average 
 --number of pizzas order per day

 select round(avg(quantity),0) from
 (select orders.order_date,sum(order_details.quantity)
 from orders join order_details
 on orders.orders_id =order_details.order_id
 group by orders.orders_date)as order_quantity
 
 
 
 --determines the top 3 most ordered pizza types based on revenue
 select pizza_types.name,
 order_details.quantity * pizzas.price as reveneu
 from pizza_types join pizzas
 on pizzas.pizza_type_id =pizza_types.pizza_type_id
 join order_details.pizza_id =pizzas.pizza_id
 group by pizza_types.name order by reveneu desc 
 limit 3;
 
 
 ---pizza type total revenue
 
 select pizza_types.category,
 (sum(order_details.quantity * pizzas.price) /(select round (sum(order_details.quantity *pizzas.price),2) as total_sales
 from order_deatils
 join
 pizzas on pizzas.pizza_id =order_details.pizza_id)*100 as revenue
 
 from pizza_types join pizzas
 on pizzas.pizza_type_id =pizza_types.pizza_type_id
 join order_details.pizza_id =pizzas.pizza_id
 group by pizza_types.category order by reveneu desc 
 limit 3;
 
 --analyze the cumulative revenue generated over time.
 select order_date,
 sum(revenue) over (order by order_date) as cum_revenue
 from
 (select orders.order_date,
 sum(order_details.quantity * pizzas.price) as revenue
 from pizza.order_details join pizzas
 on order_details.pizza_id =pizzas.pizza_id
 join orders
 on orders.order_id=order_details.order_id
 group by orders.order_date) as sales;
 
 
 --determines top 3 best pizzas
 ---based on revenue for each category
 
 select name,revenue from
 (select category,name,revenue,
 rank() over(partition by category order by revenue desc)as rn
 from
 (select pizza_types.category,pizza_types.name,
 sum((order_details.quantity)*pizzas.price)as revenue
 from pizza_types join pizzas
 on pizza_types.pizza_type_id=pizzas.pizza_type_id
 join order_details
 on order_details,pizza_id =pizzas.pizza_id
 group by pizza_types.category,pizza_types.name)as a)as b
 where rn <=3;
 
