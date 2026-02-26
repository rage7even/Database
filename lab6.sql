create table courses(
    course_id serial primary key,  --2
    course_name varchar(50),
    course_code varchar(10),
    credits integer
);

create table professors(
    professor_id serial primary key,
    first_name varchar(50),
    last_name varchar(50),
    department varchar(50)
);

create table students(
    student_id serial primary key,
    first_name varchar(50),
    last_name varchar(50),
    major varchar(50),
    year_enrolled integer
);

create table enrollments(
    enrollment_id serial primary key,
    student_id integer references students(student_id),
    course_id  integer references courses(course_id),
    professor_id integer references professors(professor_id),
    enrollment_date date
);

-- 1) Courses
INSERT INTO courses (course_name, course_code, credits) VALUES
('Database Systems',     'DB101', 4),
('Advanced SQL',         'DB201', 3),
('Data Modeling',        'DM101', 3),
('Algorithms',           'CS101', 4),
('Operating Systems',    'CS201', 4),
('Computer Networks',    'CN101', 3),
('Machine Learning',     'ML301', 4),
('Web Development',      'WD101', 2);

-- 2) Professors
INSERT INTO professors (first_name, last_name, department) VALUES
('Ivan',    'Ivanov',   'Computer Science'),
('Anna',    'Petrova',  'Computer Science'),
('Sergey',  'Sidorov',  'Computer Science'),
('Aida',    'Karimova', 'Information Systems'),
('Wei',     'Zhang',    'Computer Science'),
('Olga',    'Smirnova', 'Mathematics');

-- 3) Students
INSERT INTO students (first_name, last_name, major, year_enrolled) VALUES
('Alisher',  'Tuleyev',    'Computer Science', 2021),
('Madina',   'Amanova',    'Information Systems', 2022),
('Ruslan',   'Beketov',    'Computer Science', 2020),
('Dinara',   'Zhaksylykov', 'Computer Science', 2023),
('Arman',    'Nurgaliyev', 'Software Engineering', 2021),
('Aruzhan',  'Suleimen',   'Data Science', 2022),
('Yerzhan',  'Kozhabergen','Computer Networks', 2019),
('Kamila',   'Abdullaeva', 'Information Systems', 2020),
('Nurzhan',  'Orazbayev',  'Computer Science', 2021),
('Lina',     'Sadykova',   'Mathematics', 2020),
('Bekzat',   'Askarov',    'Computer Science', 2024),
('Madina2',  'Karim',      'Web Development', 2023);

-- 4) Enrollments
INSERT INTO enrollments (student_id, course_id, professor_id, enrollment_date) VALUES
-- Alisher: DB Systems, Algorithms
(1, 1, 1, DATE '2021-09-01'),
(1, 4, 1, DATE '2021-09-01'),

-- Madina (Amanova): Advanced SQL, Data Modeling (enrolled 2022)
(2, 2, 2, DATE '2022-02-15'),
(2, 3, 4, DATE '2022-02-16'),

-- Ruslan: OS, Networks
(3, 5, 5, DATE '2020-09-05'),
(3, 6, 5, DATE '2020-09-05'),

-- Dinara: Machine Learning (2023)
(4, 7, 2, DATE '2023-03-10'),

-- Arman: DB Systems, Advanced SQL
(5, 1, 1, DATE '2021-09-03'),
(5, 2, 2, DATE '2021-09-03'),

-- Aruzhan: Machine Learning, Data Modeling
(6, 7, 2, DATE '2022-09-01'),
(6, 3, 4, DATE '2022-09-02'),

-- Yerzhan: Computer Networks (enrolled long ago)
(7, 6, 5, DATE '2019-09-01'),

-- Kamila: Operating Systems, Algorithms
(8, 5, 5, DATE '2020-09-10'),
(8, 4, 1, DATE '2020-09-10'),

-- Nurzhan: Database Systems (2021)
(9, 1, 4, DATE '2021-09-02'),

-- Lina: Algorithms (mathematics student taking algorithms)
(10, 4, 1, DATE '2020-09-08'),

-- Bekzat: Advanced SQL (2024)
(11, 2, 2, DATE '2024-09-01'),


(1, 3, 3, DATE '2021-09-04');  -- Alisher enrolled in Data Modeling with Sidorov


--3
select s.first_name as student_frist_name,
       s.last_name as student_last_name,
       c.course_name,
       p.last_name as professor_last_name
from students s
join enrollments e on s.student_id = e.student_id
join courses c on e.course_id = c.course_id
join professors p on e.professor_id = p.professor_id
order by s.last_name, s.first_name;

--4
select distinct s.first_name, s.last_name
from students s
join enrollments e on s.student_id = e.student_id
join courses c on e.course_id = c.course_id
where c.credits > 3
order by s.last_name, s.first_name;

--5
select c.course_name, count(e.student_id) as students_count
from courses c
left join enrollments e on c.course_id = e.course_id
group by  c.course_id, c.course_name
order by students_count desc, c.course_name;

--6
select distinct p.first_name, p.last_name from professors p
join enrollments e on p.professor_id = e.professor_id
order by p.last_name, p.first_name;

--7
select distinct s.first_name, s.last_name from students s
join enrollments e on s.student_id = e.student_id
join professors p on e.professor_id = p.professor_id
where p.department = 'Computer Science'
order by s.last_name, s.first_name;

--8
with prof_total as (
    select e.professor_id, sum(distinct c.credits) as total_credits
    from enrollments e
    join courses c on e.course_id = c.course_id
    join professors p on e.professor_id = p.professor_id
    where p.last_name like 'S%'
    group by e.professor_id
)
select c.course_name, p.last_name as professor_last_name, pt.total_credits
from enrollments e
join professors p on e.professor_id = p.professor_id
join courses c on e.course_id = c.course_id
join prof_total pt on p.professor_id = pt.professor_id
where p.last_name like 'S%'
order by p.last_name, c.course_name;

--9
select distinct s.first_name, s.last_name, e.enrollment_date
from students s
join enrollments e on s.student_id = e.student_id
where e.enrollment_date < '2022-01-01'
order by e.enrollment_date, s.last_name, s.first_name;

--10
select c.course_name from courses c
left join enrollments e on c.course_id = e.course_id
where e.enrollment_id is null
order by c.course_name;