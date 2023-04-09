-- SELECT name_student, email 
-- FROM students;

-- SELECT name_student 
-- FROM students
-- WHERE name_student LIKE "А___"

-- CREATE TABLE workers (
-- id INT PRIMARY KEY, 
-- name_worker VARCHAR (45) NOT NULL,
-- dept VARCHAR (45) NOT NULL,
-- salary INT DEFAULT 0
-- );

-- INSERT workers 
-- VALUES 
-- (100, 'AndreyEx', 'Sales', 5000),
-- (200, 'Boris', 'IT', 5500),
-- (300, 'Anna', 'IT', 7000),
-- (400, 'Anton', 'Marketing', 9500),
-- (500, 'Dima', 'IT', 6000),
-- (501, 'Maxs', 'Accounting', NULL);

-- SELECT * FROM workers;

-- SELECT * 
-- FROM workers
-- WHERE salary > 6000; 

-- SELECT * 
-- FROM workers
-- WHERE dept = 'IT';

SELECT * 
FROM workers
WHERE dept != 'IT';

