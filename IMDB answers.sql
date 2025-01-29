USE imdb;
-- 1. Count the total number of records in each table of the database.
SELECT * from director_mapping;
SELECT COUNT(*) Count_of_Directormapping from director_mapping;  -- This query counts the total number of records in the director_mapping table

SELECT * FROM genre;
SELECT COUNT(*) Count_of_genre from genre;

SELECT * FROM movie;
SELECT COUNT(*) Count_of_movie from movie;

SELECT * FROM names;
SELECT COUNT(*) Count_of_names from names;

SELECT * FROM ratings;
SELECT COUNT(*) Count_of_ratings from ratings;

SELECT * FROM role_mapping;
SELECT COUNT(*) Count_of_rolemapping from role_mapping;

-- 2. Identify which columns in the movie table contain null values.
-- This query checks for the count of NULL values in various columns of the 'movie' table.

-- Count of NULL values in the 'id' column
SELECT 
    'id' AS column_name, COUNT(*) AS null_count 
FROM movie 
WHERE id IS NULL

UNION ALL

-- Count of NULL values in the 'title' column
SELECT 
    'title' AS column_name, COUNT(*) AS null_count 
FROM movie 
WHERE title IS NULL

UNION ALL

-- Count of NULL values in the 'year' column
SELECT 
    'year' AS column_name, COUNT(*) AS null_count 
FROM movie 
WHERE year IS NULL

UNION ALL

-- Count of NULL values in the 'date_published' column
SELECT 
    'date_published' AS column_name, COUNT(*) AS null_count 
FROM movie 
WHERE date_published IS NULL

UNION ALL

-- Count of NULL values in the 'duration' column
SELECT 
    'duration' AS column_name, COUNT(*) AS null_count 
FROM movie 
WHERE duration IS NULL

UNION ALL

-- Count of NULL values in the 'country' column
SELECT 
    'country' AS column_name, COUNT(*) AS null_count 
FROM movie 
WHERE country IS NULL

UNION ALL

-- Count of NULL values in the 'worlwide_gross_income' column
SELECT 
    'worlwide_gross_income' AS column_name, COUNT(*) AS null_count 
FROM movie 
WHERE worlwide_gross_income IS NULL

UNION ALL

-- Count of NULL values in the 'languages' column
SELECT 
    'languages' AS column_name, COUNT(*) AS null_count 
FROM movie 
WHERE languages IS NULL

UNION ALL

-- Count of NULL values in the 'production_company' column
SELECT 
    'production_company' AS column_name, COUNT(*) AS null_count 
FROM movie 
WHERE production_company IS NULL;

-- 3. Determine the total number of movies released each year, and analyze how the trend changes month-wise.
-- Number of movies each year
SELECT 
    YEAR(date_published) AS release_year, 
    COUNT(*) AS total_movies
FROM movie
GROUP BY release_year
ORDER BY release_year;

-- Number of movies each month
SELECT 
    MONTH(date_published) AS release_month, 
    COUNT(*) AS total_movies
FROM movie
GROUP BY release_month
ORDER BY release_month;

-- comparing the total movie counts by each month
SELECT 
    YEAR(date_published) AS release_year, 
    MONTH(date_published) AS release_month, 
    COUNT(*) AS total_movies
FROM movie
GROUP BY release_year, release_month
ORDER BY release_year, release_month;

-- 4.How many movies were produced in either the USA or India in the year 2019? 
SELECT country,COUNT(*) FROM movie 
where country in('USA','India')
and year='2019'
group by country;

-- 5.List the unique genres in the dataset, and count how many movies belong exclusively to one genre. 
SELECT g.genre AS unique_genre, COUNT(m.id) AS movie_count
FROM genre g
JOIN movie m ON g.movie_id = m.id
GROUP BY g.genre
ORDER BY movie_count desc;

-- 6.Which genre has the highest total number of movies produced? 
SELECT g.genre AS genre_name, COUNT(m.id) AS movie_count
FROM genre g
JOIN movie m ON g.movie_id = m.id
GROUP BY g.genre
ORDER BY movie_count DESC
LIMIT 1;

-- 7.Calculate the average movie duration for each genre. 
SELECT g.genre AS genre_name, AVG(m.duration) AS average_duration
FROM genre g
JOIN movie m ON g.movie_id = m.id
GROUP BY g.genre
ORDER BY average_duration desc;

-- 8.Identify actors or actresses who have appeared in more than three movies with an average rating below 5. 
SELECT n.name, COUNT(rm.movie_id) AS movie_count, AVG(rt.avg_rating) AS average_rating
FROM role_mapping rm
JOIN ratings rt ON rm.movie_id = rt.movie_id
JOIN names n ON rm.name_id = n.id  
WHERE rt.avg_rating < 5
GROUP BY rm.name_id, n.name
HAVING COUNT(rm.movie_id) > 3;

-- 9.Find the minimum and maximum values for each column in the ratings table, excluding the movie_id column. 
SELECT 
    MIN(avg_rating) AS min_avg_rating,
    MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
    MAX(median_rating) AS max_median_rating
FROM ratings;

