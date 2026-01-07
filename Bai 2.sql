create database b2_s7;
use b2_s7;
create table products (
id int primary key auto_increment,
name varchar(225) not null,
price decimal (10,2) not null check (price >=0)
);
create table order_items(
order_id int not null,
product_id int not null,
quantity int not null check (quantity >0),
primary key (order_id,product_id),
constraint fk_order_items_products foreign key (product_id) references products(id)
);
INSERT INTO products (name, price) VALUES
('Bàn phím cơ', 1800000),
('Chuột gaming', 1200000),
('Tai nghe bluetooth', 1500000),
('SSD 512GB', 1900000),
('Router Wifi', 1400000),
('Webcam Full HD', 1600000);
INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 2),
(1, 2, 1),
(2, 3, 3),
(3, 4, 1),
(3, 2, 2);
select * from products where id in (select product_id from order_items);


