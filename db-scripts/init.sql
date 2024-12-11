CREATE TABLE Timetable (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(255),
    day VARCHAR(50),
    time VARCHAR(50),
    room VARCHAR(50),
    level INT
);

INSERT INTO Timetable (course_name, day, time, room, level) VALUES
('Computer and Information Security', 'Thursday', '4:30 PM - 06:50 PM', 'Room 114', 2),
('Database Concepts', 'Tuesday', '09:00 AM - 11:20 AM', 'Room 115', 1),
('Discrete Mathematics', 'Thursday', '02:00 PM - 04:20 PM', 'Room 403', 3),
('Principles of Programming', 'Monday', '04:30 PM - 06:50 PM', 'Room 114', 3),
('Operating Systems', 'Wednesday', '11:30 AM - 01:50 PM', 'Room 114', 2),
('IT Project Management', 'Monday', '11:30 AM - 01:50 PM', 'Room 105', 2);
