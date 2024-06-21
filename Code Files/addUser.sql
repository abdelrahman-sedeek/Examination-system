CREATE OR ALTER PROCEDURE admin.SP_AddUser
    @Username NVARCHAR(50),
    @Password NVARCHAR(255),
    @StudentID INT = NULL,
    @InstructorID INT = NULL,
    @TrainingManagerID INT = NULL
AS
BEGIN
    INSERT INTO Users (Username, Password, StudentID, InstructorID, TrainingManegerID)
    VALUES (@Username, @Password, @StudentID, @InstructorID, @TrainingManagerID)
   
    DECLARE @SQL NVARCHAR(MAX) = 'CREATE LOGIN [' + @Username + '] WITH PASSWORD = ''' + @Password + ''';'
    EXEC sp_executesql @SQL

    SET @SQL = 'CREATE USER [' + @Username + '] FOR LOGIN [' + @Username + '];'
    EXEC sp_executesql @SQL


    IF @StudentID IS NOT NULL
    BEGIN
        SET @SQL = 'ALTER ROLE StudentRole ADD MEMBER [' + @Username + '];'
        EXEC sp_executesql @SQL
    END

    ELSE IF @InstructorID IS NOT NULL
    BEGIN
        SET @SQL = 'ALTER ROLE InstructorRole ADD MEMBER [' + @Username + '];'
        EXEC sp_executesql @SQL
    END

    ELSE IF @TrainingManagerID IS NOT NULL
    BEGIN
        SET @SQL = 'ALTER ROLE TrainingManagerRole ADD MEMBER [' + @Username + '];'
        EXEC sp_executesql @SQL
    END

    ELSE
    BEGIN
        SET @SQL = 'ALTER ROLE AdminRole ADD MEMBER [' + @Username + '];'
        EXEC sp_executesql @SQL
    END
END


EXEC admin.SP_AddUser 
    @Username = 'Dohaaaaa', 
    @Password = '123', 
    @StudentID = 2, 
    @InstructorID = NULL, 
    @TrainingManagerID = NULL


	EXEC admin.SP_AddUser 
    @Username = 'instructor1', 
    @Password = '123!', 
    @StudentID = NULL, 
    @InstructorID = 1, 
    @TrainingManagerID = NULL

