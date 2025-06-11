
# 🎓 CampusFlow
### End-to-End Database Design for University Registration

Welcome to the **CampusFlow** database project!  
This project was created as a final assignment for my **Relational Database Design** course and showcases a complete relational database system from scratch.  
Whether you're a student, instructor, or admin, this system is built to _simulate_ the process of managing courses, students, enrollments, grading, and more!

---

## 📌 Project Overview

> **Goal**: Design a normalized, efficient, and scalable relational database that models a real-world university registration system.

This database supports:
- 📘 Course creation & assignment
- 👩‍🎓 Student enrollment
- 👨‍🏫 Instructor management
- 📝 Grade recording
- 📊 Viewing transcripts and GPAs

---

## ✅ Project Deliverables

- `schema.sql` — All `CREATE TABLE` + `INSERT` statements
- `ER_Diagram.pdf` — Visual diagram of entities and relationships
- `report.pdf` — 1–2 page explanation of design decisions
- `README.md` — You’re reading it!

---

## 🧩 Project Breakdown

### 1. 📝 Requirement Analysis

- **Purpose**: The system allows students to register for courses, instructors to manage their classes, and admins to oversee scheduling and enrollment.
- **Users**:
  - _Students_: Browse and enroll in courses, view transcripts
  - _Instructors_: Assign grades and manage courses
  - _Admins_: Add courses, assign instructors, maintain academic records
- **Operations**:
  - Enroll in courses
  - Record and update grades
  - Calculate GPAs
  - Validate prerequisites
  - Retrieve course schedules and history

---

### 2. 📐 ER Diagram

> Created using [draw.io] and exported as PDF
> ![CampusFlow ERD](https://github.com/user-attachments/assets/d1dcf603-2442-41bd-9b67-c02db861dc25)



Entities:
- `Student`
- `Instructor`
- `Course`
- `Department`
- `Enrollment`
- `Grade`

_**Relationships**_:
- Many-to-many between `Student` and `Course` through `Enrollment`
- One-to-many: `Department` to `Course`, `Instructor` to `Course`
- One-to-one (optional): `Enrollment` to `Grade`

📸 _See `ER_Diagram.pdf` for details!_

---

### 3. 🗃️ Relational Schema

All entities are translated into relational tables with:
- Primary Keys (`PK`)
- Foreign Keys (`FK`)
- `NOT NULL`, `UNIQUE`, and other constraints
- 3rd Normal Form (3NF) compliance

---

### 4. 🧑‍💻 SQL Implementation

Provided in `schema.sql`:
- `CREATE TABLE` statements for all entities
- `INSERT INTO` statements with **sample data**
- Key constraints & relationships

---

### 5. 💡 Optional Advanced Features

We’ve added:
- 🧮 **Stored Function**: Calculate a student’s GPA
- 👀 **View**: Transcript view for each student
- 🚨 **Trigger**: Prevent enrollment if prerequisites are not met
- 🧼 Fully normalized design up to **3NF**

---

### 6. 📰 Final Report

The `report.pdf` includes:
- Purpose of the system
- Summary of entities and relationships
- Design choices and assumptions
- Normalization justifications
- Description of optional features

---

## 📂 Folder Structure

```
.
├── schema.sql              # SQL code (CREATE TABLE + INSERT)
├── ER_Diagram.pdf          # Entity-Relationship Diagram
├── report.pdf              # Project report (1–2 pages)
└── README.md               # You're here!
```

---

## 🛠️ Tools Used

- ✏️ ERD Tool:
- 🗄️ SQL Editor: MySQL Workbench / pgAdmin
- 📄 Docs: Markdown / LaTeX
- 🧠 Brain: Yours truly!

---

## 👋 About the Authors

This project was developed by/for:

> **Koorosh Asil Gharehbaghi**  
> **Project:** Database Systems Design  
> **Course:** Database Systems  
> **University:** K. N. Toosi University of Technology  
> **Semester:** Spring 2025
> _Passionate about databases, coffee, and clean schema design!_  
---

## 🍻 Final Words

Designing a database is like writing a story — every entity has a role, every relationship matters, and normalization keeps the plot clean and organized. 🎭

_Thanks for checking out my project!_  
Feel free to fork, run, or expand on it in your own universe. 🚀

---

> "Why did the database administrator leave his wife? Because she had too many relations!" – Anonymous DBA 😆
