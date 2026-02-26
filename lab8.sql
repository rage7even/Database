CREATE TABLE members (
    member_id INT PRIMARY KEY,
    member_name VARCHAR(100),
    city VARCHAR(50),
    membership_level INT,
    librarian_id INT
);

INSERT INTO members (member_id, member_name, city, membership_level, librarian_id) VALUES
(1001, 'John Doe', 'New York', 1, 2001),
(1002, 'Alice Johnson', 'California', 2, 2002),
(1003, 'Bob Smith', 'London', 1, 2003),
(1004, 'Sara Green', 'Paris', 3, 2004),
(1005, 'David Brown', 'New York', 1, 2001),
(1006, 'Emma White', 'Berlin', 2, 2005),
(1007, 'Olivia Black', 'Rome', 3, 2006);

CREATE TABLE borrowings (
    borrowing_id INT PRIMARY KEY,
    borrow_date DATE,
    return_date DATE,
    member_id INT,
    librarian_id INT,
    book_id INT,
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

INSERT INTO borrowings (borrowing_id, borrow_date, return_date, member_id, librarian_id, book_id) VALUES
(30001, '2023-01-05', '2023-01-10', 1002, 2002, 5001),
(30002, '2022-07-10', '2022-07-17', 1003, 2003, 5002),
(30003, '2021-05-12', '2021-05-20', 1001, 2001, 5003),
(30004, '2020-04-08', '2020-04-15', 1006, 2005, 5004),
(30005, '2024-02-20', '2024-02-28', 1007, 2006, 5005), -- Исправлена дата (февраль не имеет 30 дней)
(30006, '2023-06-02', '2023-06-12', 1005, 2001, 5001);

CREATE TABLE librarians (
    librarian_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50),
    commission DECIMAL(3,2)
);

INSERT INTO librarians (librarian_id, name, city, commission) VALUES
(2001, 'Michael Green', 'New York', 0.15),
(2002, 'Anna Blue', 'California', 0.13),
(2003, 'Chris Red', 'London', 0.12),
(2004, 'Emma Yellow', 'Paris', 0.14),
(2005, 'David Purple', 'Berlin', 0.12),
(2006, 'Laura Orange', 'Rome', 0.13);

--3
create view new_york_librarians as
select * from librarians where city = 'New York';

--4
create view borrowing_details as
select
    b.borrowing_id, b.borrow_date, b.return_date,
    m.member_name,
    l.name as librarian_name,
    b.book_id
from borrowings b
join members m on b.member_id = m.member_id
join librarians l on b.librarian_id = l.librarian_id;

create Role library_user;

grant select on borrowing_details to library_user;

--5
create view highest_level_members as
select *  from members
where membership_level = (select max(membership_level) from members);

grant select on highest_level_members to library_user;

--6
create view librarians_per_city as
select city, count(*) librarians_count from librarians
group by city;

--7
create view librarians_with_multiple_members as
select l.*, count(distinct m.member_id) as unquie_memebers_count from librarians l
join members m on l.librarian_id = m.librarian_id
group by l.librarian_id, l.name, l.city, l.commission
having count(distinct m.member_id) > 1;

--8
create Role intern;
grant library_user to intern;