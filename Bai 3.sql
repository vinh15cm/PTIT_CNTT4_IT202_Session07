create database b3_s7;
use b3_s7;
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
INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2024-09-01', 3500000),
(2, '2024-09-02', 7200000),
(3, '2024-09-03', 1500000),
(1, '2024-09-04', 9800000),
(4, '2024-09-05', 4200000),
(2, '2024-09-06', 6100000);
INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 2),
(1, 2, 1),
(2, 3, 3),
(3, 4, 1),
(3, 2, 2);
SELECT *
FROM orders
WHERE total_amount > (
    SELECT AVG(total_amount)
    FROM orders
);



