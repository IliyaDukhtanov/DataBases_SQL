CREATE DATABASE Seminar3;
USE Seminar3;

DROP TABLE IF EXISTS staff; 
CREATE TABLE staff 
(id INT PRIMARY KEY AUTO_INCREMENT, 
firstname VARCHAR(45) NOT NULL,
lastname VARCHAR(45) NOT NULL,
post VARCHAR(45) NOT NULL,
seniority INT DEFAULT 0,
salary INT DEFAULT 0,
age INT DEFAULT 0
);

INSERT INTO staff (firstname, lastname, post, seniority, salary, age)
VALUES
	('Вася', 'Петров', 'Начальник', 40, 100000, 60),
	('Петр', 'Власов', 'Начальник', 8, 70000, 30),
	('Катя', 'Катина', 'Инженер', 2, 70000, 25),
	('Саша', 'Сасин', 'Инженер', 12, 50000, 35),
	('Иван', 'Иванов', 'Рабочий', 40, 30000, 59),
	('Петр', 'Петров', 'Рабочий', 20, 25000, 40),
	('Сидр', 'Сидоров', 'Рабочий', 10, 20000, 35),
	('Антон', 'Антонов', 'Рабочий', 8, 19000, 28),
	('Юрий', 'Юрков', 'Рабочий', 5, 15000, 25),
	('Максим', 'Максимов', 'Рабочий', 2, 11000, 22),
	('Юрий', 'Галкин', 'Рабочий', 3, 12000, 24),
	('Людмила', 'Маркина', 'Уборщик', 10, 10000, 49);

SELECT * FROM staff;

-- ORDER BY. Задачи
-- Выведите все записи, отсортированные по полю "age" по возрастанию
SELECT * 
FROM staff
ORDER BY age;

-- Выведите все записи, отсортированные по полю “firstname"
SELECT * 
FROM staff
ORDER BY firstname;

-- Выведите записи полей "firstname", “lastname", "age", отсортированные по полю "firstname" в алфавитном порядке по убыванию
SELECT firstname, lastname, age 
FROM staff
ORDER BY firstname DESC;

-- Выполните сортировку по полям "firstname" и "age" по убыванию
SELECT * 
FROM staff
ORDER BY firstname DESC, age DESC;

-- DISTINCT, LIMIT. Задачи
-- 1.Выведитеуникальные(неповторяющиеся)значенияполей"firstname"
SELECT DISTINCT firstname 
FROM staff;

-- 2. Отсортируйте записи по возрастанию значений поля "id". Выведите первые две записи данной выборки
SELECT * 
FROM staff
ORDER BY id
LIMIT 2;

-- 3.Отсортируйте записи по возрастанию значений поля "id". Пропуститепервые 4 строкиданной выборки и извлеките следующие 3
SELECT * 
FROM staff
ORDER BY id
LIMIT 4, 3;

-- 4.Отсортируйте записи по убыванию поля "id". Пропустите две строки данной выборки и извлеките следующие за ними 3 строки
SELECT * 
FROM staff
ORDER BY id DESC
LIMIT 2, 3;

-- Агрегатные функции. Задачи
-- 1.Найдите количество сотрудников с должностью «Рабочий»
SELECT COUNT(*)
FROM staff
WHERE post = 'Начальник';

-- 2. Посчитайте ежемесячную зарплату начальников
SELECT SUM(salary) 
FROM staff 
WHERE post = 'Начальник';

-- 3.Выведите средний возраст сотрудников, у которых заработная плата больше 30000 
SELECT AVG(age)
FROM staff 
WHERE salary > 30000;

-- 4.Выведите максимальную и минимальную заработные платы
SELECT
	MAX(salary) AS max,
	MIN(salary) AS min
FROM staff;

CREATE TABLE activity_staff
(
id INT PRIMARY KEY AUTO_INCREMENT,
staff_id INT NOT NULL,
date_activity DATE NOT NULL,
count_page INT DEFAULT 0,
FOREIGN KEY (staff_id) REFERENCES staff (id)
);
SELECT * FROM activity_staff;

INSERT INTO activity_staff (staff_id, date_activity, count_page)
VALUES
(1, '2022-01-01', 250),
(2, '2022-01-01', 220),
(3, '2022-01-01', 170),
(1, '2022-01-02', 100),
(2, '2022-01-02', 220),
(3, '2022-01-02', 300),
(7, '2022-01-02', 350),
(1, '2022-01-03', 168),
(2, '2022-01-03', 62),
(3, '2022-01-03', 84);
SELECT * FROM activity_staff;

-- GROUP BY. Задачи
-- 1. Выведите общее количество напечатанных страниц каждым сотрудником
SELECT staff_id, SUM(count_page) AS total_pages
FROM activity_staff
GROUP BY staff_id;

-- 2. Посчитайте количество страниц за каждый день
SELECT date_activity, SUM(count_page) AS dayly_pages
FROM activity_staff
GROUP BY date_activity;

-- 3. Найдите среднее арифметическое по количеству ежедневных страниц
SELECT date_activity, AVG(count_page) AS dayly_pages
FROM activity_staff
GROUP BY date_activity;

-- GROUP BY. Задача
/*Сгруппируйте данные о сотрудниках по возрасту:
1 группа –младше 20 лет
2 группа–от 20 до 40 лет
3 группа –старше 40 лет
Для каждой группы найдите суммарную зарплату
*/
SELECT category, SUM(salary)
FROM (
SELECT salary,
CASE 
	WHEN age BETWEEN 20 AND 40
		THEN 'от 20 до 40 лет'
	WHEN age > 40
		THEN 'старше 40 лет'
	ELSE 'младше 20 лет'
END AS category
FROM staff) AS list_staff -- имя временной таблицы
GROUP BY category;

-- HAVING. Задачи
-- 1.Выведите id сотрудников, которые напечатали более 500 страниц за все дни
SELECT staff_id, SUM(count_page) AS total_pages
FROM activity_staff
GROUP BY staff_id
HAVING total_pages > 500;

SELECT staff_id
FROM activity_staff
GROUP BY staff_id
HAVING SUM(count_page) > 500;

-- 2.Выведите дни, когда работало более 3 сотрудников. Также укажите кол-во сотрудников, которые работали в выбранные дни.
SELECT date_activity, COUNT(staff_id) AS total_worked
FROM activity_staff
GROUP BY date_activity 
HAVING total_worked > 3;

-- 3.Выведите среднюю заработную плату по должностям, которая составляет более 30000
SELECT post, AVG(salary) AS average_salary
FROM staff
GROUP BY post 
HAVING average_salary > 30000;