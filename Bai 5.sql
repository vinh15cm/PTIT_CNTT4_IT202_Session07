drop database b1_s7;
create database b1_s7;
use b1_s7;

create table customers(
id int primary key auto_increment,
name varchar(255) not null,
email varchar(255) not null unique
);
create table orders (
id int primary key auto_increment,
customer_id int not null,
order_date date not null,
total_amount decimal(10,2) not null check (total_amount >=0),
constraint fk_orders_customers foreign key (customer_id) references customers(id)
);
INSERT INTO customers (name, email) VALUES
('Nguyễn Văn An', 'an.nguyen@gmail.com'),
('Trần Thị Bình', 'binh.tran@gmail.com'),
('Lê Minh Châu', 'chau.le@gmail.com'),
('Phạm Quốc Dũng', 'dung.pham@gmail.com'),
('Vũ Thị Hạnh', 'hanh.vu@gmail.com'),
('Hoàng Minh Khoa', 'khoa.hoang@gmail.com'),
('Đặng Thị Lan', 'lan.dang@gmail.com');
INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2024-09-01', 3500000),
(1, '2024-09-05', 4200000),
(2, '2024-09-03', 2500000),
(3, '2024-09-06', 5100000),
(4, '2024-09-07', 1800000),
(4, '2024-09-10', 6200000),
(6, '2024-09-12', 2900000);
SELECT
  c.id,
  c.name,
  c.email,
  (
    SELECT SUM(o.total_amount)
    FROM orders o
    WHERE o.customer_id = c.id
  ) AS total_spent
FROM customers c
WHERE
  (
    SELECT SUM(o2.total_amount)
    FROM orders o2
    WHERE o2.customer_id = c.id
  ) = (
    SELECT MAX(t.total_spent)
    FROM (
      SELECT
        customer_id,
        SUM(total_amount) AS total_spent
      FROM orders
      GROUP BY customer_id
    ) AS t
  );



