CREATE TABLE Reviewer (
    reviewerID INT PRIMARY KEY,
    name VARCHAR(100)
);

INSERT INTO Reviewer (reviewerID, name) VALUES
(301, 'Alex Johnson'),
(302, 'Maria Gomez'),
(303, 'John Doe'),
(304, 'Linda Brown'),
(305, 'Michael Thompson'),
(306, 'Emily Davis'),
(307, 'Daniel White'),
(308, 'Sophia Lee');

-- Таблица Movie
CREATE TABLE Movie (
    movieID INT PRIMARY KEY,
    title VARCHAR(100),
    releaseYear INT,
    director VARCHAR(100)
);

-- Movie
INSERT INTO Movie (movieID, title, releaseYear, director) VALUES
(401, 'Future World', 2024, 'Alice Smith'),
(402, 'The Last Adventure', 2024, 'John Black'),
(403, 'New Horizons', 2024, 'Maria Johnson'),
(404, 'Time Capsule', 2024, 'Chris Martin'),
(405, 'Beyond the Stars', 2024, NULL),
(406, 'The Silent Valley', 2024, 'Laura Green'),
(407, 'Lost in the Echo', 2024, 'Daniel White'),
(408, 'Shadow of Destiny', 2024, 'James Clarke');

-- Таблица Review
CREATE TABLE Review (
    reviewerID INT,
    movieID INT,
    rating INT,
    reviewDate DATE,
    PRIMARY KEY (reviewerID, movieID),
    FOREIGN KEY (reviewerID) REFERENCES Reviewer(reviewerID),
    FOREIGN KEY (movieID) REFERENCES Movie(movieID)
);

--Review
INSERT INTO Review (reviewerID, movieID, rating, reviewDate) VALUES
(301, 401, 5, '2024-02-15'),
(301, 402, 4, '2024-02-20'),
(302, 403, 5, '2024-01-11'),
(303, 404, 3, '2024-01-23'),
(304, 405, 4, '2024-01-15'),
(305, 406, 2, '2024-03-01'),
(306, 407, 5, '2024-02-05'),
(307, 408, 4, '2024-03-12');

--2
create view high_rated_movie_years as
select distinct m.releaseYear from Movie m
join review r on m.movieid = r.movieid
where r.rating >= 4
order by m.releaseyear;

--3
create index idx_review_rating on review(rating);
create index idx_review_movieID on review(movieid);
create index idx_movie_release_year on movie(releaseyear);
create index idx_review_movie_rating on review(movieid, rating);

--4
create role movie_admin with login createrole;

--5
grant create, connect on database postgres to movie_admin;
grant usage on schema public to movie_admin;
grant select, insert, update, delete on all tables in schema public to movie_admin;
grant usage, select on all sequences in schema public to movie_admin;

--6
alter table reviewer owner to movie_admin;
alter table movie owner to movie_admin;
alter table review owner to movie_admin;

--7
create view top_rated_2024_movies as
select m.title, rv.name as reviewer_name
from movie m
join review r on m.movieid = r.movieid
join reviewer rv on r.reviewerid = rv.reviewerid
where r.rating = 5
and extract(year from r.reviewdate) = 2024
order by m.title;

