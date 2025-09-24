
---------------------------MATERIALIZED VIEW -----------------------

/*ProductInventorySummary*/
create materialized view "Product_Summary" as
select p.category,
count(p.id) as "Number Of Products",
sum(oi.price_at_order*oi.quantity) as "Price"
from order_item oi join product p on oi.product_id=p.id
group by category

/*Best selling products*/
create materialized view "Best_selling products" as 
select 
p.id as product_id,
p.name as product_name,
sum(oi.quantity) as total_sold
from product p
join order_item oi on oi.product_id = p.id
group by p.id, p.name
order by total_sold desc
limit 10;

/*Highest paying customers with their product*/
create materialized view "Highest paying customers" as
select c.name,c.email,p.amount,
p1.name as "Product Name"
from customer c join orders o on c.id=o.customer_id
join payment p on p.order_id = o.id
join order_item oi on oi.order_id=o.id 
join product p1 on p1.id=oi.product_id
group by c.name,c.email,p.amount,p1.name
order by p.amount desc

