CREATE SCHEMA Lesson2;
use lesson2;
CREATE table buyer
(
id INT PRIMARY KEY AUTO_INCREMENT,
date_of_birth DATE,
first_name VARCHAR(20),
last_name VARCHAR(20),
phone VARCHAR(20)
);
SELECT * FROM buyer;
CREATE TABLE orders
(
id INT PRIMARY KEY AUTO_INCREMENT,
buyer_id INT,
amount INT,
count_orders INT,
FOREIGN KEY (buyer_id) REFERENCES buyer (id)
);
ALTER TABLE orders 
ADD COLUMN manufacter VARCHAR(45) NULL AFTER count_orders;

SELECT * FROM orders;

-- Заполним нашу таблицу “Покупатели” данными:
INSERT buyer (date_of_birth, first_name, last_name, phone)
VALUES
('2002-01-01', 'Михаил', 'Меркушев', '+7-999-888-77-55'),
('2005-05-25', 'Сергей', 'Сергеев', '60-70-80'),
('1975-12-25', 'Том', 'Круз', '+46-2589-256-8963'),
('1998-03-08', 'Агния', 'Барто', '+7-812-123-12-34');
SELECT * FROM buyer;

-- Покупатели сделали заказы в нашем магазине. Чтобы увидеть их, создадим таблицу с заказами клиентов:
INSERT Orders (buyer_id, amount, count_orders, manufacter)
VALUES
(1, 1000, 3, "Ягодки"),-- Первый заказ из "Покупатели" по id = 1 (Меркушов Михал)
(1, 400 , 2, "Амазон"),-- Второй заказ из "Покупатели" по id = 2 (Меркушов Михал)
(2, 1200 , 5, "Амазон"),
(3, 2000 , 1, "Ягодки"),
(4, 5000 , 4, "Ягодки");
SELECT * FROM orders;

-- Попробуем увидеть эту связь среди таблиц:
SELECT buyer.first_name, buyer.id, orders.buyer_id, orders.amount
FROM buyer, orders
WHERE orders.buyer_id = buyer.id;

-- Псевдонимы
-- Посчитаем чек по заказу. Для этого умножаю количество на цену:
SELECT buyer_id, amount * count_orders AS result  -- Псевдоним столбца
FROM orders;

SELECT amount * count_orders result -- Псевдоним - result задается через проблел
FROM Orders;

-- Псевдоним таблицы - задается аналогично: с помощью пробела и слова AS:
-- 1
SELECT B.first_name, B.id, O.buyer_id, O.amount
FROM Orders O, Buyer B
WHERE O.buyer_id = B.id;
-- 2
SELECT B.first_name, B.id, O.buyer_id, O.amount
FROM Orders AS O, Buyer AS B
WHERE O.buyer_id = B.id;

-- UPDATE - обновление данных для уже имеющихся строк
UPDATE orders
SET amount = amount * 0.75;
SELECT amount new_amount
FROM orders;

-- Мы изменили данные в исходной таблице и хотим вернуть исходный результат. 
-- Для этого можно полностью очистить таблицу от данных с помощью команды TRUNCATE:
TRUNCATE Orders; -- Удаляет все записи из таблицы Orders
SELECT *
FROM Orders;

/*
**Небольшое задание:**
В нашем магазине действует акция: скидка 50% на заказы, в которых есть минимум 4 товара. 
Скидка распространяется на 2 покупателей: id = 2, amount = 1200 ,  count = 5 и id = 4, amount = 5000 ,  count = 4
*/
UPDATE orders 
SET amount = amount * 0.5
WHERE count_orders > 3;
SELECT * FROM orders;

-- DELETE - удаление данных
/*
Пусть в нашей базе хранятся тестовые данные, используемые нами только для тестирования. 
Необходимость в тестировании пропала и мы можем их удалить:
*/
INSERT buyer (date_of_birth, first_name, last_name, phone)
VALUES
	("2023-01-01", "Тестовый", "Пользователь", "+7-999-888-77-66");
-- Добавили клиента
SELECT * FROM buyer;

DELETE FROM buyer 
WHERE first_name = 'Тестовый';
-- Удалили строчку со значением
SELECT * FROM buyer;

-- Логические операторы
-- Получим заказы от 1500 рублей из магазина "Ягодки"
SELECT amount, count_orders 
FROM orders
WHERE amount > 1500 AND manufacter = "Ягодки";

--  Хотим получить товары или из "Амазона", или товары из диапазона (3;5)
SELECT amount, count_orders, manufacter
FROM orders
WHERE manufacter = "Амазон" OR count_orders > 2 AND count_orders < 5;
-- Оператор AND имеет более высокий приоритет, чем OR

-- Исключим товары марки "Ягодки"
SELECT amount, count_orders, manufacter
FROM orders
WHERE manufacter != "Ягодки";
-- ИЛИ через "!="
SELECT amount, count_orders, manufacter
FROM orders
WHERE NOT manufacter = "Ягодки";

-- Операторы CASE, IF

-- CASE
/*
Давайте добавим в исходную таблицу столбец “статус”, в котором будет два значения: 
- 0 - заказ не оплачен
- 1 - заказ оплачен
Заполнение произведем с помощью функции для получения рандомного числа = **RAND().**
*/
ALTER TABLE orders
ADD COLUMN status INT AFTER count_orders;

UPDATE orders
SET status = RAND();
SELECT * FROM orders;

SELECT status, 
	CASE WHEN status IS TRUE THEN 'заказ оплачен'
	ELSE 'оплатите заказ'
	END AS message
FROM orders;

-- ИЛИ
SELECT status, -- Перед "CASE" ставится запятая, после перечисления столбцов
  CASE WHEN status = 1 THEN 'заказ оплачен'
  ELSE 'оплатите заказ' 
  END AS message
FROM orders;

-- IF
-- Представьте,что мы страхуем заказы со средним чеком от 3000 включительно.
-- Сообщим клиентам о наличии или отсутствии страховки
SELECT status, amount, count_orders, manufacter,-- Перед "IF" тоже ставится запятая
    IF(amount * count_orders >= 3000, 'Cтраховка включена в стоимость', 'Страховка оплачивается отдельно') AS info_message
FROM orders;