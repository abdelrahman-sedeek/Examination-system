--function to get exam details along with questions

CREATE or ALTER FUNCTION Student.GetExamDetails (@ExamID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        q.QuestionID,
        q.QuestionText,
        q.QuestionType,
        eq.Degree
    FROM instructor.ExamQuestions eq
    INNER JOIN instructor.Questions q ON eq.QuestionID = q.QuestionID
    WHERE eq.ExamID = @ExamID
);








--###############################################################################################################################################
-- function to get all details of a student, including exams and total degree for each exam

CREATE or ALTER FUNCTION instructor.GetStudentDetails (@StudentID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        s.StudentID,
        s.FirstName,
        s.LastName,
        s.Email,
        i.IntakeName,
        b.BranchName,
        t.TrackName,
        se.ExamID,
        e.CourseID,
        e.InstructorID,
        e.ExamType,
        e.StartTime,
        e.EndTime,
        e.TotalTime ,      

        COALESCE(SUM(eq.Degree), 0) AS TotalDegree
    FROM Student.Students s
    LEFT JOIN TrainingManager.Intakes i ON s.IntakeID = i.IntakeID
    LEFT JOIN TrainingManager.Branches b ON s.BranchID = b.BranchID
    LEFT JOIN TrainingManager.Tracks t ON s.TrackID = t.TrackID
    LEFT JOIN Student.StudentExams se ON s.StudentID = se.StudentID
    LEFT JOIN instructor.Exams e ON se.ExamID = e.ExamID
    LEFT JOIN Student.StudentAnswers sa ON se.StudentExamID = sa.StudentExamID
    LEFT JOIN instructor.ExamQuestions eq ON sa.QuestionID = eq.QuestionID AND eq.ExamID = se.ExamID
    WHERE s.StudentID = @StudentID
    GROUP BY 
        s.StudentID,
        s.FirstName,
        s.LastName,
        s.Email,
        i.IntakeName,
        b.BranchName,
        t.TrackName,
        se.ExamID,
        e.CourseID,
        e.InstructorID,
        e.ExamType,
        e.StartTime,
        e.EndTime,
        e.TotalTime
      
);





--##############################################################################################################################################3


--I Used it for PROC SP_checkStudentAnswer to check the best accepted answer
CREATE OR ALTER FUNCTION instructor.ValidateStudentAnswer
(
    @StudentAnswer NVARCHAR(MAX),
    @BestAcceptedAnswer NVARCHAR(MAX)
)
RETURNS BIT
AS
BEGIN
    DECLARE @IsValid BIT;

	SET @StudentAnswer = LTRIM(RTRIM(@StudentAnswer))    --TEXT FUNCTION (LTRIM & RTRIM)
    SET @BestAcceptedAnswer = LTRIM(RTRIM(@BestAcceptedAnswer))

    IF @StudentAnswer LIKE '%' + @BestAcceptedAnswer + '%'  --REGULAR EXPRESSION (LIKE)
    BEGIN
        SET @IsValid = 1;
    END
    ELSE
    BEGIN
        SET @IsValid = 0;
    END

    RETURN @IsValid;
END;
