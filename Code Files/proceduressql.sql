CREATE OR ALTER PROC TrainingManager.sp_department 
@departmentName NVARCHAR(255)
AS
BEGIN
	insert into TrainingManager.Departments(DepartmentName) VALUES (@departmentName)
END

GRANT EXECUTE ON OBJECT:: TrainingManager.sp_department  TO TrainingManagerRole ;


--#######################################################################################################
CREATE OR ALTER PROCEDURE instructor.AddCourse 
    @CourseName NVARCHAR(255), 
    @Description NVARCHAR(MAX), 
    @MaxDegree FLOAT, 
    @MinDegree FLOAT
AS
BEGIN
    INSERT INTO instructor.Courses (CourseName, Description, MaxDegree, MinDegree)
    VALUES (@CourseName, @Description, @MaxDegree, @MinDegree)
END



GRANT EXECUTE ON OBJECT:: instructor.AddCourse  TO InstructorRole ;



--########################################################################################################################################################
CREATE OR ALTER PROCEDURE instructor.spCreateExam
    @CourseID INT,
    @InstructorID INT,
    @ExamType VARCHAR(50),
    @IntakeID INT,
    @BranchID INT,
    @TrackID INT,
    @StartTime DATETIME,
    @EndTime DATETIME,
    @TotalTime INT,
    @AllowanceOptions NVARCHAR(255)
AS
BEGIN
    
    IF EXISTS (
        SELECT 1
        FROM instructor.Instructors
        WHERE InstructorID = @InstructorID AND CourseID = @CourseID
    )
    BEGIN
        INSERT INTO instructor.Exams (CourseID, InstructorID, ExamType, IntakeID, BranchID, TrackID, StartTime, EndTime, TotalTime, AllowanceOptions)
        VALUES (@CourseID, @InstructorID, @ExamType, @IntakeID, @BranchID, @TrackID, @StartTime, @EndTime, @TotalTime, @AllowanceOptions)
        
        PRINT 'Exam added successfully.';
    END
    ELSE
    BEGIN
        PRINT 'The instructor is not assigned to this course.'
    END
END;




GRANT EXECUTE ON OBJECT:: instructor.spCreateExam  TO InstructorRole ;




--#####################################################################################################################################################################
CREATE or alter PROCEDURE instructor.spAddQuestion
    @CourseID INT,
    @QuestionText NVARCHAR(100),
    @QuestionType VARCHAR(50),
    @MultiAnswer INT = NULL,
    @TrueFalseAnswer TINYINT = NULL,
    @TextAnswer NVARCHAR(255) = NULL,
	@BestAcceptedAnswer NVARCHAR(MAX) = NULL
AS
BEGIN
    INSERT INTO instructor.Questions (CourseID, QuestionText, QuestionType, MultiAnswer,TrueFlaseAnswer, TextAnswer, BestAcceptedAnswer)
    VALUES (@CourseID, @QuestionText, @QuestionType, @MultiAnswer, @TrueFalseAnswer, @TextAnswer , @BestAcceptedAnswer)
END;


GRANT EXECUTE ON OBJECT:: instructor.spAddQuestion TO InstructorRole ;





--###################################################################################################################################################################################
CREATE OR ALTER PROCEDURE instructor.spAddQuestionToExam
    @ExamID INT,
    @QuestionID INT,
    @Degree DECIMAL(5, 2)
AS
BEGIN
    INSERT INTO instructor.ExamQuestions (ExamID, QuestionID, Degree)
    VALUES (@ExamID, @QuestionID, @Degree);
END;

GRANT EXECUTE ON OBJECT:: instructor.spAddQuestionToExam TO InstructorRole ;





--###################################################################################################################################################################################
CREATE OR ALTER PROCEDURE instructor.spAddRandomQuestionToExam
    @ExamID INT,
    @CourseID INT,
    @Degree DECIMAL(5, 2)
AS
BEGIN
    
        DECLARE @QuestionID INT

        SELECT TOP 1 @QuestionID = QuestionID
        FROM instructor.Questions
        WHERE CourseID = @CourseID
        ORDER BY NEWID(); --Select random 

        IF @QuestionID IS NOT NULL
        BEGIN
            INSERT INTO instructor.ExamQuestions (ExamID, QuestionID, Degree)
            VALUES (@ExamID, @QuestionID, @Degree)
        END
        ELSE
        BEGIN
            Print'No questions available for the specified CourseID.'
        END
    
