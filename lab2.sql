Create table employees (
    employeeId Serial primary key,
    firstName varchar(50),
    lastName varchar(50),
    departmentId integer,
    salary integer
);

Insert into employees (firstName, lastName, departmentId, salary)
Values ('Alya', 'Berik', 77, 60000),
       ('Erkin', 'Bek', 777, 700000);

Insert into employees (firstName, lastName)
values ('Alem', 'Erkinbek');

Insert into employees (firstName, lastName, departmentId, salary)
values ('Zevs', 'Godd', null, 45000);

insert into employees (firstName, lastName, departmentId, salary)
values ('Nurdaulet', 'Elubay', 50, 500000),
       ('Akedil', 'Adilbek', 6, 100000),
       ('Serik', 'Berik', null, 8000),
       ('Mako', 'Bako', 23, 600001),
       ('Cristiano', 'Ronaldo', 7, 1000000),
       ('Kairat', 'Win', 97, 900000);

Alter table employees alter column firstName set default 'John';

Insert into employees (lastName, departmentId, salary)
values ('Kina', 190, 65000);

insert into employees default values;

create table employeesArchive (like employees including all);

insert into employeesArchive select * from employees;

Update employees
set departmentId = 1
where departmentId is null;

select firstName, lastName, salary * 1.15 as updateSalary
from employees;

Delete from employees
where salary < 50000;

Delete from employeesArchive ea
using employees e
where ea.employeeId = e.employeeId
returning ea.*;

delete from employees
returning *;