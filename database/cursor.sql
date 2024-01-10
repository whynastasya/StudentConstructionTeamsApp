
CREATE OR REPLACE FUNCTION update_task_costs()
RETURNS VOID AS $$
DECLARE
    task_cursor CURSOR FOR
        SELECT t.ID, t.typeID, tt.rate_per_hour, t.hours
        FROM task t
        JOIN task_type tt ON t.typeID = tt.ID;
    task_record RECORD;
    new_cost INT;
BEGIN
    OPEN task_cursor;

    LOOP
        FETCH task_cursor INTO task_record;
        EXIT WHEN NOT FOUND;

        new_cost := task_record.rate_per_hour * task_record.hours;

        UPDATE task
        SET cost = new_cost
        WHERE ID = task_record.ID;
    END LOOP;

    CLOSE task_cursor;
END;
$$ LANGUAGE plpgsql;
