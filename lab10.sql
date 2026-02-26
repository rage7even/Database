
CREATE TABLE Movies (
    movie_id INT PRIMARY KEY,
    title VARCHAR(255),
    genre VARCHAR(50),
    price_per_day DECIMAL(5, 2),
    available_copies INT
);

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255)
);

CREATE TABLE Rentals (
    rental_id INT PRIMARY KEY,
    movie_id INT,
    customer_id INT,
    rental_date DATE,
    quantity INT,
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

INSERT INTO Movies (movie_id, title, genre, price_per_day, available_copies) VALUES
(1, 'The Matrix', 'Sci-Fi', 5.00, 8),
(2, 'Titanic', 'Romance', 3.50, 12),
(3, 'Avengers: Endgame', 'Action', 6.00, 5);

INSERT INTO Customers (customer_id, name, email) VALUES
(201, 'Alice Johnson', 'alice.j@example.com'),
(202, 'Bob Smith', 'bob.smith@example.com');

INSERT INTO Rentals (rental_id, movie_id, customer_id, rental_date, quantity) VALUES
(1, 1, 201, '2024-11-01', 2),
(2, 2, 202, '2024-11-03', 1),
(3, 3, 201, '2024-11-05', 3);

-- TASK 1
BEGIN;

INSERT INTO Rentals (rental_id, movie_id, customer_id, rental_date, quantity)
VALUES (4, 1, 201, CURRENT_DATE, 2);

UPDATE Movies
SET available_copies = available_copies - 2
WHERE movie_id = 1;

COMMIT;

-- TASK 2
BEGIN;

INSERT INTO Rentals (rental_id, movie_id, customer_id, rental_date, quantity)
VALUES (5, 3, 202, CURRENT_DATE, 10);

ROLLBACK;

--Task3
-- SESSION 1
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;

UPDATE Movies
SET price_per_day = 10.00
WHERE movie_id = 1;

-- SESSION 2
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;

SELECT price_per_day FROM Movies WHERE movie_id = 1;

COMMIT;

SELECT price_per_day FROM Movies WHERE movie_id = 1;

COMMIT;

-- TASK 4
BEGIN;

UPDATE Customers
SET email = 'alice.new@example.com'
WHERE customer_id = 201;

COMMIT;

