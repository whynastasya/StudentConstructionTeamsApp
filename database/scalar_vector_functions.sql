-- Создание скалярной функции
CREATE OR REPLACE FUNCTION calculate_age(birthdate DATE)
RETURNS INT AS $$
DECLARE
    age INT;
BEGIN
    age := EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM birthdate);
    RETURN age;
END;
$$ LANGUAGE plpgsql;

-- Создание векторной функции
CREATE OR REPLACE FUNCTION get_tasks_in_team(team_name VARCHAR(30))
RETURNS TABLE (
    task_id INT,
    task_name VARCHAR(30),
    task_type_name VARCHAR(30),
    task_hours INT,
    task_status_name VARCHAR(30)
) AS $$
BEGIN
    RETURN QUERY
    SELECT t.ID, t.name, tt.name AS task_type_name, t.hours, ts.name AS task_status_name
    FROM task t
    JOIN task_type tt ON t.typeID = tt.ID
    JOIN team tm ON t.teamID = tm.ID
    JOIN task_status ts ON t.statusID = ts.ID
    WHERE tm.name = team_name;
END;
$$ LANGUAGE plpgsql;