-- 10.Which are the top 10 movies based on their average rating? 
SELECT m.title, rt.avg_rating
FROM movie m
JOIN ratings rt ON m.id = rt.movie_id
ORDER BY rt.avg_rating DESC
LIMIT 10;
 
 -- 11.Summarize the ratings table by grouping movies based on their median ratings. 
SELECT rt.median_rating, COUNT(rt.movie_id) AS movie_count
FROM ratings rt
GROUP BY rt.median_rating
ORDER BY rt.median_rating;

-- 12.How many movies, released in March 2017 in the USA within a specific genre, had more than 1,000 votes?
SELECT g.genre, count(*) as total_movies
from genre g join movie m on g.movie_id = m.id
join ratings r on m.id = r.movie_id
where m.date_published like '2017-03-%'
and m.country = 'USA'
and r.total_votes > 1000
group by g.genre;
  
-- 13. Find movies from each genre that begin with the word “The” and have an average rating greater than 8.
 SELECT g.genre, m.title, r.avg_rating
FROM genre g
JOIN movie m ON g.movie_id = m.id
JOIN ratings r ON m.id = r.movie_id
WHERE m.title LIKE 'The %'  
  AND r.avg_rating > 8  
ORDER BY g.genre, r.avg_rating DESC;

-- 14. Of the movies released between April 1, 2018, and April 1, 2019, how many received a median rating of 8?
SELECT COUNT(*) AS num_movies, r.median_rating
FROM movie m
JOIN ratings r ON m.id = r.movie_id
WHERE m.date_published BETWEEN '2018-04-01' AND '2019-04-01'  -- Date range filter
  AND r.median_rating = 8;  -- Movies with a median rating of 8

-- 15. Do German movies receive more votes on average than Italian movies?
SELECT m.country, AVG(r.total_votes) AS avg_votes
FROM movie m
JOIN ratings r ON m.id = r.movie_id
WHERE m.country IN ('Germany', 'Italy')  -- Filter for German and Italian movies
GROUP BY m.country;  -- answer would be yes, German movies receive more vote then Italian movies.

-- 16. Identify the columns in the names table that contain null values.
SELECT 
    COUNT(CASE WHEN id IS NULL THEN 1 END) AS id_nulls,
    COUNT(CASE WHEN name IS NULL THEN 1 END) AS name_nulls,
    COUNT(CASE WHEN height IS NULL THEN 1 END) AS height_nulls,
    COUNT(CASE WHEN date_of_birth IS NULL THEN 1 END) AS date_of_birth_nulls,
    COUNT(CASE WHEN known_for_movies IS NULL THEN 1 END) AS known_for_movies_nulls
FROM names;
-- There are three columns which contains null values those are height_nulls, date_of_birth_nulls, known_for_movies_nulls

-- 17. Who are the top two actors whose movies have a median rating of 8 or higher?
SELECT n.name as actor_name, r.median_rating
from director_mapping d
join names n ON n.id = d.name_id
join ratings r ON r.movie_id = d.movie_id
where r.median_rating >= 8
order by r.median_rating desc
limit 2;

-- 18. Which are the top three production companies based on the total number of votes their movies received?
SELECT m.production_company,
SUM(r.total_votes) AS total_votes
FROM movie m
JOIN ratings r ON m.id = r.movie_id
GROUP BY m.production_company
ORDER BY total_votes DESC
LIMIT 3;

-- 19. How many directors have worked on more than three movies?
SELECT n.name, count(d.movie_id) as total_movies
from director_mapping d
join names n 
on n.id = d.name_id 
group by n.name
having count(d.movie_id) > 3;

-- 20. Calculate the average height of actors and actresses separately
SELECT rm.category, 
AVG(n.height) AS average_height
FROM role_mapping rm
JOIN names n ON rm.name_id = n.id
GROUP BY rm.category;

-- 21. List the 10 oldest movies in the dataset along with their title, country, and director
SELECT m.title, m.country, n.name AS director, m.date_published
FROM movie m
JOIN director_mapping dm ON m.id = dm.movie_id 
JOIN names n ON dm.name_id = n.id  
ORDER BY m.date_published ASC  
LIMIT 10;

-- 22. List the top 5 movies with the highest total votes, along with their genres.
SELECT m.title, r.total_votes, min(g.genre)
FROM movie m
JOIN ratings r ON m.id = r.movie_id
JOIN genre g ON m.id = g.movie_id
group by m.id, r.total_votes
ORDER BY r.total_votes DESC
LIMIT 5;

-- 23. Identify the movie with the longest duration, along with its genre and production company.
SELECT m.title, m.duration, g.genre, m.production_company
FROM movie m
JOIN genre g ON g.movie_id = m.id
ORDER BY m.duration desc
limit 1;

-- 24. Determine the total number of votes for each movie released in 2018.
SELECT m.title, sum(r.total_votes) ,m.year
FROM movie m
JOIN ratings r ON m.id = r.movie_id
WHERE m.year = 2018
group by m.title;

-- 25. What is the most common language in which movies were produced?
SELECT languages, COUNT(*) AS language_count
FROM movie
GROUP BY languages
ORDER BY language_count DESC
LIMIT 1;
