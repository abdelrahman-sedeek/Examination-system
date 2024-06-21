
-- Roles
CREATE ROLE AdminRole;
CREATE ROLE TrainingManagerRole;
CREATE ROLE InstructorRole;
CREATE ROLE StudentRole;

--Create schemas
CREATE SCHEMA admin;

CREATE SCHEMA instructor;

CREATE SCHEMA Student;

CREATE SCHEMA TrainingManager;



-- Admin permissions (full access)

GRANT CONTROL ON SCHEMA::Admin TO AdminRole;
GRANT CONTROL ON SCHEMA::TrainingManager TO AdminRole; 
GRANT CONTROL ON SCHEMA::Instructor TO AdminRole;
GRANT CONTROL ON SCHEMA::Student TO AdminRole;


-- Training Manager permissions (access to manage branches, tracks, intakes, and students)

GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::TrainingManager TO TrainingManagerRole;   

-- instructor permissions

GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::Instructor TO InstructorRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON Student.Students TO InstructorRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON Student.StudentExams TO InstructorRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON Student.StudentAnswers TO InstructorRole;


-- student permissions

GRANT SELECT, INSERT ON SCHEMA::Student TO StudentRole;
GRANT  INSERT ON Student.StudentAnswers TO StudentRole;
GRANT SELECT ON Student.StudentExams TO StudentRole;
REVOKE SELECT, INSERT, UPDATE, DELETE ON Student.Students FROM StudentRole;





--Admin
ALTER SCHEMA Admin TRANSFER dbo.Users;

--training maneger

ALTER SCHEMA TrainingManager TRANSFER dbo.TrainingManeger;
ALTER SCHEMA TrainingManager TRANSFER dbo.Departments;
ALTER SCHEMA TrainingManager TRANSFER dbo.Branches;
ALTER SCHEMA TrainingManager TRANSFER dbo.Tracks;
ALTER SCHEMA TrainingManager TRANSFER dbo.Intakes;

-- Instructor

ALTER SCHEMA Instructor TRANSFER dbo.Instructors;
ALTER SCHEMA Instructor TRANSFER dbo.Courses;
ALTER SCHEMA Instructor TRANSFER dbo.Questions;
ALTER SCHEMA Instructor TRANSFER dbo.Exams;
ALTER SCHEMA Instructor TRANSFER dbo.ExamQuestions;

-- student
ALTER SCHEMA Student TRANSFER dbo.Students;
ALTER SCHEMA Student TRANSFER dbo.StudentExams;
ALTER SCHEMA Student TRANSFER dbo.StudentAnswers;



CREATE LOGIN AdminUser WITH PASSWORD = '123456';
CREATE LOGIN TrainingManagerUser WITH PASSWORD = '123456';
CREATE LOGIN InstructorUser WITH PASSWORD = '123456';
CREATE LOGIN StudentUser WITH PASSWORD = '123456';
CREATE LOGIN doha111 WITH PASSWORD = '123456';
CREATE LOGIN aaa WITH PASSWORD = '123456';

