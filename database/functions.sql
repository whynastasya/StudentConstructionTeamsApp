-- student_group
CREATE OR REPLACE FUNCTION add_student_group(
    p_name VARCHAR(40),
    p_departament VARCHAR(40)
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO student_group (name, departament) VALUES (p_name, p_departament);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_student_group(
    p_id INT,
    p_name VARCHAR(40),
    p_departament VARCHAR(40)
)
RETURNS VOID AS $$
BEGIN
    UPDATE student_group SET name = p_name, departament = p_departament WHERE ID = p_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION delete_student_group(p_id INT)
RETURNS VOID AS $$
BEGIN
    DELETE FROM student_group WHERE ID = p_id;
END;
$$ LANGUAGE plpgsql;

-- user_type
CREATE OR REPLACE FUNCTION add_user_type(
    p_name VARCHAR(20)
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO user_type (name) VALUES (p_name);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_user_type(
    p_id INT,
    p_name VARCHAR(20)
)
RETURNS VOID AS $$
BEGIN
    UPDATE user_type SET name = p_name WHERE ID = p_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION delete_user_type(p_id INT)
RETURNS VOID AS $$
BEGIN
    DELETE FROM user_type WHERE ID = p_id;
END;
$$ LANGUAGE plpgsql;

-- my_user
CREATE OR REPLACE FUNCTION add_my_user(
    p_surname VARCHAR(40),
    p_name VARCHAR(40),
    p_patronymic VARCHAR(40),
    p_birthdate DATE,
    p_phone VARCHAR(15),
    p_password VARCHAR(30),
    p_user_type_ID INT
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO my_user (surname, name, patronymic, birthdate, phone, password, user_type_ID) 
    VALUES (p_surname, p_name, p_patronymic, p_birthdate, p_phone, p_password, p_user_type_ID);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_my_user(
    p_id INT,
    p_surname VARCHAR(40),
    p_name VARCHAR(40),
    p_patronymic VARCHAR(40),
    p_birthdate DATE,
    p_phone VARCHAR(15),
    p_password VARCHAR(30),
    p_user_type_ID INT
)
RETURNS VOID AS $$
BEGIN
    UPDATE my_user 
    SET surname = p_surname, name = p_name, patronymic = p_patronymic, 
        birthdate = p_birthdate, phone = p_phone, password = p_password, 
        user_type_ID = p_user_type_ID 
    WHERE ID = p_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION delete_my_user(p_id INT)
RETURNS VOID AS $$
BEGIN
    DELETE FROM my_user WHERE ID = p_id;
END;
$$ LANGUAGE plpgsql;

-- team
CREATE OR REPLACE FUNCTION add_team(
    p_name VARCHAR(30)
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO team (name) VALUES (p_name);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_team(
    p_id INT,
    p_name VARCHAR(30)
)
RETURNS VOID AS $$
BEGIN
    UPDATE team SET name = p_name WHERE ID = p_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION delete_team(p_id INT)
RETURNS VOID AS $$
BEGIN
    DELETE FROM team WHERE ID = p_id;
END;
$$ LANGUAGE plpgsql;

-- student
CREATE OR REPLACE FUNCTION add_student(
    p_userID INT,
    p_is_elder BOOLEAN,
    p_earnings INT,
    p_groupID INT,
    p_teamID INT
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO student (userID, is_elder, earnings, groupID, teamID) 
    VALUES (p_userID, p_is_elder, p_earnings, p_groupID, p_teamID);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_student(
    p_id INT,
    p_userID INT,
    p_is_elder BOOLEAN,
    p_earnings INT,
    p_groupID INT,
    p_teamID INT
)
RETURNS VOID AS $$
BEGIN
    UPDATE student 
    SET userID = p_userID, is_elder = p_is_elder, earnings = p_earnings, 
        groupID = p_groupID, teamID = p_teamID 
    WHERE ID = p_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION delete_student(p_id INT)
RETURNS VOID AS $$
BEGIN
    DELETE FROM student WHERE ID = p_id;
END;
$$ LANGUAGE plpgsql;

-- team_director
CREATE OR REPLACE FUNCTION add_team_director(
    p_userID INT,
    p_teamID INT
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO team_director (userID, teamID) VALUES (p_userID, p_teamID);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_team_director(
    p_id INT,
    p_userID INT,
    p_teamID INT
)
RETURNS VOID AS $$
BEGIN
    UPDATE team_director SET userID = p_userID, teamID = p_teamID WHERE ID = p_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION delete_team_director(p_id INT)
RETURNS VOID AS $$
BEGIN
    DELETE FROM team_director WHERE ID = p_id;
END;
$$ LANGUAGE plpgsql;

-- task_status
CREATE OR REPLACE FUNCTION add_task_status(
    p_name VARCHAR(30)
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO task_status (name) VALUES (p_name);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_task_status(
    p_id INT,
    p_name VARCHAR(30)
)
RETURNS VOID AS $$
BEGIN
    UPDATE task_status SET name = p_name WHERE ID = p_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION delete_task_status(p_id INT)
RETURNS VOID AS $$
BEGIN
    DELETE FROM task_status WHERE ID = p_id;
END;
$$ LANGUAGE plpgsql;

-- task_type
CREATE OR REPLACE FUNCTION add_task_type(
    p_name VARCHAR(30),
    p_rate_per_hour INT
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO task_type (name, rate_per_hour) VALUES (p_name, p_rate_per_hour);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_task_type(
    p_id INT,
    p_name VARCHAR(30),
    p_rate_per_hour INT
)
RETURNS VOID AS $$
BEGIN
    UPDATE task_type SET name = p_name, rate_per_hour = p_rate_per_hour WHERE ID = p_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION delete_task_type(p_id INT)
RETURNS VOID AS $$
BEGIN
    DELETE FROM task_type WHERE ID = p_id;
END;
$$ LANGUAGE plpgsql;

-- task
CREATE OR REPLACE FUNCTION add_task(
    p_typeID INT,
    p_hours INT,
    p_statusID INT,
    p_teamID INT,
    p_start_date DATE,
    p_end_date DATE
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO task (typeID, hours, statusID, teamID, start_date, end_date) 
    VALUES (p_typeID, p_hours, p_statusID, p_teamID, p_start_date, p_end_date);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_task(
    p_id INT,
    p_typeID INT,
    p_hours INT,
    p_statusID INT,
    p_teamID INT,
    p_start_date DATE,
    p_end_date DATE
)
RETURNS VOID AS $$
BEGIN
    UPDATE task 
    SET typeID = p_typeID, hours = p_hours, statusID = p_statusID, 
        teamID = p_teamID, start_date = p_start_date, end_date = p_end_date 
    WHERE ID = p_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION delete_task(p_id INT)
RETURNS VOID AS $$
BEGIN
    DELETE FROM task WHERE ID = p_id;
END;
$$ LANGUAGE plpgsql;

-- staying_in_team
CREATE OR REPLACE FUNCTION add_staying_in_team(
    p_teamID INT,
    p_studentID INT,
    p_start_date DATE,
    p_end_date DATE
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO staying_in_team (teamID, studentID, start_date, end_date) 
    VALUES (p_teamID, p_studentID, p_start_date, p_end_date);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_staying_in_team(
    p_id INT,
    p_teamID INT,
    p_studentID INT,
    p_start_date DATE,
    p_end_date DATE
)
RETURNS VOID AS $$
BEGIN
    UPDATE staying_in_team 
    SET teamID = p_teamID, studentID = p_studentID, 
        start_date = p_start_date, end_date = p_end_date 
    WHERE ID = p_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION delete_staying_in_team(p_id INT)
RETURNS VOID AS $$
BEGIN
    DELETE FROM staying_in_team WHERE ID = p_id;
END;
$$ LANGUAGE plpgsql;
