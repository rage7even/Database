create table customers (
    customer_id serial primary key,
    full_name varchar(100) not null,
    email varchar(100) unique not null,
    phone varchar(20) unique not null,
    driver_license varchar(50) unique not null,
    date_of_birth date not null,
    registration_date date default current_date,
    check (date_of_birth <= current_date - interval '18 years')
);

create table offices (
    office_id serial primary key,
    address varchar(200) not null,
    city varchar(50) not null,
    phone varchar(20) unique not null
);

create table employees (
    employee_id serial primary key,
    full_name varchar(100) not null,
    position varchar(50) not null,
    email varchar(100) unique not null,
    office_id integer not null references offices(office_id) on delete cascade
);

create table cars (
    car_id serial primary key,
    license_plate varchar(20) unique not null,
    brand varchar(50) not null,
    model varchar(50) not null,
    year integer not null,
    color varchar(30),
    daily_rate decimal(10, 2) not null,
    status varchar(20) not null default 'available',
    current_office_id integer not null references offices(office_id) on delete set null,
    check (daily_rate > 0),
    check (year between 2000 and extract(year from current_date)),
    check (status in ('available', 'rented', 'maintenance'))
);

create table bookings (
    booking_id serial primary key,
    customer_id integer not null references customers(customer_id) on delete cascade,
    car_id integer not null references cars(car_id) on delete cascade,
    start_date date not null,
    end_date date not null,
    booking_status varchar(20) not null default 'confirmed',
    created_at timestamp default current_timestamp,
    check (end_date > start_date),
    check (booking_status in ('confirmed', 'cancelled', 'completed'))
);

create table rentals (
    rental_id serial primary key,
    booking_id integer unique not null references bookings(booking_id) on delete cascade,
    employee_id integer not null references employees(employee_id) on delete set null,
    pickup_office_id integer not null references offices(office_id),
    return_office_id integer references offices(office_id),
    actual_start_date date not null,
    actual_end_date date,
    total_cost decimal(10, 2),
    check (actual_end_date is null or actual_end_date >= actual_start_date)
);

create table payments (
    payment_id serial primary key,
    rental_id integer not null references rentals(rental_id) on delete cascade,
    amount decimal(10, 2) not null,
    payment_method varchar(20) not null,
    payment_status varchar(20) not null default 'pending',
    payment_date date default current_date,
    check (amount > 0),
    check (payment_method in ('card', 'cash')),
    check (payment_status in ('pending', 'completed', 'refunded'))
);

create table maintenance (
    maintenance_id serial primary key,
    car_id integer not null references cars(car_id) on delete cascade,
    employee_id integer not null references employees(employee_id) on delete set null,
    maintenance_type varchar(30) not null,
    start_date date not null,
    end_date date,
    cost decimal(10, 2),
    description text,
    check (end_date is null or end_date >= start_date),
    check (cost >= 0)
);

insert into offices (address, city, phone) values
('ул. абая 1', 'алматы', '+77001234567'),
('пр. тауелсиздик 10', 'нур-султан', '+77007654321'),
('ул. байтурсынова 25', 'шымкент', '+77005554433'),
('мкр. самал 12', 'алматы', '+77009876543');

insert into employees (full_name, position, email, office_id) values
('алиев али', 'менеджер', 'ali.aliev@rental.kz', 1),
('бердиева айгуль', 'агент', 'aigul.berdi@rental.kz', 1),
('васнецов иван', 'механик', 'ivan.v@rental.kz', 1),
('григорян давид', 'менеджер', 'david.g@rental.kz', 2),
('досанова зарина', 'агент', 'zarina.d@rental.kz', 2),
('ермаков сергей', 'механик', 'sergey.e@rental.kz', 2),
('жаксылык арман', 'менеджер', 'arman.j@rental.kz', 3),
('искакова айша', 'агент', 'aisha.i@rental.kz', 3),
('ким александр', 'механик', 'alex.k@rental.kz', 3),
('латифов рашид', 'менеджер', 'rashid.l@rental.kz', 4),
('муканова айнур', 'агент', 'ainur.m@rental.kz', 4),
('нургалиев бахыт', 'механик', 'bakht.n@rental.kz', 4);

