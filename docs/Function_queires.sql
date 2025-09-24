-------------Function----------------

--------Receive all payments from a customer-----------
create function Total_Payment(Input_ID int) returns numeric as
$$
Declare
total numeric;
begin
select coalesce(sum(p.amount),0) into total
from payment p join orders o on p.order_id = o.id 
join customer c on c.id=o.customer_id
where c.id=Input_ID;
return total;
end;
$$ LANGUAGE plpgsql;

SELECT Total_Payment(1);


----------Check product inventory--------
create function Product_inventory(InputID int) returns bool as
$$
declare
available bool;
begin
select p.stock>0 into available
from product p 
where p.id=InputID;
return  available;
end;
$$ LANGUAGE plpgsql;

select Product_inventory(2);

----Calculate the total amount of a specific order----
create or replace function order_amount(inputID int) returns numeric as
$$
declare
 Price numeric;
begin
select sum(oi.quantity*oi.price_at_order) into Price
from orders o join order_item oi on o.id=oi.order_id
where o.id=inputID;
return coalesce(Price,0);
end;
$$
language plpgsql;

select order_amount(2);

------Show Orders Details-------

create or replace function Order_Detail(InputID int) returns table(Product_name varchar, total_payment numeric) as
$$
declare
begin
return query
select p.name, sum(oi.quantity*oi.price_at_order) 
from product p join order_item oi on p.id=oi.product_id join orders o on o.id=oi.order_id
where o.id=InputID
group by p.name;
end;
$$
language plpgsql;

select Order_Detail(2)

