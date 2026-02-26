CREATE DATABASE lab1; --1

CREATE TABLE clients (  --2
    clients_id SERIAL, -- автокримент
    first_name VARCHAR(60),
    last_name VARCHAR(60),
    email VARCHAR(100),
    date_joined DATE
);

ALTER TABLE clients --3
ADD COLUMN status INt;

ALTER TABLE clients
alter column status type booleann  --4
using status:: boolean;

alter table clients
alter column status set default true;  --5

alter table clients
add constraint clients_pk primary key (clients_id);  --6

CREATE TABLE orders (
    orders_id SERIAL Primary key,   -7
    orders_name VARCHAR(100),
    clients_id INT REFERENCES clients(clients_id)
);

DROP TABLE orders; --8

DROP DATABASE lab1; --9
