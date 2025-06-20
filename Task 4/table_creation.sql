-- Drop existing tables
DROP TABLE IF EXISTS dbo.Enrollment;
DROP TABLE IF EXISTS dbo.Section;
DROP TABLE IF EXISTS dbo.Prerequisite;
DROP TABLE IF EXISTS dbo.Course;
DROP TABLE IF EXISTS dbo.Student;
DROP TABLE IF EXISTS dbo.Instructor;
DROP TABLE IF EXISTS dbo.Department;

-- Create tables
CREATE TABLE Department (
    DepartmentID INT PRIMARY KEY,
    DepartmentName NVARCHAR(50) NOT NULL UNIQUE,
    OfficeLocation NVARCHAR(50)
);

CREATE TABLE Instructor (
    InstructorID INT PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    Salary DECIMAL(10,2),
    DepartmentID INT NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
);

CREATE TABLE Student (
    StudentID INT PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    MajorDeptID INT,
    EnrollmentYear SMALLINT NOT NULL,
    FOREIGN KEY (MajorDeptID) REFERENCES Department(DepartmentID)
);

CREATE TABLE Course (
    CourseID INT PRIMARY KEY,
    CourseName NVARCHAR(50) NOT NULL,
    Credits DECIMAL(3,1) NOT NULL,
    Description NVARCHAR(200),
    DepartmentID INT NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
);

CREATE TABLE Prerequisite (
    CourseID INT NOT NULL,
    PrereqCourseID INT NOT NULL,
    PRIMARY KEY(CourseID, PrereqCourseID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID),
    FOREIGN KEY (PrereqCourseID) REFERENCES Course(CourseID)
);

CREATE TABLE Section (
    SectionID INT PRIMARY KEY,
    CourseID INT NOT NULL,
    Semester NVARCHAR(10) NOT NULL,
    Year SMALLINT NOT NULL,
    InstructorID INT NOT NULL,
    Capacity INT NOT NULL,
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID),
    FOREIGN KEY (InstructorID) REFERENCES Instructor(InstructorID)
);

CREATE TABLE Enrollment (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT NOT NULL,
    SectionID INT NOT NULL,
    EnrollmentDate DATE NOT NULL,
    Grade NVARCHAR(2),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (SectionID) REFERENCES Section(SectionID)
);
