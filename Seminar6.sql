use semimar4;

/*
Задача 1.  Создайте процедуру, которая выберет для одного пользователя 5 пользователей в случайной комбинации, 
которые удовлетворяют хотя бы одному критерию:
1) из одного города 
2) состоят в одной группе 
3) друзья друзей
*/
DELIMITER // 
DROP PROCEDURE IF EXISTS select_users //
CREATE PROCEDURE select_users(search_user_id int)
BEGIN 
WITH друзья AS
    (
    SELECT initiator_user_id 
    FROM friend_requests 
    WHERE target_user_id = search_user_id AND status = 'approved'
	UNION 
	SELECT target_user_id 
	FROM friend_requests
	WHERE initiator_user_id = search_user_id AND status = 'approved'
    )
	SELECT initiator_user_id as 'друзья друзей id1' 
    FROM friend_requests
    WHERE target_user_id IN (SELECT * FROM друзья) AND status = 'approved'
    UNION
    SELECT target_user_id 
    FROM friend_requests
    WHERE initiator_user_id IN (SELECT * FROM друзья) AND status = 'approved'
    UNION
    SELECT DISTINCT uc2.user_id 
	FROM users_communities uc1
	JOIN users_communities uc2 ON uc1.community_id = uc2.community_id 
	WHERE uc1.user_id = search_user_id AND uc2.user_id != search_user_id
    ORDER BY RAND()
    LIMIT 5;
  END//
  DELIMITER ;
  
CALL select_users(1);


/*Задача 2. Создание функции, вычисляющей коэффициент популярности пользователя
(по заявкам на дружбу – таблица friend_requests)*/

DROP FUNCTION IF EXISTS rating;

DELIMITER //
CREATE FUNCTION rating(search_user_id int)
RETURNS FLOAT READS sql data

BEGIN 
DECLARE total int;
DECLARE count_user int;
SET total = (SELECT COUNT(*) FROM friend_requests);
SET count_user = (
SELECT COUNT(*)
FROM friend_requests
WHERE target_user_id = search_user_id);
RETURN count_user / total;
END//
DELIMITER ;

SELECT rating(10);


/*
Задача 3. Необходимо перебрать всех пользователей и темпользователям, 
у которых дата рождения меньше определенной даты обновить дату рождения на сегодняшнюю дату. 
(реализация с помощью цикла)
*/
DELIMITER //
DROP PROCEDURE IF EXISTS birth_date_change//
CREATE PROCEDURE birth_date_change(some_date date)
	BEGIN
		DECLARE i INT DEFAULT 10;
		WHILE i > 0 DO 
			UPDATE profiles 
			SET birthday = CURDATE()  
			WHERE birthday < some_date;
            SET i = i - 1;
		END WHILE;
	END//
DELIMITER ;

CALL birth_date_change('1994-06-15');