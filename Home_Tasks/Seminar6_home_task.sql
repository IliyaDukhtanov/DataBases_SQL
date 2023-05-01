use semimar4;

/*
1. Создайте таблицу users_old, аналогичную таблице users. 
Создайте процедуру, с помощью которой можно переместить любого (одного) пользователя из таблицы users в таблицу users_old. 
(использование транзакции с выбором commit или rollback – обязательно).
*/

DROP TABLE IF EXISTS users_old;
CREATE TABLE users_old 
(
	id SERIAL PRIMARY KEY, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
    firstname VARCHAR(50),
    lastname VARCHAR(50) COMMENT 'Фамилия',
    email VARCHAR(120) UNIQUE
);
select * from users_old;
select * from users;

-- Создаю временную таблицe users_1 с данными пользователей, чтобы не удалять данные из оригинальной таблицы users
DROP TABLE IF EXISTS users_1;
CREATE TEMPORARY TABLE users_1 LIKE users;
INSERT INTO users_1 SELECT * FROM users;
select * from users_1;
DESC users_1;

DELIMITER // 
DROP PROCEDURE IF EXISTS replace_user //
CREATE PROCEDURE replace_user(search_user_id int)  -- процедура с вводом id пользователя для перемещения
BEGIN 
	START TRANSACTION;
    INSERT INTO users_old (id, firstname, lastname, email)
	SELECT * 
	FROM users_1
	WHERE id = search_user_id;
    DELETE FROM users_1
	WHERE id = search_user_id;
    COMMIT;   -- подтверждаю изменения
END //
DELIMITER ;
CALL replace_user(1);

/* 
2. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
с 18:00 до 00:00 — "Добрый вечер", 
с 00:00 до 6:00 — "Доброй ночи".
*/

DROP FUNCTION IF EXISTS hello;

DELIMITER //
CREATE FUNCTION hello()
RETURNS TEXT DETERMINISTIC
BEGIN
RETURN 
(SELECT IF (CURTIME() >= '06:00:00' AND CURTIME() < '12:00:00', 'Доброе утро!', 
	IF (CURTIME() >= '12:00:00' AND CURTIME() < '18:00:00', 'Добрый день!',
		IF (CURTIME() >= '18:00:00' AND CURTIME() < '00:00:00', 'Добрый вечер!', 
'Доброй ночи!'))));
END//
DELIMITER ;

SELECT hello() AS Приветствие;

/*
3. (по желанию)* 
Создайте таблицу logs типа Archive. 
Пусть при каждом создании записи в таблицах users, communities и messages 
в таблицу logs помещается время и дата создания записи, название таблицы, идентификатор первичного ключа.
*/
DROP TABLE IF EXISTS logs_tab;
CREATE TABLE logs_tab
(
id INT UNSIGNED NOT NULL,
name_of_table VARCHAR(20) NOT NULL,
date_time TIMESTAMP NOT NULL
)
ENGINE = ARCHIVE;

DROP TRIGGER IF EXISTS users_log;
CREATE TRIGGER users_log AFTER INSERT
ON users FOR EACH ROW
INSERT INTO logs_tab 
SET id = NEW.id, date_time = NOW(), name_of_table = 'users';

-- INSERT INTO users (firstname, lastname, email) VALUES 
-- ('Will', 'Smith', 'ws@google.com');

DROP TRIGGER IF EXISTS communities_log;
CREATE TRIGGER communities_log AFTER INSERT
ON communities FOR EACH ROW
INSERT INTO logs_tab
SET id = NEW.id, date_time = NOW(), name_of_table = 'communities';

-- INSERT INTO communities (name) 
-- VALUES ('kotiki');

DROP TRIGGER IF EXISTS messages_log;
CREATE TRIGGER messages_log AFTER INSERT
ON messages FOR EACH ROW
INSERT INTO logs_tab
SET id = NEW.id, date_time = NOW(), name_of_table = 'messages';

-- INSERT INTO messages (from_user_id, to_user_id, body, created_at) 
-- VALUES
-- (10, 8, 'Как дела?', DATE_ADD(NOW(), INTERVAL 1 MINUTE));
