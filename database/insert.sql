-- Добавление групп студентов
INSERT INTO student_group (name, departament) VALUES
  ('Group A', 'Computer Science'),
  ('Group B', 'Mathematics'),
  ('Group C', 'Physics'),
  ('Group D', 'Biology');

-- Добавление пользователей (студентов)
INSERT INTO my_user (surname, name, patronymic, birthdate, phone, password) VALUES
  ('Smith', 'John', 'Michael', '1990-05-15', '1234567890', 'password1'),
  ('Johnson', 'Emily', 'Grace', '1992-08-22', '9876543210', 'password2'),
  ('Williams', 'Daniel', 'Joseph', '1991-03-07', '5556667777', 'password3'),
  ('Davis', 'Sophia', 'Elizabeth', '1993-11-30', '9998887777', 'password4');

-- Добавление команд
INSERT INTO team (name, count_students) VALUES
  ('Team 1', 5),
  ('Team 2', 4),
  ('Team 3', 6),
  ('Team 4', 3);

-- Добавление студентов
INSERT INTO student (ID, groupID, teamID) VALUES
  (1, 1, 1, FALSE, 0),
  (2, 2, 2, FALSE, 0),
  (3, 3, 3, TRUE, 50),
  (4, 4, NULL, FALSE, 0);

-- Добавление директоров команд
INSERT INTO team_director (ID, teamID) VALUES
  (1, 1),
  (2, 2),
  (3, 3),
  (4, NULL);

-- Добавление статусов задач
INSERT INTO task_status (name) VALUES
  ('Свободно'),
  ('В работе'),
  ('Выполнено');

-- Добавление типов задач
INSERT INTO task_type (name, rate_per_hour) VALUES
  ('Research', 10),
  ('Development', 15),
  ('Testing', 12),
  ('Documentation', 8);

-- Добавление задач
INSERT INTO task (typeID, hours, statusID, teamID, start_date, end_date) VALUES
  (1, 20, 1, 1, '2024-01-01', '2024-01-20'),
  (2, 15, 2, 2, '2024-02-01', '2024-02-15'),
  (3, 25, 1, 3, '2024-03-01', '2024-03-25'),
  (4, 10, 3, NULL, '2024-04-01', '2024-04-10');

-- Добавление записей о пребывании в команде
INSERT INTO staying_in_team (teamID, studentID, start_date, end_date) VALUES
  (1, 1, '2024-01-01', '2024-01-15'),
  (2, 2, '2024-02-01', '2024-02-10'),
  (3, 3, '2024-03-01', '2024-03-20'),
  (3, 4, '2024-03-01', '2024-03-20');
