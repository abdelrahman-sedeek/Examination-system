CREATE VIEW instructor.vwStudentResults
AS
SELECT 
    se.StudentID,
    s.FirstName + ' ' + s.LastName AS StudentName,
    se.ExamID,
    e.CourseID,
    c.CourseName,
    SUM(sa.IsCorrect * eq.Degree) AS ObtainedDegree,
    SUM(eq.Degree) AS TotalDegree
FROM Student.StudentExams se
JOIN Student.Students s ON se.StudentID = s.StudentID
JOIN instructor.Exams e ON se.ExamID = e.ExamID
JOIN instructor.Courses c ON e.CourseID = c.CourseID
JOIN Student.StudentAnswers sa ON se.StudentExamID = sa.StudentExamID
JOIN instructor.ExamQuestions eq ON sa.QuestionID = eq.QuestionID
GROUP BY se.StudentID, s.FirstName, s.LastName, se.ExamID, e.CourseID, c.CourseName;

CREATE VIEW instructor.vwExams
AS
SELECT 
    e.ExamID,
    c.CourseName,
    i.FirstName + ' ' + i.LastName AS InstructorName,
    e.ExamType,
    e.StartTime,
    e.EndTime,
    e.TotalTime,
    e.AllowanceOptions
FROM instructor.Exams e
JOIN instructor.Courses c ON e.CourseID = c.CourseID
JOIN instructor.Instructors i ON e.InstructorID = i.InstructorID;