insert into customers (full_name, email, phone, driver_license, date_of_birth) values
('ахметов азамат', 'azamat.a@gmail.com', '+77011112233', 'ab123456', '1990-05-15'),
('баймуханов данияр', 'daniyar.b@mail.ru', '+77022223344', 'ac234567', '1985-08-22'),
('васильева елена', 'elena.vas@yandex.kz', '+77033334455', 'ad345678', '1995-03-10'),
('гончаров дмитрий', 'dima.g@mail.ru', '+77044445566', 'ae456789', '1988-11-30'),
('даулетбеков нурлан', 'nurlan.d@mail.ru', '+77055556677', 'af567890', '1992-07-18'),
('ержанова айгерим', 'aigerim.e@gmail.com', '+77066667788', 'ag678901', '1998-01-25'),
('жуковский максим', 'max.z@mail.ru', '+77077778899', 'ah789012', '1983-09-05'),
('зайцева анна', 'anna.zai@yandex.kz', '+77088889900', 'ai890123', '1994-12-12'),
('иванов иван', 'ivan.ivanov@mail.ru', '+77099990011', 'aj901234', '1991-06-20'),
('карабаев саят', 'sayat.k@mail.ru', '+77000001122', 'ak012345', '1987-04-14');

insert into cars (license_plate, brand, model, year, color, daily_rate, status, current_office_id) values
('01abc001', 'toyota', 'camry', 2022, 'белый', 15000, 'available', 1),
('01abc002', 'toyota', 'rav4', 2023, 'серый', 18000, 'available', 1),
('01abc003', 'hyundai', 'sonata', 2021, 'черный', 14000, 'rented', 1),
('01abc004', 'hyundai', 'tucson', 2022, 'синий', 17000, 'available', 1),
('01abc005', 'kia', 'k5', 2023, 'красный', 16000, 'maintenance', 1),
('02def001', 'mercedes', 'e-class', 2021, 'черный', 35000, 'available', 2),
('02def002', 'bmw', 'x5', 2022, 'белый', 40000, 'available', 2),
('02def003', 'audi', 'a6', 2023, 'серый', 38000, 'rented', 2),
('02def004', 'lexus', 'rx', 2022, 'красный', 42000, 'available', 2),
('02def005', 'volkswagen', 'tiguan', 2021, 'синий', 20000, 'available', 2),
('03ghi001', 'chevrolet', 'spark', 2020, 'желтый', 8000, 'available', 3),
('03ghi002', 'lada', 'vesta', 2021, 'белый', 9000, 'available', 3),
('03ghi003', 'hyundai', 'accent', 2019, 'серый', 8500, 'rented', 3),
('03ghi004', 'toyota', 'corolla', 2022, 'черный', 13000, 'available', 3),
('03ghi005', 'kia', 'rio', 2021, 'зеленый', 11000, 'maintenance', 3);

insert into bookings (customer_id, car_id, start_date, end_date, booking_status) values
(1, 1, '2024-12-01', '2024-12-05', 'completed'),
(2, 6, '2024-12-10', '2024-12-15', 'confirmed'),
(3, 3, '2024-11-25', '2024-11-30', 'completed'),
(4, 8, '2024-12-05', '2024-12-10', 'confirmed'),
(5, 11, '2024-11-20', '2024-11-25', 'completed'),
(6, 2, '2024-12-12', '2024-12-14', 'confirmed'),
(7, 7, '2024-12-03', '2024-12-08', 'confirmed'),
(8, 12, '2024-11-15', '2024-11-20', 'completed'),
(9, 4, '2024-12-07', '2024-12-09', 'cancelled'),
(10, 9, '2024-12-18', '2024-12-20', 'confirmed'),
(1, 5, '2024-12-20', '2024-12-25', 'confirmed'),
(2, 10, '2024-12-22', '2024-12-24', 'confirmed'),
(3, 13, '2024-12-08', '2024-12-10', 'confirmed'),
(4, 14, '2024-12-15', '2024-12-18', 'confirmed'),
(5, 15, '2024-12-25', '2024-12-28', 'confirmed');

