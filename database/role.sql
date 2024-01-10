CREATE ROLE team_director;
CREATE ROLE student;
CREATE ROLE admin;

CREATE USER team_director_user WITH PASSWORD '1234';
CREATE USER student_user WITH PASSWORD 'student';
CREATE USER admin_user WITH PASSWORD 'admin';

GRANT team_director TO team_director_user;
GRANT student TO student_user;
GRANT admin TO admin_user;

GRANT SELECT, UPDATE ON TABLE my_user TO team_director;
GRANT SELECT, UPDATE ON TABLE team_director TO team_director;
GRANT SELECT, UPDATE ON TABLE team TO team_director;
GRANT SELECT, UPDATE ON TABLE task TO team_director;

GRANT SELECT, UPDATE ON TABLE my_user TO student;
GRANT SELECT, UPDATE ON TABLE student TO student;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin;