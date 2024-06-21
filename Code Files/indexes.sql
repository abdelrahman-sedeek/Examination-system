/*Indexes are a crucial part of database design and optimization. They are used to improve the speed of data retrieval operations on a database
table at the cost of additional space and some overhead on data modification operations such as inserts, updates, and deletes.*/

-- Instructor table
CREATE UNIQUE INDEX InstructorID_Email ON instructor.Instructors (InstructorID, Email);
ALTER INDEX InstructorID_Email ON instructor.Instructors REBUILD;

-- TrainingManager Table
CREATE UNIQUE INDEX TrainingManager_TrainingManagerID_Email ON TrainingManager.TrainingManeger (TrainingManegerID, Email);
ALTER INDEX TrainingManager_TrainingManagerID_Email ON TrainingManager.TrainingManeger REBUILD;


-- Departments Table
CREATE UNIQUE INDEX DepartmentID ON TrainingManager.Departments (DepartmentID);
ALTER INDEX DepartmentID ON TrainingManager.Departments REBUILD;

-- Branches Table
CREATE UNIQUE INDEX BranchID_DepartmentID ON TrainingManager.Branches (BranchID, DepartmentID);
ALTER INDEX BranchID_DepartmentID ON TrainingManager.Branches REBUILD;

-- Tracks Table
CREATE UNIQUE INDEX TrackID_BranchID ON TrainingManager.Tracks (TrackID, BranchID);
ALTER INDEX TrackID_BranchID ON TrainingManager.Tracks REBUILD;

-- Intakes Table
CREATE UNIQUE INDEX IntakeID_BranchID ON TrainingManager.Intakes (IntakeID, BranchID);
ALTER INDEX IntakeID_BranchID ON TrainingManager.Intakes REBUILD;

-- Students Table
CREATE UNIQUE INDEX StudentID_Email ON Student.Students (StudentID, Email);
CREATE INDEX Students_IntakeID_BranchID_TrackID ON Student.Students (IntakeID, BranchID, TrackID);
ALTER INDEX StudentID_Email ON Student.Students REBUILD;
ALTER INDEX Students_IntakeID_BranchID_TrackID ON Student.Students REBUILD;

-- Users Table
CREATE UNIQUE INDEX UserID_Username ON Admin.Users (UserID, Username);
CREATE INDEX Users_StudentID_InstructorID_TrainingManagerID ON Admin.Users (StudentID, InstructorID, TrainingManegerID);
ALTER INDEX UserID_Username ON Admin.Users REBUILD;
ALTER INDEX Users_StudentID_InstructorID_TrainingManagerID ON Admin.Users REBUILD;

-- Questions Table
CREATE UNIQUE INDEX QuestionID_CourseID ON instructor.Questions (QuestionID, CourseID);
ALTER INDEX QuestionID_CourseID ON instructor.Questions REBUILD;

-- Exams Table
CREATE UNIQUE INDEX ExamID ON instructor.Exams (ExamID);
CREATE INDEX Exams_CourseID_InstructorID_IntakeID_BranchID_TrackID ON instructor.Exams (CourseID, InstructorID, IntakeID, BranchID, TrackID);
ALTER INDEX ExamID ON instructor.Exams REBUILD;
ALTER INDEX Exams_CourseID_InstructorID_IntakeID_BranchID_TrackID ON instructor.Exams REBUILD;

-- ExamQuestions Table
CREATE UNIQUE INDEX ExamQuestionID_ExamID_QuestionID ON instructor.ExamQuestions (ExamQuestionID, ExamID, QuestionID);
ALTER INDEX ExamQuestionID_ExamID_QuestionID ON instructor.ExamQuestions REBUILD;

-- StudentExams Table
CREATE UNIQUE INDEX StudentExamID_StudentID_ExamID ON Student.StudentExams (StudentExamID, StudentID, ExamID);
ALTER INDEX StudentExamID_StudentID_ExamID ON Student.StudentExams REBUILD;

-- StudentAnswers Table
CREATE UNIQUE INDEX StudentAnswerID_StudentExamID_QuestionID ON Student.StudentAnswers (StudentAnswerID, StudentExamID, QuestionID);
ALTER INDEX StudentAnswerID_StudentExamID_QuestionID ON Student.StudentAnswers REBUILD;








SET STATISTICS IO ON;
SET STATISTICS TIME ON;

-- Your query
SELECT *
FROM Student.Students
WHERE Email = 'alice.johnson@example.com';

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;


/*                           SET STATISTICS IO ON
This command enables the display of I/O statistics for each table referenced in the query. It shows the number of logical reads, 
physical reads, read-ahead reads, and other I/O operations.

                            SET STATISTICS TIME ON
This command enables the display of the amount of time (in milliseconds) that the server spends on parsing, compiling, and executing a query.*/