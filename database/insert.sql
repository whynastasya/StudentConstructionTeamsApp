-- Вставки в таблицу student_group
INSERT INTO student_group (name, departament) VALUES
  ('Group A', 'Computer Science'),
  ('Group B', 'Physics'),
  ('Group C', 'Mathematics'),
  ('Group D', 'Chemistry'),
  ('Group E', 'Biology');

-- Вставки в таблицу user_type
INSERT INTO user_type (name) VALUES
  ('Admin'),
  ('Student'),
  ('Team Director');

-- Вставки в таблицу my_user
INSERT INTO my_user (surname, name, patronymic, birthdate, phone, password, user_type_ID) VALUES
  ('Smith', 'John', 'Michael', '1990-05-15', '123456789', 'password123', 2),
  ('Johnson', 'Alice', 'Grace', '1992-08-20', '987654321', 'pass456', 2),
  ('Williams', 'Robert', 'Thomas', '1985-03-10', '111222333', 'secret789', 3),
  ('Davis', 'Emily', 'Ann', '1998-12-05', '555666777', 'secure432', 2),
  ('Brown', 'David', 'William', '1994-06-25', '999000111', 'key123', 1);

-- Вставки в таблицу team
INSERT INTO team (name) VALUES
  ('Team X'),
  ('Team Y'),
  ('Team Z'),
  ('Team A'),
  ('Team B');

-- Вставки в таблицу student
INSERT INTO student (userID, is_elder, groupID, teamID, earnings) VALUES
  (1, TRUE, 1, 1, 100),
  (2, FALSE, 2, 1, 80),
  (3, TRUE, 3, 2, 120),
  (4, FALSE, 1, 3, 90),
  (5, TRUE, 2, 2, 110);

-- Вставки в таблицу team_director
INSERT INTO team_director (userID, teamID) VALUES
  (3, 1),
  (5, 2),
  (1, 3),
  (2, 4),
  (4, 5);

-- Вставки в таблицу task_status
INSERT INTO task_status (name) VALUES
  ('Pending'),
  ('In Progress'),
  ('Completed');

-- Вставки в таблицу task_type
INSERT INTO task_type (name, rate_per_hour) VALUES
  ('Programming', 10),
  ('Research', 8),
  ('Design', 12),
  ('Testing', 9),
  ('Documentation', 7);

-- Вставки в таблицу task
INSERT INTO task (typeID, hours, statusID, teamID, start_date, end_date) VALUES
  (1, 20, 1, 1, '2022-03-01', '2022-03-21'),
  (2, 15, 2, 2, '2022-04-05', '2022-04-20'),
  (3, 25, 1, 3, '2022-02-15', '2022-03-10'),
  (4, 18, 3, 4, '2022-04-10', '2022-04-28'),
  (5, 30, 1, 5, '2022-03-25', '2022-04-15');

-- Вставки в таблицу staying_in_team
INSERT INTO staying_in_team (teamID, studentID, start_date, end_date) VALUES
  (1, 1, '2021-09-01', '2022-06-30'),
  (2, 2, '2021-09-01', NULL),
  (3, 3, '2021-09-01', '2022-07-15'),
  (4, 4, '2021-09-01', NULL),
  (5, 5, '2021-09-01', '2022-08-31');
