select last_name from students;
select distinct last_name from students;
select * from students where last_name = 'Johnson';
select * from students where last_name in ('Johnson', 'Smith');

select s.*
from students s
join registration r on s.student_id = r.student_id
join courses c on r.course_id = c.course_id
where c.course_code = 'CS101';

select s.*
from students s
join registration r on s.student_id = r.student_id
join courses c on r.course_id = c.course_id
where c.course_code in ('MATH201', 'PHYS301');

select sum(credits) as total_credits from courses;

select course_id, count(*) as student_count
from registration
group by course_id;

select course_id
from registration
group by course_id
having count(*) > 2;

select course_name
from courses
order by credits desc
offset 1 limit 1;

select s.first_name, s.last_name
from students s
join registration r on s.student_id = r.student_id
join courses c on r.course_id = c.course_id
where c.credits = (select min(credits) from courses);

select first_name, last_name from students where city = 'Almaty';

select * from courses
where credits > 3
order by credits asc, course_id desc;

update courses
set credits = credits - 1
where credits = (select min(credits) from courses);

update registration
set course_id = (select course_id from courses where course_code = 'CS101')
where course_id = (select course_id from courses where course_code = 'MATH201');

delete from registration
where course_id = (select course_id from courses where course_code = 'CS101');
