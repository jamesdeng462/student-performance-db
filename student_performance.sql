-- Create database
CREATE DATABASE alu_student_performance;
USE alu_student_performance;

-- =====================
-- 1. Create Tables
-- =====================
CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    student_name VARCHAR(100) NOT NULL,
    intake_year INT NOT NULL
);

CREATE TABLE linux_grades (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100) NOT NULL,
    student_id INT,
    grade_obtained DECIMAL(5,2),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

CREATE TABLE python_grades (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100) NOT NULL,
    student_id INT,
    grade_obtained DECIMAL(5,2),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

-- =====================
-- 2. Insert Sample Data
-- =====================
INSERT INTO students (student_name, intake_year) VALUES
('Alice Johnson', 2023),
('Bob Smith', 2023),
('Charlie Brown', 2024),
('David Lee', 2024),
('Eva Adams', 2023),
('Frank White', 2024),
('Grace Kim', 2023),
('Henry Jones', 2024),
('Isla Thomas', 2023),
('Jack Miller', 2024),
('Kara Williams', 2023),
('Leo Martinez', 2024),
('Mia Davis', 2023),
('Noah Wilson', 2024),
('Olivia Harris', 2023);

INSERT INTO linux_grades (course_name, student_id, grade_obtained) VALUES
('Linux Fundamentals', 1, 45.00),
('Linux Fundamentals', 2, 78.50),
('Linux Fundamentals', 3, 64.00),
('Linux Fundamentals', 4, 30.00),
('Linux Fundamentals', 5, 89.00),
('Linux Fundamentals', 6, 54.00),
('Linux Fundamentals', 7, 92.00),
('Linux Fundamentals', 8, 48.00),
('Linux Fundamentals', 9, 60.00),
('Linux Fundamentals', 10, 70.00);

INSERT INTO python_grades (course_name, student_id, grade_obtained) VALUES
('Python Programming', 1, 67.00),
('Python Programming', 3, 75.00),
('Python Programming', 5, 88.00),
('Python Programming', 7, 94.00),
('Python Programming', 9, 59.00),
('Python Programming', 11, 77.00),
('Python Programming', 12, 80.00),
('Python Programming', 14, 56.00),
('Python Programming', 15, 91.00);

-- =====================
-- 3. Students with <50% in Linux
-- =====================
SELECT s.student_id, s.student_name, l.grade_obtained
FROM students s
JOIN linux_grades l ON s.student_id = l.student_id
WHERE l.grade_obtained < 50;

-- =====================
-- 4. Students who took only one course
-- =====================
SELECT s.student_id, s.student_name
FROM students s
WHERE s.student_id IN (SELECT student_id FROM linux_grades)
  XOR s.student_id IN (SELECT student_id FROM python_grades);

-- =====================
-- 5. Students who took both courses
-- =====================
SELECT s.student_id, s.student_name
FROM students s
WHERE s.student_id IN (SELECT student_id FROM linux_grades)
  AND s.student_id IN (SELECT student_id FROM python_grades);

-- =====================
-- 6. Average grade per course
-- =====================
SELECT course_name, AVG(grade_obtained) AS average_grade
FROM linux_grades
GROUP BY course_name;

SELECT course_name, AVG(grade_obtained) AS average_grade
FROM python_grades
GROUP BY course_name;

-- =====================
-- 7. Top-performing student across both courses
-- =====================
SELECT s.student_id, s.student_name,
       AVG(g.grade) AS average_grade
FROM students s
JOIN (
    SELECT student_id, grade_obtained AS grade FROM linux_grades
    UNION ALL
    SELECT student_id, grade_obtained AS grade FROM python_grades
) g ON s.student_id = g.student_id
GROUP BY s.student_id, s.student_name
ORDER BY average_grade DESC
LIMIT 1;
