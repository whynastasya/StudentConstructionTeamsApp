CREATE INDEX idx_user_phone ON my_user(phone);

CREATE INDEX idx_student_group_id ON student USING hash (groupID);

CREATE INDEX idx_task_start_date ON task (start_date);
