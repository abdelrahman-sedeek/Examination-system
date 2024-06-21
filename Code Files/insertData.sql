-- Insert data into Courses table
INSERT INTO instructor.Courses (CourseName, Description, MaxDegree, MinDegree) VALUES
('Mathematics', 'Basic Mathematics Course', 100.0, 50.0),
('Physics', 'Basic Physics Course', 100.0, 50.0),
('Chemistry', 'Basic Chemistry Course', 100.0, 50.0),
('Biology', 'Basic Biology Course', 100.0, 50.0),
('Computer Science', 'Basic Computer Science Course', 100.0, 50.0);

-- Insert data into Departments table
INSERT INTO TrainingManager.Departments (DepartmentName) VALUES
('Science'),
('Arts'),
('Commerce'),
('Engineering'),
('Medicine');

-- Insert data into Branches table
INSERT INTO TrainingManager.Branches (BranchName, DepartmentID) VALUES
('Mathematics Branch', 1),
('Physics Branch', 1),
('Chemistry Branch', 1),
('Biology Branch', 1),
('Computer Science Branch', 4);

-- Insert data into Tracks table
INSERT INTO TrainingManager.Tracks (TrackName, BranchID) VALUES
('Mathematics Track', 1),
('Physics Track', 2),
('Chemistry Track', 3),
('Biology Track', 4),
('Computer Science Track', 5);

-- Insert data into Intakes table
INSERT INTO TrainingManager.Intakes (IntakeName, BranchID) VALUES
('Intake 2021', 1),
('Intake 2022', 2),
('Intake 2023', 3),
('Intake 2024', 4),
('Intake 2025', 5);

-- Insert data into Students table
INSERT INTO Student.Students (FirstName, LastName, Email, IntakeID, BranchID, TrackID, CourseID) VALUES
('Alice', 'Johnson', 'alice.johnson@example.com', 1, 1, 1, 1),
('Bob', 'Smith', 'bob.smith@example.com', 2, 2, 2, 2),
('Charlie', 'Brown', 'charlie.brown@example.com', 3, 3, 3, 3),
('Diana', 'Prince', 'diana.prince@example.com', 4, 4, 4, 4),
('Evan', 'Wright', 'evan.wright@example.com', 5, 5, 5, 5);

-- Insert data into Instructors table
INSERT INTO instructor.Instructors (FirstName, LastName, Email, CourseID) VALUES
('John', 'Doe', 'john.doe@example.com', 1),
('Jane', 'Smith', 'jane.smith@example.com', 2),
('Emily', 'Davis', 'emily.davis@example.com', 3),
('Michael', 'Wilson', 'michael.wilson@example.com', 4),
('Sarah', 'Taylor', 'sarah.taylor@example.com', 5);

-- Insert data into TrainingManeger table
INSERT INTO TrainingManager.TrainingManeger (FirstName, LastName, Email) VALUES
('Andrew', 'Scott', 'andrew.scott@example.com'),
('Olivia', 'Brown', 'olivia.brown@example.com'),
('Lucas', 'Jones', 'lucas.jones@example.com'),
('Sophia', 'Garcia', 'sophia.garcia@example.com'),
('James', 'Martinez', 'james.martinez@example.com');

-- Insert data into Questions table
INSERT INTO instructor.Questions (QuestionText, QuestionType, MultiAnswer, TrueFlaseAnswer, TextAnswer, BestAcceptedAnswer, CourseID) VALUES
('What is 2 + 2?', 'Text', NULL, NULL, '4', '4', 1),
('Is the earth round?', 'T&F', NULL, 1, NULL, '1', 2),
('What is H2O?', 'Text', NULL, NULL, 'Water', 'Water', 3),
('What is the powerhouse of the cell?', 'Text', NULL, NULL, 'Mitochondria', 'Mitochondria', 4),
('What is the binary of 10?', 'Text', NULL, NULL, '1010', '1010', 5);

-- Insert data into Exams table
INSERT INTO instructor.Exams (CourseID, InstructorID, ExamType, IntakeID, BranchID, TrackID, StartTime, EndTime, TotalTime, AllowanceOptions) VALUES
(1, 1, 'Exam', 1, 1, 1, '2024-06-15 09:00:00', '2024-06-15 11:00:00', 120, 'None'),
(2, 2, 'Exam', 2, 2, 2, '2024-06-16 10:00:00', '2024-06-16 12:00:00', 120, 'None'),
(3, 3, 'Exam', 3, 3, 3, '2024-06-17 11:00:00', '2024-06-17 13:00:00', 120, 'None'),
(4, 4, 'Exam', 4, 4, 4, '2024-06-18 12:00:00', '2024-06-18 14:00:00', 120, 'None'),
(5, 5, 'Exam', 5, 5, 5, '2024-06-19 13:00:00', '2024-06-19 15:00:00', 120, 'None');

-- Insert data into ExamQuestions table
INSERT INTO instructor.ExamQuestions (ExamID, QuestionID, Degree) VALUES
(1, 1, 10.0),
(2, 2, 10.0),
(3, 3, 10.0),
(4, 4, 10.0),
(5, 5, 10.0);

-- Insert data into StudentExams table
INSERT INTO Student.StudentExams (StudentID, ExamID, StartTime, EndTime) VALUES
(1, 1, '2024-06-15 09:00:00', '2024-06-15 11:00:00'),
(2, 2, '2024-06-16 10:00:00', '2024-06-16 12:00:00'),
(3, 3, '2024-06-17 11:00:00', '2024-06-17 13:00:00'),
(4, 4, '2024-06-18 12:00:00', '2024-06-18 14:00:00'),
(5, 5, '2024-06-19 13:00:00', '2024-06-19 15:00:00');

-- Insert data into StudentAnswers table
INSERT INTO Student.StudentAnswers (StudentExamID, QuestionID, StudentAnswer, IsCorrect, IsValidAnswer) VALUES
(1, 1, '4', 1, 1),
(2, 2, '1', 1, 1),
(3, 3, 'Water', 1, 1),
(4, 4, 'Mitochondria', 1, 1),
(5, 5, '1010', 1, 1);

