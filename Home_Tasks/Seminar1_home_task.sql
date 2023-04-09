-- 1. Создаём новую базу данных
CREATE SCHEMA seminar1_home_task;

-- Переключаемс в созданную базу данных
USE seminar1_home_task;

-- Создаём таблицу mobile_phones
CREATE TABLE mobile_phones
( id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, 
product_name VARCHAR (45) NOT NULL,
manufacturer VARCHAR (45) NOT NULL,
product_count INT DEFAULT 0,
price FLOAT DEFAULT 0);

-- Заполняем таблицу данными
INSERT mobile_phones (product_name, manufacturer, product_count, price)
VALUE
('iPhone X', 'Apple', 3, 76000),
('iPhone 8', 'Apple', 2, 51000),
('Galaxy S9', 'Samsung', 2, 56000),
('Galaxy S8', 'Samsung', 1, 41000),
('P20 Pro', 'Huawei', 5, 36000);

-- Проверка имеющихся данных в таблице
SELECT * FROM mobile_phones;

-- 2. Выведите название, производителя и цену для товаров, количество которых превышает 2
SELECT product_name, manufacturer, price
FROM mobile_phones 
WHERE product_count > 2; 

-- 3.  Выведите весь ассортимент товаров марки "Samsung"
SELECT *
FROM mobile_phones
WHERE manufacturer = 'Samsung';

-- 4.1. Товары, в которых есть упоминание "Iphone"
SELECT *
FROM mobile_phones
WHERE product_name LIKE 'iPhone%';

-- 4.2. Товары, в которых есть упоминание "Samsung"
SELECT *
FROM mobile_phones
WHERE product_name LIKE 'Samsung';

-- 4.3.  Товары, в которых есть ЦИФРЫ
SELECT *
FROM mobile_phones
WHERE product_name LIKE '%0%' 
or product_name LIKE '%1%' 
or product_name LIKE '%2%' 
or product_name LIKE '%3%' 
or product_name LIKE '%4%' 
or product_name LIKE '%5%' 
or product_name LIKE '%6%' 
or product_name LIKE '%7%' 
or product_name LIKE '%8%' 
or product_name LIKE '%9%';

-- Вариант 2  - предпочтительный
SELECT *
FROM mobile_phones
WHERE product_name RLIKE '[0-9]';

-- 4.4.  Товары, в которых есть ЦИФРА "8"  
SELECT *
FROM mobile_phones
WHERE product_name LIKE '%8%';
