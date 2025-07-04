
-- View: StudentEnrollmentDetails
CREATE OR REPLACE VIEW StudentEnrollmentDetails AS
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

-- Procedure: EnrollStudentInSection
DELIMITER $$
CREATE PROCEDURE EnrollStudentInSection(
    IN StudentID INT,
    IN SectionID INT,
    IN EnrollmentDate DATE
)
BEGIN
    DECLARE CurrentCapacity INT;
    DECLARE MaxCapacity INT;
    DECLARE EnrollmentID INT;

    SELECT (Capacity - COUNT(e.EnrollmentID)), Capacity
    INTO CurrentCapacity, MaxCapacity
    FROM Section s
    LEFT JOIN Enrollment e ON s.SectionID = e.SectionID
    WHERE s.SectionID = SectionID
    GROUP BY s.Capacity;

    IF MaxCapacity IS NULL THEN
        SELECT 'Error: Section does not exist.' AS Message;
    ELSEIF CurrentCapacity <= 0 THEN
        SELECT 'Error: Section is full. Cannot enroll student.' AS Message;
    ELSEIF EXISTS (
        SELECT 1 FROM Enrollment WHERE StudentID = StudentID AND SectionID = SectionID
    ) THEN
        SELECT 'Error: Student is already enrolled in this section.' AS Message;
    ELSE
        SELECT IFNULL(MAX(EnrollmentID), 0) + 1 INTO EnrollmentID FROM Enrollment;

        INSERT INTO Enrollment (EnrollmentID, StudentID, SectionID, EnrollmentDate, Grade)
        VALUES (EnrollmentID, StudentID, SectionID, EnrollmentDate, NULL);

        SELECT 'Student enrolled successfully.' AS Message;
    END IF;
END$$
DELIMITER ;

-- Function: GetInstructorSectionCount
DELIMITER $$
CREATE FUNCTION GetInstructorSectionCount(InstructorID INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE SectionCount INT;
    SELECT COUNT(*) INTO SectionCount
    FROM Section
    WHERE InstructorID = InstructorID;
    RETURN IFNULL(SectionCount, 0);
END$$
DELIMITER ;

-- Alter table to add CurrentEnrollmentCount
ALTER TABLE Section
ADD COLUMN CurrentEnrollmentCount INT DEFAULT 0;

-- Update CurrentEnrollmentCount for all sections
UPDATE Section
SET CurrentEnrollmentCount = (
    SELECT COUNT(*) FROM Enrollment e WHERE e.SectionID = Section.SectionID
);

-- Trigger: trg_UpdateSectionEnrollmentCount_AfterEnrollment
DELIMITER $$
CREATE TRIGGER trg_UpdateSectionEnrollmentCount_AfterEnrollment
AFTER INSERT ON Enrollment
FOR EACH ROW
BEGIN
    UPDATE Section
    SET CurrentEnrollmentCount = CurrentEnrollmentCount + 1
    WHERE SectionID = NEW.SectionID;
END$$
DELIMITER ;

-- Query to test view
SELECT * FROM StudentEnrollmentDetails;
