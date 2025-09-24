-----ALTER TABLE customer ADD COLUMN last_order_date TIMESTAMP--------

--ALTER TABLE customer ADD COLUMN last_order_date TIMESTAMP;

create or replace function update_date() returns trigger as
$$
begin 
update customer
set last_order_date=new.order_date
where id=new.customer_id;

return new;
end;
$$
language plpgsql;

create or replace trigger trg_update_last_order_date
after insert on orders
for each row
execute function update_date();

INSERT INTO orders (id, customer_id, order_date, status)
VALUES (32, 3, '2025-09-23 12:30:00', 'processing'); --Testing

--Prevent placing orders for out-of-stock products (stock = 0)

create or replace function prevent_ordering() returns trigger as
$$
declare
CurentStock int;
begin
select stock into CurentStock from product where id=new.product_id;
if CurentStock<=0 then
raise exception 'Product is out of stock';
end if;
return new;
end;
$$ 
language plpgsql;

create or replace trigger trg_Prevent_orddering
before insert on order_item
for each row
execute function prevent_ordering();

--Prevent listing a product with a negative price  & stock

create or replace function preventing_negPrice()
returns trigger as $$
declare
temp_price numeric(10,2);
temp_stock int;
begin
select price, stock
into temp_price, temp_stock
from product
where id = new.id;

  if temp_price < 0 then
    raise exception 'price cannot be negative';
  end if;
  
if temp_stock < 0 then
raise exception 'stock cannot be negative';
end if;
return new;
end;
$$ language plpgsql;


create or replace trigger trg_preventing_negPrice
before insert on product
for each row
execute function preventing_negPrice();

insert into product(id,name,price,stock,category)
values(31,'Gaming Console',-799,2,'Gaming')