END;


GRANT EXECUTE ON OBJECT:: instructor.spAddRandomQuestionToExam  TO InstructorRole ;





--###################################################################################################################################################################################
CREATE OR ALTER PROC Student.SP_checkStudentAnswer
    @StudentID int,
	@studentExamID int,
	@QuestionID int,
	@studentanswer nvarchar(255)
	AS
		begin
		 DECLARE @IsValid BIT
		 DECLARE @IsCorrect TINYINT = 0
		 DECLARE @CorrectAnswer NVARCHAR(255)
		 DECLARE @ExamType VARCHAR(50)
		 DECLARE @Degree FLOAT;
		 DECLARE @ManualGrading BIT = 0

		 SELECT 
        @CorrectAnswer = 
            CASE QuestionType
                WHEN 'Multi' THEN CAST(MultiAnswer AS NVARCHAR)  --TEXT FUNCTION (CAST)
                WHEN 'T&F' THEN CAST(TrueFlaseAnswer AS NVARCHAR)
                WHEN 'Text' THEN TextAnswer
            END,
        @Degree = EQ.Degree, -- Degree from ExamQuestions
        @ExamType = E.ExamType
    FROM 
        instructor.Questions Q
        INNER JOIN instructor.ExamQuestions EQ ON Q.QuestionID = EQ.QuestionID
        INNER JOIN instructor.Exams E ON EQ.ExamID = E.ExamID
        INNER JOIN Student.StudentExams SE ON E.ExamID = SE.ExamID
    WHERE 
        Q.QuestionID = @QuestionID
        AND SE.StudentExamID = @StudentExamID


    -- Validate student answer using the function
    SET @IsValid = instructor.ValidateStudentAnswer(@StudentAnswer, @CorrectAnswer)

    IF @IsValid = 1
    BEGIN
        IF NOT  @Degree = 0
        BEGIN
            SET @IsCorrect = 1
        END
    END
    ELSE
    BEGIN
        SET @ManualGrading = 1
		SET @Degree = 0
    END

	IF @ManualGrading = 1
    BEGIN
        INSERT INTO Student.StudentAnswers (StudentExamID, QuestionID, StudentAnswer, IsCorrect, IsValidAnswer, Degree)
        VALUES (@StudentExamID, @QuestionID, @StudentAnswer, @IsCorrect, @IsValid, @Degree)
    END
    ELSE
    BEGIN
        INSERT INTO Student.StudentAnswers (StudentExamID, QuestionID, StudentAnswer, IsCorrect, IsValidAnswer, Degree)
        VALUES (@StudentExamID, @QuestionID, @StudentAnswer, @IsCorrect, @IsValid, @Degree)
    END

    SELECT 
        @StudentAnswer AS StudentAnswer,
        CASE
            WHEN @IsValid = 1 THEN 'Valid'
            ELSE 'Invalid'
        END AS AnswerStatus,
        @IsCorrect AS IsCorrect,
        @Degree AS Degree,
        @QuestionID AS QuestionID
END

	GRANT EXECUTE ON OBJECT::Student.SP_checkStudentAnswer TO StudentRole
	GRANT EXECUTE ON OBJECT::Student.SP_checkStudentAnswer TO InstructorRole





--###################################################################################################################################################################################
CREATE OR ALTER PROCEDURE instructor.SP_UpdateStudentAnswerDegree
    @StudentAnswerID INT,
    @Degree FLOAT
AS
BEGIN
    UPDATE Student.StudentAnswers
    SET Degree = @Degree
    WHERE StudentAnswerID = @StudentAnswerID

  

    SELECT 'Degree updated successfully' AS Message
END


GRANT EXECUTE ON OBJECT::instructor.SP_UpdateStudentAnswerDegree TO InstructorRole





--###################################################################################################################################################################################
--Calculate Obtained degree & Total  degree & Percentage
--If percentage <60% create a corrective exam automatically after 7 days at 9:00am 
CREATE OR ALTER PROCEDURE instructor.SP_calculateTotalDegree
    @studentId INT,
    @examId INT
