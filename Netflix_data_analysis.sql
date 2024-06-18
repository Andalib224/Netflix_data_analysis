create database netflix_db;
use netflix_db;


-- Create table: shows
CREATE TABLE shows (
    show_id INT PRIMARY KEY,
    title VARCHAR(255),
    type VARCHAR(50),
    release_year INT,
    rating VARCHAR(10),
    duration VARCHAR(50),
    country VARCHAR(100)
);

-- Create table: genres
CREATE TABLE genres (
    genre_id INT PRIMARY KEY,
    genre VARCHAR(100)
);

-- Create table: show_genres
CREATE TABLE show_genres (
    show_id INT,
    genre_id INT,
    PRIMARY KEY (show_id, genre_id),
    FOREIGN KEY (show_id) REFERENCES shows(show_id),
    FOREIGN KEY (genre_id) REFERENCES genres(genre_id)
);

-- Create table: actors
CREATE TABLE actors (
    actor_id INT PRIMARY KEY,
    name VARCHAR(255)
);

-- Create table: show_actors
CREATE TABLE show_actors (
    show_id INT,
    actor_id INT,
    PRIMARY KEY (show_id, actor_id),
    FOREIGN KEY (show_id) REFERENCES shows(show_id),
    FOREIGN KEY (actor_id) REFERENCES actors(actor_id)
);

-- Insert data into shows
INSERT INTO shows (show_id, title, type, release_year, rating, duration, country) VALUES
(1, 'Stranger Things', 'TV Show', 2016, 'TV-14', '4 Seasons', 'USA'),
(2, 'The Crown', 'TV Show', 2016, 'TV-MA', '4 Seasons', 'UK'),
(3, 'Black Mirror', 'TV Show', 2011, 'TV-MA', '5 Seasons', 'UK'),
(4, 'The Irishman', 'Movie', 2019, 'R', '209 min', 'USA'),
(5, 'La Casa de Papel', 'TV Show', 2017, 'TV-MA', '3 Seasons', 'Spain'),
(6, 'Bird Box', 'Movie', 2018, 'R', '124 min', 'USA'),
(7, 'Roma', 'Movie', 2018, 'R', '135 min', 'Mexico'),
(8, 'The Witcher', 'TV Show', 2019, 'TV-MA', '2 Seasons', 'USA'),
(9, 'Money Heist: The Phenomenon', 'Movie', 2020, 'TV-MA', '57 min', 'Spain'),
(10, '13 Reasons Why', 'TV Show', 2017, 'TV-MA', '4 Seasons', 'USA');

-- Insert data into genres
INSERT INTO genres (genre_id, genre) VALUES
(1, 'Drama'),
(2, 'Thriller'),
(3, 'Horror'),
(4, 'Action'),
(5, 'Documentary'),
(6, 'Comedy');

-- Insert data into show_genres
INSERT INTO show_genres (show_id, genre_id) VALUES
(1, 2),
(1, 3),
(2, 1),
(2, 5),
(3, 1),
(3, 2),
(4, 1),
(4, 4),
(5, 2),
(5, 1),
(6, 3),
(7, 1),
(7, 5),
(8, 4),
(9, 5),
(10, 1);

-- Insert data into actors
INSERT INTO actors (actor_id, name) VALUES
(1, 'Millie Bobby Brown'),
(2, 'Winona Ryder'),
(3, 'Claire Foy'),
(4, 'Olivia Colman'),
(5, 'Robert De Niro'),
(6, 'Al Pacino'),
(7, 'Sandra Bullock'),
(8, 'Yalitza Aparicio'),
(9, 'Henry Cavill'),
(10, 'Úrsula Corberó');

-- Insert data into show_actors
INSERT INTO show_actors (show_id, actor_id) VALUES
(1, 1),
(1, 2),
(2, 3),
(2, 4),
(4, 5),
(4, 6),
(6, 7),
(7, 8),
(8, 9),
(5, 10);

-- 1. List all the TV Shows and Movies available in the dataset.
SELECT * FROM shows;

-- 2. Count the number of TV Shows and Movies by type.
SELECT type, COUNT(*) AS count FROM shows GROUP BY type;

-- 3. Find the average release year of the shows.
SELECT ROUND(AVG(release_year), 0) AS average_released_year
FROM shows
WHERE type = 'TV Show';


-- 4. List all the shows released in the year 2018.
SELECT * FROM shows 
WHERE type = 'TV Show' 
AND release_year = 2018;


-- 5. List all the genres available in the dataset.

SELECT * FROM genres;


-- 6. List all shows along with their respective genres.
SELECT title, type, genres.genre 
FROM shows 
INNER JOIN show_genres 
ON shows.show_id = show_genres.show_id 
INNER JOIN genres 
ON show_genres.genre_id = genres.genre_id;


-- 7. Count the number of shows produced per country.

SELECT country, COUNT(*) AS Show_per_Country 
FROM shows 
WHERE type = 'TV Show' 
GROUP BY country;


-- 8. Find all actors who acted in 'The Irishman'.
SELECT title, actors.name AS actors 
FROM shows 
INNER JOIN show_actors 
ON shows.show_id = show_actors.show_id 
INNER JOIN actors 
ON show_actors.actor_id = actors.actor_id 
WHERE shows.title = 'The Irishman';


-- 9. List all TV shows that have more than 3 seasons.

SELECT *
FROM (
    SELECT *,
           SUBSTRING_INDEX(SUBSTRING_INDEX(duration, ' ', 1), ' ', -1) AS number_of_seasons
    FROM shows
    WHERE type = 'TV Show'
) AS b
WHERE CAST(number_of_seasons AS UNSIGNED) > 3;

-- 10. List all shows with a rating of 'TV-MA'.
SELECT *
FROM shows
WHERE rating = 'TV-MA'
AND type = 'TV Show';

-- 11. Find the total number of shows per genre.

SELECT genres.genre, COUNT(*) as Number_of_Shows
FROM shows
INNER JOIN show_genres ON shows.show_id = show_genres.show_id
INNER JOIN genres ON genres.genre_id = show_genres.genre_id
WHERE shows.type = 'TV Show'
GROUP BY genres.genre;


-- 12. List all actors who have acted in more than one show.
SELECT actors.name, COUNT(DISTINCT sa.show_id) AS num_shows
FROM actors
JOIN show_actors sa ON actors.actor_id = sa.actor_id
GROUP BY actors.name
HAVING COUNT(DISTINCT sa.show_id) > 1;



-- 13. Find the most recent movie released.

SELECT *
FROM shows
WHERE type = 'Movie'
ORDER BY release_year DESC
LIMIT 1;


-- 14. Find all TV shows that are classified as both 'Drama' and 'Thriller'.
SELECT title
FROM shows
INNER JOIN show_genres ON shows.show_id = show_genres.show_id
INNER JOIN genres ON show_genres.genre_id = genres.genre_id
WHERE type = 'TV Show' 
  AND genre IN ('Drama', 'Thriller')
GROUP BY title
HAVING COUNT(DISTINCT genre) = 2;

-- 15. Calculate the average duration of shows per country.
SELECT b.country, ROUND(AVG(duration_in_minutes), 0) AS avg_duration_per_country
FROM (
    SELECT country,
           CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(duration, ' ', 1), ' ', -1) AS UNSIGNED) AS duration_in_minutes
    FROM shows
    WHERE type = 'TV Show'
) AS b
GROUP BY b.country;

