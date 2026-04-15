-- Digital Library Audit System
-- Schema, sample data, and analytical queries
-- Books table
CREATE TABLE Books (
    book_id INT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    author VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    availability_status VARCHAR(20) NOT NULL DEFAULT 'Available'
);

-- Students table
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    course VARCHAR(100) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Active'
);

-- Issued books table
CREATE TABLE IssuedBooks (
    issue_id INT PRIMARY KEY,
    book_id INT NOT NULL,
    student_id INT NOT NULL,
    issue_date DATE NOT NULL,
    return_date DATE NULL,
    CONSTRAINT fk_issue_book
        FOREIGN KEY (book_id) REFERENCES Books(book_id),
    CONSTRAINT fk_issue_student
        FOREIGN KEY (student_id) REFERENCES Students(student_id)
);

-- Sample data: Books (12 books)
INSERT INTO Books (book_id, title, author, category, availability_status) VALUES
(1, 'The Silent Patient', 'Alex Michaelides', 'Fiction', 'Available'),
(2, 'A Brief History of Time', 'Stephen Hawking', 'Science', 'Available'),
(3, 'Sapiens: A Brief History of Humankind', 'Yuval Noah Harari', 'History', 'Available'),
(4, 'The Alchemist', 'Paulo Coelho', 'Fiction', 'Available'),
(5, 'Thinking, Fast and Slow', 'Daniel Kahneman', 'Psychology', 'Available'),
(6, 'The Selfish Gene', 'Richard Dawkins', 'Science', 'Available'),
(7, 'Guns, Germs, and Steel', 'Jared Diamond', 'History', 'Available'),
(8, 'Clean Code', 'Robert C. Martin', 'Technology', 'Available'),
(9, 'Introduction to Algorithms', 'Cormen et al.', 'Technology', 'Available'),
(10, 'The Great Gatsby', 'F. Scott Fitzgerald', 'Fiction', 'Available'),
(11, 'World War II', 'Winston Churchill', 'History', 'Available'),
(12, 'The Gene', 'Siddhartha Mukherjee', 'Science', 'Available');

-- Sample data: Students (10 students)
INSERT INTO Students (student_id, name, course, status) VALUES
(101, 'Aarav Mehta', 'BSc Physics', 'Active'),
(102, 'Neha Sharma', 'BA History', 'Active'),
(103, 'Rohan Iyer', 'BTech CSE', 'Active'),
(104, 'Sara Khan', 'BSc Biology', 'Active'),
(105, 'Vikram Singh', 'BCom Finance', 'Active'),
(106, 'Ananya Rao', 'BTech IT', 'Active'),
(107, 'Kabir Das', 'BA English', 'Active'),
(108, 'Meera Nair', 'BSc Chemistry', 'Active'),
(109, 'Arjun Verma', 'BBA', 'Active'),
(110, 'Isha Patel', 'BA Sociology', 'Active');

-- Sample data: Issued books (18 records)
-- Some returns are NULL (not returned). Some issue dates are older than 14 days.
-- Some students have not borrowed in over 3 years (e.g., last borrow in 2022).
INSERT INTO IssuedBooks (issue_id, book_id, student_id, issue_date, return_date) VALUES
(1001, 1, 101, '2026-03-01', '2026-03-10'),
(1002, 2, 102, '2026-03-05', NULL),
(1003, 3, 103, '2026-03-20', '2026-03-28'),
(1004, 4, 104, '2026-03-25', NULL),
(1005, 5, 105, '2026-02-20', '2026-03-02'),
(1006, 6, 106, '2026-01-15', '2026-01-25'),
(1007, 7, 107, '2026-02-01', NULL),
(1008, 8, 108, '2025-12-10', '2025-12-28'),
(1009, 9, 103, '2026-04-01', NULL),
(1010, 10, 109, '2026-03-18', '2026-03-30'),
(1011, 11, 110, '2026-03-02', NULL),
(1012, 12, 101, '2025-11-15', '2025-11-30'),
(1013, 2, 104, '2026-02-10', '2026-02-24'),
(1014, 3, 105, '2025-10-05', '2025-10-20'),
(1015, 4, 106, '2022-11-15', '2022-11-29'),
(1018, 7, 109, '2026-02-25', NULL);

-- Core Query 1: Overdue books report (not returned within 14 days)
-- Finds students with unreturned books older than 14 days
SELECT
    s.name AS student_name,
    b.title AS book_title,
    i.issue_date
FROM IssuedBooks i
INNER JOIN Students s ON i.student_id = s.student_id
INNER JOIN Books b ON i.book_id = b.book_id
WHERE i.return_date IS NULL
  AND i.issue_date < DATE_SUB(CURRENT_DATE, INTERVAL 14 DAY)
ORDER BY i.issue_date;

-- Optional Enhancement: Overdue fine calculation (Rs 5 per day after 14 days)
-- Calculates fine only for overdue, unreturned books
SELECT
    s.name AS student_name,
    b.title AS book_title,
    i.issue_date,
    (DATEDIFF(CURRENT_DATE, i.issue_date) - 14) * 5 AS overdue_fine
FROM IssuedBooks i
INNER JOIN Students s ON i.student_id = s.student_id
INNER JOIN Books b ON i.book_id = b.book_id
WHERE i.return_date IS NULL
  AND i.issue_date < DATE_SUB(CURRENT_DATE, INTERVAL 14 DAY)
ORDER BY overdue_fine DESC;

-- Core Query 2: Popularity index by category
-- Counts how many times each category is borrowed
SELECT
    b.category AS category,
    COUNT(*) AS total_borrows
FROM IssuedBooks i
INNER JOIN Books b ON i.book_id = b.book_id
GROUP BY b.category
ORDER BY total_borrows DESC;

-- Optional Enhancement: Top 3 most borrowed books
SELECT
    b.title AS book_title,
    COUNT(*) AS borrow_count
FROM IssuedBooks i
INNER JOIN Books b ON i.book_id = b.book_id
GROUP BY b.title
ORDER BY borrow_count DESC
LIMIT 3;

-- Core Query 3: Identify inactive students (no borrow in last 3 years)
-- Uses LEFT JOIN to detect students with no recent issues
SELECT
    s.student_id,
    s.name AS student_name,
    s.course,
    s.status
FROM Students s
LEFT JOIN IssuedBooks i
    ON s.student_id = i.student_id
    AND i.issue_date >= DATE_SUB(CURRENT_DATE, INTERVAL 3 YEAR)
WHERE i.issue_id IS NULL
ORDER BY s.student_id;

-- Data cleanup option A: Update inactive students to 'Inactive'
-- Marks students with no borrow in the last 3 years
UPDATE Students s
LEFT JOIN IssuedBooks i
    ON s.student_id = i.student_id
    AND i.issue_date >= DATE_SUB(CURRENT_DATE, INTERVAL 3 YEAR)
SET s.status = 'Inactive'
WHERE i.issue_id IS NULL;

UPDATE Books b
LEFT JOIN IssuedBooks i
    ON b.book_id = i.book_id
    AND i.return_date IS NULL
SET b.availability_status = CASE
    WHEN i.issue_id IS NULL THEN 'Available'
    ELSE 'Borrowed'
END;
