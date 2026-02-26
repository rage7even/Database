Create table Warehouses (
    code int primary key,
    location varchar(255),
    capacity int
);

create table Boxes(
    code char(4) primary key,
    contents varchar(255),
    value real,
    warehouse int references Warehouses(code)
);

-- 2. Заполнение таблицы Warehouses
INSERT INTO Warehouses(code, location, capacity) VALUES (1, 'Chicago', 3);
INSERT INTO Warehouses(code, location, capacity) VALUES (2, 'Rocks', 4);
INSERT INTO Warehouses(code, location, capacity) VALUES (3, 'New York', 7);
INSERT INTO Warehouses(code, location, capacity) VALUES (4, 'Los Angeles', 2);
INSERT INTO Warehouses(code, location, capacity) VALUES (5, 'San Francisco', 8);

-- 2. Заполнение таблицы Boxes
INSERT INTO Boxes(code, contents, value, warehouse) VALUES ('0MN7', 'Rocks', 180, 3);
INSERT INTO Boxes(code, contents, value, warehouse) VALUES ('4H8P', 'Rocks', 250, 1);
INSERT INTO Boxes(code, contents, value, warehouse) VALUES ('4RT3', 'Scissors', 190, 4);
INSERT INTO Boxes(code, contents, value, warehouse) VALUES ('7G3H', 'Rocks', 200, 1);
INSERT INTO Boxes(code, contents, value, warehouse) VALUES ('8JN6', 'Papers', 75, 1);
INSERT INTO Boxes(code, contents, value, warehouse) VALUES ('8Y6U', 'Papers', 50, 3);
INSERT INTO Boxes(code, contents, value, warehouse) VALUES ('9J6F', 'Papers', 175, 2);
INSERT INTO Boxes(code, contents, value, warehouse) VALUES ('LL08', 'Rocks', 140, 4);
INSERT INTO Boxes(code, contents, value, warehouse) VALUES ('POH6', 'Scissors', 125, 1);
INSERT INTO Boxes(code, contents, value, warehouse) VALUES ('P2T6', 'Scissors', 150, 2);
INSERT INTO Boxes(code, contents, value, warehouse) VALUES ('TU55', 'Papers', 90, 5);

select * from Warehouses;--4

select * from Boxes where value > 150;--5

select distinct contents from Boxes;--6

select warehouse, count(*) as box_count
from Boxes
group by warehouse; --7

select warehouse, count(*) as box_count
from Boxes
group by warehouse
having count(*) > 2;  --8

insert into Warehouses(code, location, capacity)
values (6, 'New York', 3); --9

insert into Boxes(code,contents, value, warehouse)
values ('H5RT', 'Papers', 200, 2); -- 10

update Boxes
set value = value * 0.85
where code = (select code from Boxes
                          order by value desc
                          offset 2 limit 1  ); -- 11

delete from Boxes where value < 150; -- 12

delete from Boxes
where warehouse in (select code from Warehouses where location = 'New York')
returning *; --13