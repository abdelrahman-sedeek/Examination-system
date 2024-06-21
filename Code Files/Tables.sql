-- Courses Table
CREATE TABLE Courses (
    CourseID INT PRIMARY KEY IDENTITY(1,1),
    CourseName NVARCHAR(255) NOT NULL,
    Description NVARCHAR(MAX),
    MaxDegree FLOAT,
    MinDegree FLOAT,
	
)

-- Instructors Table
CREATE TABLE Instructors (
    InstructorID INT PRIMARY KEY IDENTITY(1,1),
    FirstName  nvarchar(100) NOT NULL,
    LastName  nvarchar(100) NOT NULL,
    Email nvarchar(255) NOT NULL UNIQUE,
	CourseID INT,
	FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
)

-- TrainingManeger Table
CREATE TABLE TrainingManeger (
    TrainingManegerID INT PRIMARY KEY IDENTITY(1,1),
    FirstName  nvarchar(100) NOT NULL,
    LastName  nvarchar(100) NOT NULL,
    Email  nvarchar(255) NOT NULL UNIQUE
)


-- Departments Table
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY IDENTITY(1,1),
    DepartmentName  nvarchar(255) NOT NULL
)

-- Branches Table
CREATE TABLE Branches (
    BranchID INT PRIMARY KEY IDENTITY(1,1),
    BranchName  nvarchar(100) NOT NULL,
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
)

-- Tracks Table
CREATE TABLE Tracks (
    TrackID INT PRIMARY KEY IDENTITY(1,1),
    TrackName  nvarchar(100) NOT NULL,
    BranchID INT,
    FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
)

-- Intakes Table
CREATE TABLE Intakes (
    IntakeID INT PRIMARY KEY IDENTITY(1,1),
    IntakeName  nvarchar(100) NOT NULL,
    BranchID INT,
    FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
)

-- Students Table
CREATE TABLE Students (
    StudentID INT PRIMARY KEY IDENTITY(1,1),
    FirstName  nvarchar(100) NOT NULL,
    LastName nvarchar(100) NOT NULL,
    Email nvarchar(100) NOT NULL UNIQUE,
    IntakeID INT,
    BranchID INT,
    TrackID INT,
	CourseID INT,
    FOREIGN KEY (IntakeID) REFERENCES Intakes(IntakeID),
    FOREIGN KEY (BranchID) REFERENCES Branches(BranchID),
    FOREIGN KEY (TrackID) REFERENCES Tracks(TrackID),
	FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
)





-- Users Table
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    Username NVARCHAR(50) NOT NULL UNIQUE,
    Password NVARCHAR(255) NOT NULL,
    StudentID INT,
    InstructorID INT,
    TrainingManegerID INT,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (InstructorID) REFERENCES Instructors(InstructorID),
    FOREIGN KEY (TrainingManegerID) REFERENCES TrainingManeger(TrainingManegerID)
)



-- Questions Table
CREATE TABLE Questions (
    QuestionID INT PRIMARY KEY IDENTITY(1,1),
    QuestionText nvarchar(Max) NOT NULL,
    QuestionType varchar(50) NOT NULL, CHECK (QuestionType IN ('Multi', 'T&F', 'Text')),
    MultiAnswer INT, 
	TrueFlaseAnswer tinyint,
    TextAnswer nvarchar(max)  ,
	BestAcceptedAnswer NVARCHAR(MAX),
	CourseID INT,
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
)


-- Exams Table
CREATE TABLE Exams (
    ExamID INT PRIMARY KEY IDENTITY(1,1),
    CourseID INT,
    InstructorID INT,
    ExamType varchar(50) NOT NULL,CHECK (ExamType IN ('Exam', 'Corrective')),
    IntakeID INT,
    BranchID INT,
    TrackID INT,
    StartTime DATETIME NOT NULL,
    EndTime DATETIME NOT NULL,
    TotalTime INT,
    AllowanceOptions TEXT,
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    FOREIGN KEY (InstructorID) REFERENCES Instructors(InstructorID),
    FOREIGN KEY (IntakeID) REFERENCES Intakes(IntakeID),
    FOREIGN KEY (BranchID) REFERENCES Branches(BranchID),
    FOREIGN KEY (TrackID) REFERENCES Tracks(TrackID)
)



-- ExamQuestions Table
CREATE TABLE ExamQuestions (
    ExamQuestionID INT PRIMARY KEY IDENTITY(1,1),
    ExamID INT,
    QuestionID INT,
    Degree FLOAT,
    FOREIGN KEY (ExamID) REFERENCES Exams(ExamID),
    FOREIGN KEY (QuestionID) REFERENCES Questions(QuestionID)

)

-- StudentExams Table
CREATE TABLE StudentExams (
    StudentExamID INT  PRIMARY KEY IDENTITY(1,1),
    StudentID INT,
    ExamID INT,
    StartTime DATETIME NOT NULL,
    EndTime DATETIME NOT NULL,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (ExamID) REFERENCES Exams(ExamID)
)

-- StudentAnswers Table
CREATE TABLE StudentAnswers (
    StudentAnswerID INT PRIMARY KEY IDENTITY(1,1),
    StudentExamID INT,
    QuestionID INT,
    StudentAnswer TEXT NOT NULL,
    IsCorrect tinyint default(0),
	IsValidAnswer BIT,
    Degree FLOAT,
	FOREIGN KEY (StudentExamID) REFERENCES StudentExams(StudentExamID),
    FOREIGN KEY (QuestionID) REFERENCES Questions(QuestionID)

)
