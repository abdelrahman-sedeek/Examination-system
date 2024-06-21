--Check Exam Time
CREATE or ALTER TRIGGER Student.trg_CheckExamTime
ON Student.StudentExams
AFTER INSERT
AS
BEGIN
    DECLARE @StudentID INT, @ExamID INT, @StartTime DATETIME, @EndTime DATETIME
    SELECT @StudentID = i.StudentID, @ExamID = i.ExamID, @StartTime = i.StartTime, @EndTime = i.EndTime
    FROM inserted i

    DECLARE @ExamStartTime DATETIME, @ExamEndTime DATETIME
    SELECT @ExamStartTime = e.StartTime, @ExamEndTime = e.EndTime
    FROM instructor.Exams e
    WHERE e.ExamID = @ExamID

    IF @StartTime < @ExamStartTime
    BEGIN
       Print'Error: Exam has not started yet.' -- State 1: Exam not started
        ROLLBACK TRANSACTION
        RETURN
    END

    IF @StartTime > @ExamEndTime or @EndTime > @ExamEndTime
    BEGIN
        Print'Error: Exam time has already ended.'
        ROLLBACK TRANSACTION
        RETURN
    END

END
GO




--########################################################################################################################################




--Ensure Exam Degree Does Not Exceed Course Max Degree
CREATE OR ALTER  TRIGGER instructor.trg_CheckExamTotalDegree
ON instructor.ExamQuestions
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @CourseID INT, @ExamID INT, @TotalDegree DECIMAL(5,2);

    SELECT @ExamID = INSERTED.ExamID FROM INSERTED;
    
    SELECT @CourseID = e.CourseID
    FROM instructor.Exams e
    WHERE e.ExamID = @ExamID;

    SELECT @TotalDegree = SUM(eq.Degree)
    FROM instructor.ExamQuestions eq
    INNER JOIN instructor.Exams e ON eq.ExamID = e.ExamID
    WHERE e.CourseID = @CourseID;

    IF @TotalDegree > (SELECT c.MaxDegree FROM instructor.Courses c WHERE c.CourseID = @CourseID)
    BEGIN
        Print'Total degree for the exam exceeds the maximum allowed degree for the course.'
        ROLLBACK TRANSACTION;
    END
END;





--#####################################################################################################################################



--Ensure Student Cannot Take the Same Exam Twice

CREATE OR Alter TRIGGER Student.trg_PreventTakeExamTwice
ON Student.StudentExams
AFTER INSERT
AS
BEGIN
    DECLARE @StudentID INT, @ExamID INT;

    SELECT @StudentID = i.StudentID, @ExamID = i.ExamID
    FROM INSERTED i

    IF EXISTS (
        SELECT 1
        FROM Student.StudentExams
        WHERE StudentID = @StudentID AND ExamID = @ExamID 
		AND StudentExamID <> (SELECT TOP 1 StudentExamID FROM INSERTED))
    BEGIN
        
        Print'You have already taken this exam.'
        ROLLBACK TRANSACTION;
    END
END






