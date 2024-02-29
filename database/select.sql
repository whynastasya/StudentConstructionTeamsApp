SELECT
    my_user.name || ' ' || my_user.surname || ' ' || my_user.patronymic AS student_name,
    student_group.name AS group_name,
    team.name AS team_name,
    CASE
        WHEN staying_in_team.start_date IS NOT NULL THEN 'В команде'
        ELSE 'Свободен'
    END AS staying_status
FROM student 
JOIN my_user ON student.userID = my_user.ID
JOIN student_group ON student.groupID = student_group.ID
LEFT JOIN staying_in_team ON student.ID = staying_in_team.studentID
JOIN team ON student.teamID = team.ID;

-- Создание многотабличного представления
CREATE OR REPLACE VIEW team_summary AS
SELECT
    team.name AS team_name,
    COUNT(student.ID) AS total_students,
    AVG(student.earnings) AS average_earnings,
    MAX(staying_in_team.start_date) AS latest_stay_start
FROM team 
LEFT JOIN student ON team.ID = student.teamID
LEFT JOIN staying_in_team ON student.ID = staying_in_team.studentID
GROUP BY team.name;
	
CREATE OR REPLACE FUNCTION update_team_summary_trigger()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO team_summary VALUES (NEW.*);
        RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE team_summary SET
            team_name = NEW.name
        WHERE team_name = OLD.name;
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM team_summary WHERE team_name = OLD.name;
        RETURN OLD;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER team_summary_trigger
AFTER INSERT OR UPDATE OR DELETE ON team
FOR EACH ROW EXECUTE FUNCTION update_team_summary_trigger();

-- --------------
SELECT
    my_user.surname || ' ' || my_user.name || ' ' || my_user.patronymic AS full_name,
    (SELECT name FROM student_group WHERE ID = student.groupID) AS group_name
FROM student
JOIN my_user ON student.userID = my_user.ID;

SELECT surname || ' ' || name || ' ' || patronymic AS full_name
FROM (SELECT * FROM my_user WHERE EXTRACT(YEAR FROM birthdate) IN (2004, 1979)) AS td;

SELECT
    task.ID,
    task.hours,
    (SELECT AVG(hours) FROM task) AS overall_average_hours
FROM task
WHERE task.hours > (SELECT AVG(hours) FROM task);

-- ----------------

SELECT
    team.name AS team_name,
    task.ID AS task_id,
    task.hours,
    (SELECT AVG(task2.hours) FROM task task2 WHERE task2.teamID = team.ID AND task2.ID <> task.ID) AS average_hours_in_team
FROM task
JOIN team ON task.teamID = team.ID;

SELECT
    team.name AS team_name,
    SUM(student.earnings) AS total_earnings_in_team
FROM team
JOIN student ON team.ID = student.teamID
WHERE
    EXISTS (SELECT 1 FROM student student2 WHERE student2.teamID = team.ID AND 
			student2.earnings > (SELECT AVG(earnings) FROM student student3 WHERE student3.teamID = team.ID))
GROUP BY team.name;

SELECT
    my_user.surname || ' ' || my_user.name || ' ' || my_user.patronymic AS full_name,
    team.name AS team_name
FROM student
JOIN my_user ON student.userID = my_user.ID
JOIN team ON student.teamID = team.ID
WHERE EXISTS (SELECT 1 FROM task WHERE teamID = team.ID AND 
			  statusID = (SELECT ID FROM task_status WHERE name = 'Выполнено'));

-- ------------

SELECT
    team.name AS team_name,
    COUNT(student.ID) AS total_students,
    AVG(student.earnings) AS average_earnings
FROM team
JOIN student ON team.ID = student.teamID
GROUP BY team.name
HAVING AVG(student.earnings) > 2000;

    -- -----------\

SELECT
    sg.name AS group_name
FROM
    student_group sg
WHERE
    sg.ID = ANY (
        SELECT
            s.groupID
        FROM
            student s
        WHERE
            s.ID = ANY (
                SELECT
                    t.teamID
                FROM
                    task t
                WHERE
                    t.hours >= ALL (
                        SELECT
                            AVG(t2.hours)
                        FROM
                            task t2
                    )
            )
    );








