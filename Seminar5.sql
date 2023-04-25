DROP DATABASE IF EXISTS semimar5;
create database seminar5;
use seminar5;

DROP TABLE IF EXISTS academic_record;
CREATE TABLE academic_record (
	id INT AUTO_INCREMENT PRIMARY KEY, 
	name VARCHAR(45),
	quartal  VARCHAR(45),
    subject VARCHAR(45),
	grade INT
);

INSERT INTO academic_record (name, quartal, subject, grade)
values
	('Александр','1 четверть', 'математика', 4),
	('Александр','2 четверть', 'русский', 4),
	('Александр', '3 четверть','физика', 5),
	('Александр', '4 четверть','история', 4),
	('Антон', '1 четверть','математика', 4),
	('Антон', '2 четверть','русский', 3),
	('Антон', '3 четверть','физика', 5),
	('Антон', '4 четверть','история', 3),
    ('Петя', '1 четверть', 'физика', 4),
	('Петя', '2 четверть', 'физика', 3),
	('Петя', '3 четверть', 'физика', 4),
	('Петя', '2 четверть', 'математика', 3),
	('Петя', '3 четверть', 'математика', 4),
	('Петя', '4 четверть', 'физика', 5);

/*
 Задача 1. Получить с помощью оконных функции:
•средний балл ученика
•наименьшую оценку ученика
•наибольшую оценку ученика
•сумму всех оценок
•количество всех оценок
*/

-- •средний балл ученика
SELECT 
	*, 
    AVG(grade) OVER w AS Средний_балл
FROM academic_record
WINDOW w AS (PARTITION BY name)
ORDER BY name;

-- •наименьшую оценку ученика
SELECT 
	*, 
    MIN(grade) OVER w AS Наименьший_балл
FROM academic_record
WINDOW w AS (PARTITION BY name)
ORDER BY name;

-- •наибольшую оценку ученика
SELECT 
	*, 
    MAX(grade) OVER w AS Наибольший_балл
FROM academic_record
WINDOW w AS (PARTITION BY name)
ORDER BY name;

-- •сумму всех оценок
SELECT 
	*, 
    SUM(grade) OVER w AS Сумма_баллов
FROM academic_record
WINDOW w AS (PARTITION BY name)
ORDER BY name;

-- •количество всех оценок
SELECT 
	*, 
    COUNT(grade) OVER w AS Количествой_баллов
FROM academic_record
WINDOW w AS (PARTITION BY name)
ORDER BY name;

-- Общий вариант
SELECT *,
    AVG(grade) OVER t AS 'avg_grade',
	MIN(grade) OVER t AS 'min_grade',
	MAX(grade) OVER t AS 'max_grade',
	SUM(grade) OVER t AS 'sum_grades',
    COUNT(grade) OVER t AS 'count_grades'
FROM academic_record
WINDOW t AS (PARTITION BY name);

/*
Задача 2. Получить информацию об оценках Пети по физике по четвертям:
• текущая успеваемость
• оценка в следующей четверти
• оценка в предыдущей четверти
*/

SELECT *, 
	 LAG(grade) OVER w AS 'Lag',
     LEAD(grade) OVER w AS 'Lead'
FROM academic_record
WHERE name = 'Петя' AND subject = 'физика'
WINDOW  w AS (PARTITION BY name ORDER BY quartal);

-- Задача 3. Для базы lesson_4 решите:
use semimar4;

-- 1. создайте представление, в котором будут выводится все сообщения, в которых принимал участие пользователь с id= 1
CREATE OR REPLACE VIEW id1_messages AS
	SELECT *
    FROM messages
    WHERE from_user_id = 1 OR to_user_id = 1;
SELECT * FROM id1_messages;

-- 2. найдите друзей у друзей пользователя с id= 1 и поместите выборку в представление; (решение задачи с помощью with)
-- CREATE OR REPLACE VIEW друзья;
WITH друзья AS
	(
    SELECT initiator_user_id as 'друзья id1'
    FROM friend_requests 
    WHERE target_user_id = 1 AND status = 'approved'
	UNION 
	SELECT target_user_id 
	FROM friend_requests
	WHERE initiator_user_id = 1 AND status = 'approved'
    )
SELECT * FROM друзья;
    
-- 3. найдите друзей у друзей пользователя с id= 1. (решение задачи с помощью представления “друзья”)
CREATE OR REPLACE VIEW друзья_друзей AS 
WITH друзья AS
	(
    SELECT initiator_user_id 
    FROM friend_requests 
    WHERE target_user_id = 1 AND status = 'approved'
	UNION 
	SELECT target_user_id 
	FROM friend_requests
	WHERE initiator_user_id = 1 AND status = 'approved'
    )
	SELECT initiator_user_id as 'друзья друзей id1' 
    FROM friend_requests
    WHERE target_user_id IN (SELECT * FROM друзья) AND status = 'approved'
    UNION
    SELECT target_user_id 
    FROM friend_requests
    WHERE initiator_user_id IN (SELECT * FROM друзья) AND status = 'approved';
    SELECT * FROM друзья_друзей;