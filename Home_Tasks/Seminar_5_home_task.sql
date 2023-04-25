use semimar_4_home_task;

-- 1. Создайте представление, в которое попадет информация о пользователях (имя, фамилия, город и пол), которые не старше 20 лет.
CREATE OR REPLACE VIEW teens AS     
SELECT u.firstname, u.lastname, pf.hometown, pf.gender, TIMESTAMPDIFF(YEAR, pf.birthday, NOW()) AS age
FROM users u
JOIN profiles pf
ON u.id = pf.user_id AND TIMESTAMPDIFF(YEAR, pf.birthday, NOW()) <= 20;
SELECT * FROM teens;

/*
2. Найдите кол-во, отправленных сообщений каждым пользователем и 
выведите ранжированный список пользователей, указав имя и фамилию пользователя, 
количество отправленных сообщений и место в рейтинге (первое место у пользователя с максимальным количеством сообщений) . 
(используйте DENSE_RANK)*/
-- вариант 1
SELECT from_user_id, 
	(SELECT firstname FROM users WHERE id = messages.from_user_id) AS 'Имя',
	(SELECT lastname FROM users WHERE id = messages.from_user_id) AS 'Фамилия',
	COUNT(*) AS 'Отправлено сообщений', DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) AS 'Место в рейтинге'
FROM messages 
GROUP BY from_user_id
ORDER BY COUNT(*) DESC;

-- вариант 2
SELECT users.firstname, users.lastname, count(*) as 'Отправлено сообщений', 
	DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) as 'Место в рейтинге'
FROM messages
JOIN users
ON users.id = messages.from_user_id 
GROUP BY from_user_id;


/*
3. Выберите все сообщения, отсортируйте сообщения по возрастанию даты отправления (created_at) и 
найдите разницу дат отправления между соседними сообщениями, получившегося списка. (используйте LEAD или LAG)
*/
-- вариант 1
CREATE OR REPLACE VIEW temp AS 
SELECT *, 
	LEAD(created_at) OVER (ORDER BY created_at) AS 'Next'
FROM messages
ORDER BY created_at;

SELECT from_user_id, to_user_id, TIMESTAMPDIFF(SECOND, created_at, Next) as 'Разница в секундах до следующего сообщения'
from temp;

-- вариант 2
CREATE OR REPLACE VIEW Time_bw_messages AS
WITH Temp AS 
(
SELECT *, 
	LEAD(created_at) OVER (ORDER BY created_at) AS 'Next'
FROM messages
ORDER BY created_at
)
SELECT from_user_id, to_user_id, TIMESTAMPDIFF(SECOND, created_at, Next) as 'Разница в секундах до следующего сообщения'
from temp;
SELECT * FROM Time_bw_messages;