insert into rentals (booking_id, employee_id, pickup_office_id, return_office_id, actual_start_date, actual_end_date, total_cost) values
(1, 2, 1, 1, '2024-12-01', '2024-12-05', 60000),
(3, 2, 1, 1, '2024-11-25', '2024-11-30', 70000),
(5, 8, 3, 3, '2024-11-20', '2024-11-25', 40000),
(8, 8, 3, 3, '2024-11-15', '2024-11-20', 45000),
(2, 5, 2, 2, '2024-12-10', '2024-12-15', 175000),
(4, 5, 2, 2, '2024-12-05', '2024-12-10', 190000),
(6, 2, 1, 1, '2024-12-12', '2024-12-14', 36000),
(7, 5, 2, 2, '2024-12-03', '2024-12-08', 200000),
(10, 5, 2, 2, '2024-12-18', '2024-12-20', 84000),
(11, 2, 1, null, '2024-12-20', null, null),
(12, 5, 2, null, '2024-12-22', null, null),
(13, 8, 3, null, '2024-12-08', null, null);

insert into payments (rental_id, amount, payment_method, payment_status) values
(1, 30000.00, 'card', 'completed'),
(1, 30000.00, 'card', 'completed'),
(2, 175000.00, 'cash', 'completed'),
(3, 70000.00, 'card', 'completed'),
(4, 190000.00, 'card', 'completed'),
(5, 40000.00, 'cash', 'completed'),
(6, 36000.00, 'card', 'completed'),
(7, 200000.00, 'card', 'completed'),
(8, 45000.00, 'cash', 'completed'),
(9, 84000.00, 'card', 'completed'),
(10, 50000.00, 'card', 'pending'),
(11, 50000.00, 'card', 'pending'),
(12, 40000.00, 'card', 'pending');

insert into maintenance (car_id, employee_id, maintenance_type, start_date, end_date, cost, description) values
(5, 3, 'ремонт', '2024-11-28', '2024-12-05', 150000, 'замена масла и фильтров'),
(15, 9, 'то', '2024-12-01', '2024-12-02', 50000, 'плановое то'),
(3, 3, 'мойка', '2024-12-03', '2024-12-03', 5000, 'полная мойка'),
(8, 6, 'ремонт', '2024-11-25', '2024-11-30', 200000, 'замена амортизаторов'),
(11, 9, 'то', '2024-11-22', '2024-11-23', 45000, 'замена колодок'),
(1, 3, 'мойка', '2024-12-06', '2024-12-06', 3000, 'стандартная мойка'),
(6, 6, 'диагностика', '2024-12-04', '2024-12-04', 20000, 'компьютерная диагностика'),
(12, 9, 'то', '2024-12-07', '2024-12-08', 48000, 'замена свечей'),
(2, 3, 'замена шин', '2024-11-15', '2024-11-16', 80000, 'зимняя резина'),
(10, 6, 'ремонт', '2024-11-30', '2024-12-02', 90000, 'ремонт кондиционера');

--5
create index idx_customers_email on customers(email);

create index idx_cars_brand_model on cars(brand, model);

create unique index idx_employees_email_unique on employees(email);

create index idx_customers_license_lower on customers(lower(driver_license));

create index idx_bookings_active on bookings(booking_id) where booking_status = 'confirmed';

--6
--1
select r.rental_id, c.full_name, cr.brand, cr.model, r.actual_start_date, r.actual_end_date, r.total_cost
from rentals r
inner join bookings b on r.booking_id = b.booking_id
inner join customers c on b.customer_id = c.customer_id
inner join cars cr on b.car_id = cr.car_id
where r.actual_end_date is not null;

--2
select c.license_plate, c.brand, c.model, m.maintenance_type, m.start_date, m.description
from cars c
left join maintenance m on c.car_id = m.car_id and m.end_date = (
    select max(end_date) from maintenance where car_id = c.car_id
);