AS
BEGIN
    DECLARE @totalDegree DECIMAL(5, 2)
    DECLARE @obtainedDegree DECIMAL(5, 2)
    DECLARE @Percentage DECIMAL(5, 2)
    DECLARE @CorrectiveExamID INT
	DECLARE @StartTime DATETIME
    DECLARE @EndTime DATETIME


    SELECT @totalDegree = SUM(Q.Degree)
    FROM instructor.ExamQuestions Q
    JOIN instructor.Exams E ON Q.ExamID = E.ExamID
    WHERE Q.ExamID = @examId AND NOT (E.ExamType = 'Corrective' AND Q.Degree = 0)

   
    SELECT @obtainedDegree = SUM(Degree)
    FROM Student.StudentAnswers SA
    WHERE SA.StudentExamID IN (
        SELECT StudentExamID
        FROM Student.StudentExams
        WHERE StudentID = @studentId AND ExamID = @examId) AND (SA.IsCorrect = 1 OR (SA.IsCorrect = 0 AND SA.Degree IS NOT NULL))

   
    SET @Percentage = (@obtainedDegree / @totalDegree) * 100

    SELECT @obtainedDegree AS StudentDegree, @totalDegree AS TotalDegree, @Percentage AS Percentage

IF @Percentage < 60
    BEGIN

	    SET @StartTime = DATEADD(DAY, 7, CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101) + ' 09:00:00', 101))
        SET @EndTime = DATEADD(HOUR, 2, @StartTime)

        -- Find or create a corrective exam
        SELECT @CorrectiveExamID = ExamID
        FROM instructor.Exams
        WHERE CourseID = (SELECT CourseID FROM Exams WHERE ExamID = @examId)
          AND ExamType = 'Corrective'
          AND IntakeID = (SELECT IntakeID FROM Exams WHERE ExamID = @examId)
          AND BranchID = (SELECT BranchID FROM Exams WHERE ExamID = @examId)
          AND TrackID = (SELECT TrackID FROM Exams WHERE ExamID = @examId)



    IF @CorrectiveExamID IS NULL
        BEGIN

            INSERT INTO instructor.Exams (CourseID, InstructorID, ExamType, IntakeID, BranchID, TrackID, StartTime, EndTime, TotalTime, AllowanceOptions)
            SELECT CourseID, InstructorID, 'Corrective', IntakeID, BranchID, TrackID, @StartTime, @EndTime, 120, ''
            FROM instructor.Exams
            WHERE ExamID = @examId;

            SET @CorrectiveExamID = SCOPE_IDENTITY() -- Get the newly created ExamID --@Identity: is used to get the identity value of the last row inserted in the current session and scope.
       END

        INSERT INTO Student.StudentExams (StudentID, ExamID, StartTime, EndTime)
        VALUES (@studentId, @CorrectiveExamID, @StartTime, @EndTime)
        
        RAISERROR ('Student ID %d scored less than 60%% in Exam ID %d and has been assigned a corrective exam.', 10, 1, @studentId, @examId)
    END
END


GRANT EXECUTE ON OBJECT::instructor.SP_calculateTotalDegree TO InstructorRole



--###################################################################################################################################################################################
--Instructor assign an Exam to student
CREATE OR ALTER  PROCEDURE instructor.SP_StudentExam
    @StudentID INT,
    @ExamID INT,
    @StartTime DATETIME,
    @EndTime DATETIME
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Student.Students WHERE StudentID = @StudentID)
    BEGIN
        RAISERROR('Error: StudentID does not exist.', 16, 1);
        RETURN;
    END
    IF NOT EXISTS (SELECT 1 FROM instructor.Exams WHERE ExamID = @ExamID)
    BEGIN
        RAISERROR('Error: ExamID does not exist.', 16, 1);
        RETURN;
    END
    BEGIN TRY
        INSERT INTO Student.StudentExams (StudentID, ExamID, StartTime, EndTime)
        VALUES (@StudentID, @ExamID, @StartTime, @EndTime);

        PRINT 'Insert successful.'
    END TRY

    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
        SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
GO

GRANT EXECUTE ON OBJECT:: instructor.SP_StudentExam TO InstructorRole ;
