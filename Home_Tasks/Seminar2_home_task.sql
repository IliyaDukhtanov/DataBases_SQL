CREATE DATABASE Seminar2_home_task;
USE Seminar2_home_task;

-- 1. Используя операторы языка SQL, создайте таблицу “sales”. Заполните ее данными.
DROP TABLE IF EXISTS sales;
CREATE TABLE sales 
(
id INT PRIMARY KEY AUTO_INCREMENT,
order_date DATE NOT NULL,
count_product INT DEFAULT 0
); 
-- SELECT * FROM sales;

INSERT INTO sales (order_date, count_product)
VALUES
	('2022-01-01', 156), 
    ('2022-01-02', 180), 
    ('2022-01-03', 21), 
	('2022-01-04', 124), 
	('2022-01-05', 341);
-- SELECT * FROM sales;

-- 2. Для данных таблицы “sales” укажите тип заказа в зависимости от кол-ва :
/*
меньше 100 - Маленький заказ
от 100 до 300 - Средний заказ
больше 300 - Большой заказ
*/
SELECT id,
CASE 
	WHEN count_product < 100 
		THEN 'Маленький заказ'
	WHEN count_product BETWEEN 100 AND 300
		THEN 'Средний заказ'
	ELSE 'Большой заказ'
END AS Тип_заказа
FROM sales;

-- 3. Создайте таблицу “orders”, заполните ее значениями
DROP TABLE IF EXISTS orders;
CREATE TABLE orders 
(
id INT PRIMARY KEY AUTO_INCREMENT,
employe_id VARCHAR(4) NOT NULL,
amount DECIMAL (7, 2) DEFAULT 0,
order_status VARCHAR(15) NOT NULL
); 
-- SELECT * FROM orders;

INSERT orders (employe_id, amount, order_status)
VALUES
	('e03', 15.00, 'OPEN'),
	('e01', 25.50, 'OPEN'),
	('e05', 100.70, 'CLOSED'),
	('e02', 22.18, 'OPEN'),
	('e04', 9.50, 'CANCELLED');
-- SELECT * FROM orders;

-- Выберите все заказы. В зависимости от поля order_status выведите столбецfull_order_status:
-- OPEN –«Order is in open state»; CLOSED -«Order isclosed»; CANCELLED -«Order is cancelled»
SELECT * ,
IF (order_status = 'OPEN', 'Order is in open state', 
	IF (order_status = 'CLOSED', 'Order isclosed', 'Order is cancelled')
	) AS full_order_status
FROM orders;