-- 3.
select o.city, sum(p.amount) as total_revenue
from payments p
inner join rentals r on p.rental_id = r.rental_id
inner join offices o on r.pickup_office_id = o.office_id
where p.payment_status = 'completed'
group by o.city;

-- 4.
select distinct c.full_name, c.email
from customers c
where c.customer_id in (
    select b.customer_id
    from bookings b
    inner join cars cr on b.car_id = cr.car_id
    where cr.daily_rate > 30000
);

-- 5.
select brand, model, daily_rate
from cars
order by daily_rate desc
limit 5;

-- 6.
explain analyze select * from customers where email = 'azamat.a@gmail.com';

-- 7.
select brand, avg(daily_rate) as avg_daily_rate
from cars
group by brand
having avg(daily_rate) > 20000;

-- 8.
select customer_name, avg(rental_days) as avg_rental_days
from (
    select c.full_name as customer_name, (r.actual_end_date - r.actual_start_date) as rental_days
    from rentals r
    inner join bookings b on r.booking_id = b.booking_id
    inner join customers c on b.customer_id = c.customer_id
    where r.actual_end_date is not null
) as subquery
group by customer_name;

-- 9.
select b.booking_id, c.full_name, cr.brand, cr.model, b.start_date, b.end_date
from bookings b
inner join customers c on b.customer_id = c.customer_id
inner join cars cr on b.car_id = cr.car_id
where b.start_date between '2025-12-01' and '2025-12-31';

-- 10.
select license_plate, brand, model, daily_rate,
    case
        when daily_rate < 10000 then 'бюджетный'
        when daily_rate between 10000 and 30000 then 'средний'
        when daily_rate > 30000 then 'премиум'
        else 'другое'
    end as price_category
from cars;

-- 11.
select full_name, email, 'клиент' as type from customers
union all
select full_name, email, 'сотрудник' as type from employees
order by type, full_name;

-- 12.
select o.city, c.status, count(*) as car_count
from cars c
inner join offices o on c.current_office_id = o.office_id
group by o.city, c.status
order by o.city, car_count desc;

--7
create role admin with login superuser createdb createrole;
create role manager with login;
create role viewer with login;

grant select, insert, update, delete on all tables in schema public to manager;
grant usage on all sequences in schema public to manager;

grant select on all tables in schema public to viewer;

create user aidyn_m with password 'securepass123' in role manager;
create user asyl_v with password 'readonly456' in role viewer;

create user super_admin with password 'adminpass' in role admin;

--8
create view available_cars as
select c.car_id, c.license_plate, c.brand, c.model, c.year, c.color, c.daily_rate, o.city, o.address
from cars c
inner join offices o on c.current_office_id = o.office_id
where c.status = 'available'
and c.car_id not in (
    select b.car_id
    from bookings b
    where b.booking_status = 'confirmed'
    and current_date between b.start_date and b.end_date
)
order by c.daily_rate;

select * from available_cars;

--9
-- 1. топ-3 самых популярных автомобиля (по количеству завершенных аренд)
select c.brand, c.model, count(r.rental_id) as rental_count
from rentals r
inner join bookings b on r.booking_id = b.booking_id
inner join cars c on b.car_id = c.car_id
where r.actual_end_date is not null
group by c.brand, c.model
order by rental_count desc
limit 3;

-- 2. самый непопулярный автомобиль (наименьшее количество бронирований)
select c.brand, c.model, count(b.booking_id) as booking_count
from cars c
left join bookings b on c.car_id = b.car_id
group by c.brand, c.model
order by booking_count
limit 1;

-- 3. общая выручка (по завершенным платежам)
select sum(amount) as total_revenue from payments where payment_status = 'completed';

-- 4. клиенты с самой высокой активностью (по количеству бронирований)
select c.full_name, count(b.booking_id) as total_bookings
from customers c
left join bookings b on c.customer_id = b.customer_id
group by c.full_name
order by total_bookings desc
limit 5;