CREATE TABLE student_group (
    ID SERIAL,
    name VARCHAR(40) NOT NULL UNIQUE,
    departament VARCHAR(40),
    PRIMARY KEY(ID)
);

CREATE TABLE my_user (
    ID SERIAL,
    surname VARCHAR(40) NOT NULL,
    name VARCHAR(40) NOT NULL,
    patronymic VARCHAR(40),
    birthdate DATE,
    phone VARCHAR(15) NOT NULL UNIQUE,
    password VARCHAR(30) NOT NULL,
    PRIMARY KEY(ID)
);

CREATE TABLE team (
    ID SERIAL,
    name VARCHAR(30) NOT NULL UNIQUE,
    count_students INT,
    PRIMARY KEY(ID)
);

CREATE TABLE student (
    ID INT NOT NULL,
    is_elder BOOLEAN DEFAULT FALSE,
    earnings INT DEFAULT 0,
    groupID INT NOT NULL,
    teamID INT,
    PRIMARY KEY(ID),
    CONSTRAINT user_id_fk FOREIGN KEY(ID) REFERENCES my_user(ID),
    CONSTRAINT group_id_fk FOREIGN KEY(groupID) REFERENCES student_group(ID),
    CONSTRAINT team_id_fk FOREIGN KEY(teamID) REFERENCES team(ID)
);

CREATE TABLE team_director (
    ID INT NOT NULL,
    teamID INT,
    PRIMARY KEY(ID),
    CONSTRAINT user_id_fk FOREIGN KEY(ID) REFERENCES my_user(ID),
    CONSTRAINT team_id_fk FOREIGN KEY(teamID) REFERENCES team(ID)
);

CREATE TABLE task_status (
    ID SERIAL,
    name VARCHAR(30) NOT NULL UNIQUE,
    PRIMARY KEY(ID)
);

CREATE TABLE task_type (
    ID SERIAL,
    name VARCHAR(30) NOT NULL UNIQUE,
    rate_per_hour INT NOT NULL,
    PRIMARY KEY(ID)
);

CREATE TABLE task ( 
    ID SERIAL,
    typeID INT NOT NULL,
    hours INT NOT NULL,
    statusID INT DEFAULT 1,
    teamID INT,
    start_date DATE,
    end_date DATE,
    PRIMARY KEY(ID),
    CONSTRAINT type_id_fk FOREIGN KEY (typeID) REFERENCES task_type(ID),
    CONSTRAINT status_id_fk FOREIGN KEY (statusID) REFERENCES task_status(ID),
    CONSTRAINT team_id_fk FOREIGN KEY (teamID) REFERENCES team(ID)
);

CREATE TABLE staying_in_team (
    ID SERIAL,
    teamID INT NOT NULL,
    studentID INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    PRIMARY KEY (ID),
    CONSTRAINT team_id_fk FOREIGN KEY (teamID) REFERENCES team(ID),
    CONSTRAINT student_id_fk FOREIGN KEY (studentID) REFERENCES student(ID)
);