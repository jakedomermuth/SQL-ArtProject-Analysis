--Looking at each Table.

SELECT *
FROM [dbo].[artist$];

SELECT *
FROM [dbo].[canvas_size$];

SELECT *
FROM [dbo].[museum$];

SELECT *
FROM [dbo].[museum_hours$];

SELECT *
FROM [dbo].[product_size$];

SELECT *
FROM [dbo].[subject$];

SELECT *
FROM [dbo].[work$];


--Adding columns to Table.
ALTER TABLE artist$
ADD artist_lifespan int;

UPDATE artist$
SET artist_lifespan = death - birth;


--Looking at the lifespan of artists, filtered by nationality.
SELECT AVG(artist_lifespan) as lifespan_by_nationality,
	nationality
FROM artist$
GROUP BY nationality
ORDER BY 1 DESC;


--Retrieving a list of US-based artist
SELECT *
FROM artist$
WHERE nationality = 'American';


--Identifying which style is most common among Americans.

SELECT style, 
	count(*) as num_of_american_users
FROM artist$
WHERE nationality = 'American'
GROUP BY style
ORDER BY 2 DESC;


--Returning the artist's name, style, and subject used for each painting.

SELECT DISTINCT
	a.full_name,
	a.style,
	s.[subject],
	w.[name] as painting_name
FROM artist$ a
	INNER JOIN work$ w
	ON a.artist_id = w.artist_id
	INNER JOIN subject$ s
	ON s.work_id = w.work_id;


-- Retrieving a list of the three most common artists to appear in museums.

SELECT TOP 3
	a.artist_id, 
	a.full_name, 
	COUNT(work_id) as count_of_art_in_museums
FROM [dbo].[work$] w
INNER JOIN artist$ a
ON w.artist_id = a.artist_id
WHERE museum_id IS NOT NULL
GROUP BY a.artist_id, a.full_name
ORDER BY 3 DESC;


--Which artist from outside the US has created the most paintings?

SELECT w.artist_id,
a.full_name,
COUNT(work_id) as num_of_paintings
FROM work$ w
JOIN artist$ a
ON w.artist_id = a.artist_id
WHERE nationality != 'American'
GROUP BY w.artist_id, a.full_name;


--Identify the artist whose paintings are displayed in multiple countries.

SELECT
	a.full_name,
	a.artist_id,
	COUNT(DISTINCT m.country) num_museums
FROM work$ w
	INNER JOIN artist$ a
	ON a.artist_id = w.artist_id
	INNER JOIN museum$ m
	ON m.museum_id = w.museum_id
GROUP BY a.artist_id, a.full_name
HAVING COUNT( DISTINCT m.country) > 1;