CREATE VIEW StudentEnrollmentDetails AS
SELECT
    s.StudentID,
    s.FirstName AS StudentFirstName,
    s.LastName AS StudentLastName,
    s.Email AS StudentEmail,
    d_major.DepartmentName AS MajorDepartment,
    s.EnrollmentYear,
    c.CourseName,
    c.Credits,
    sec.Semester,
    sec.Year AS SectionYear,
    inst.FirstName AS InstructorFirstName,
    inst.LastName AS InstructorLastName,
    e.EnrollmentDate,
    e.Grade
FROM
    Student s
JOIN
    Enrollment e ON s.StudentID = e.StudentID
JOIN
    Section sec ON e.SectionID = sec.SectionID
JOIN
    Course c ON sec.CourseID = c.CourseID
JOIN
    Instructor inst ON sec.InstructorID = inst.InstructorID
LEFT JOIN
    Department d_major ON s.MajorDeptID = d_major.DepartmentID;
GO

CREATE PROCEDURE EnrollStudentInSection
    @StudentID INT,
    @SectionID INT,
    @EnrollmentDate DATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CurrentCapacity INT;
    DECLARE @MaxCapacity INT;
    DECLARE @EnrollmentID INT;

    SELECT @CurrentCapacity = (Capacity - (SELECT COUNT(*) FROM Enrollment WHERE SectionID = @SectionID)),
           @MaxCapacity = Capacity
    FROM Section
    WHERE SectionID = @SectionID;

    IF @MaxCapacity IS NULL
    BEGIN
        PRINT 'Error: Section does not exist.';
        RETURN -1;
    END

    IF @CurrentCapacity <= 0
    BEGIN
        PRINT 'Error: Section is full. Cannot enroll student.';
        RETURN -2;
    END

    IF EXISTS (SELECT 1 FROM Enrollment WHERE StudentID = @StudentID AND SectionID = @SectionID)
    BEGIN
        PRINT 'Error: Student is already enrolled in this section.';
        RETURN -3;
    END

    SELECT @EnrollmentID = ISNULL(MAX(EnrollmentID), 0) + 1 FROM Enrollment;

    INSERT INTO Enrollment (EnrollmentID, StudentID, SectionID, EnrollmentDate, Grade)
    VALUES (@EnrollmentID, @StudentID, @SectionID, @EnrollmentDate, NULL);

    PRINT 'Student enrolled successfully.';
    RETURN 0;
END;
GO

CREATE FUNCTION GetInstructorSectionCount
(
    @InstructorID INT
)
RETURNS INT
AS
BEGIN
    DECLARE @SectionCount INT;

    SELECT @SectionCount = COUNT(SectionID)
    FROM Section
    WHERE InstructorID = @InstructorID;

    RETURN ISNULL(@SectionCount, 0);
END;
GO

ALTER TABLE Section
ADD CurrentEnrollmentCount INT DEFAULT 0;
GO

UPDATE Section
SET CurrentEnrollmentCount = (SELECT COUNT(e.EnrollmentID) FROM Enrollment e WHERE e.SectionID = Section.SectionID);
GO

CREATE TRIGGER trg_UpdateSectionEnrollmentCount_AfterEnrollment
ON Enrollment
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE s
    SET s.CurrentEnrollmentCount = s.CurrentEnrollmentCount + 1
    FROM Section s
    INNER JOIN INSERTED i ON s.SectionID = i.SectionID;
END;
GO

SELECT * FROM StudentEnrollmentDetails