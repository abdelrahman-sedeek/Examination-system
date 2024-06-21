--Procedures

--Insert department
EXEC TrainingManager.sp_department @departmentName ='SQL'

--Insert Course
Exec instructor.AddCourse  @CourseName='SQL', @Description='Basic DB Course', @MaxDegree=100, @MinDegree=50



--Create Exam
EXEC instructor.spCreateExam @CourseID=2, @InstructorID=2, @ExamType='Exam', @IntakeID=1, @BranchID=1, @TrackID=4, @StartTime='2024-12-01 10:00:00.000', @EndTime='2024-12-01 12:00:00.000', @TotalTime=120, @AllowanceOptions=NULL

--check that instructor add exams for his courses only 
EXEC instructor.spCreateExam @CourseID=3, @InstructorID=7, @ExamType='Exam', @IntakeID=3 ,@BranchID=3 ,@TrackID=2 , @StartTime='2024-06-14 7:00:00.000', @EndTime='2024-06-14 9:00:00.000',  @TotalTime=120, @AllowanceOptions=null 



--INSERT QUESTION
EXEC instructor.spAddQuestion @CourseID=1, @QuestionText='What is the derivative of sin(x)?', @QuestionType='Text', @MultiAnswer=NULL , @TrueFalseAnswer=NULL, @TextAnswer = '-cos(x)', @BestAcceptedAnswer='-cos(x)'
EXEC instructor.spAddQuestion @CourseID=2, @QuestionText='A ball is thrown vertically upward with an initial velocity of 20 m/s. Ignoring air resistance, what will be the maximum height reached by the ball?  1. 10 m , 2. 20 m , 3. 30 m, 4. 40 m' , @QuestionType='Multi', @MultiAnswer=2 , @TrueFalseAnswer=NULL, @TextAnswer = Null, @BestAcceptedAnswer=2

--Insert Question To Exam
Exec instructor.spAddQuestionToExam @ExamID= 6, @QuestionID=5 , @Degree=5

--Ensure Exam Degree Does Not Exceed Course Max Degree
Exec instructor.spAddQuestionToExam @ExamID= 6, @QuestionID=5 , @Degree=150




--Add random questions to exam 
EXEC instructor.spAddRandomQuestionToExam  @ExamID = 2 ,  @CourseID =2 , @Degree = 4.00
EXEC instructor.spAddRandomQuestionToExam  @ExamID = 2 ,  @CourseID =2 , @Degree = 5.00

--checkStudentAnswer
EXEC student.SP_checkStudentAnswer @StudentID =2 ,	@studentExamID =2 , 	@QuestionID = 2  ,@studentanswer = 0
EXEC student.SP_checkStudentAnswer @StudentID =2 ,	@studentExamID =2 , 	@QuestionID = 10  ,@studentanswer = 2

--The student get <60% and then corrective exam will created for him automatically 
-- Using Proc instructor.SP_calculateTotalDegree
Exec instructor.SP_calculateTotalDegree @studentId =2,@examId =2

--Update degree manually by Instructor if the StudentAnswer not valid compared to BestAcceptedAnswer
Exec  instructor.SP_UpdateStudentAnswerDegree @StudentAnswerID= 1, @Degree= 5 



--Insert StudentExam 
Exec instructor.SP_StudentExam  @StudentID= 3 ,@ExamID= 11  ,@StartTime = '2024-12-01 10:00:00.000',@EndTime ='2024-12-01 12:00:00.000'

--StudentID not exist 
Exec instructor.SP_StudentExam  @StudentID= 6 ,@ExamID= 11  ,@StartTime = '2024-12-01 10:00:00.000',@EndTime ='2024-12-01 12:00:00.000'

--Exam not exist
Exec instructor.SP_StudentExam  @StudentID= 3 ,@ExamID= 12  ,@StartTime = '2024-12-01 10:00:00.000',@EndTime ='2024-12-01 12:00:00.000'

--Student enter the exam befor the start time
Exec instructor.SP_StudentExam  @StudentID= 3 ,@ExamID= 11  ,@StartTime = '2024-11-01 10:00:00.000',@EndTime ='2024-11-01 12:00:00.000'

--Student enter after the exam has already ended
Exec instructor.SP_StudentExam  @StudentID= 3 ,@ExamID= 11  ,@StartTime = '2024-12-02 10:00:00.000',@EndTime ='2024-12-02 12:00:00.000'

--Student Cannot take the exam twice
Exec instructor.SP_StudentExam  @StudentID= 1 ,@ExamID= 1  ,@StartTime = '2024-06-15 09:00:00.000',@EndTime ='2024-06-15 11:00:00.000'

--function to get exam details along with questions
SELECT * FROM Student.GetExamDetails (1)

-- function to get all details of a student, including exams and total degree for each exam
SELECT * FROM instructor.GetStudentDetails(3)

