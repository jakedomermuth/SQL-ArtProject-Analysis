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


--Part 1: I will be exploring different metrics related to the museum's hours and availability.



--Looking at the amount of museums in each state.

SELECT [state],
	Count([name]) AS museums_per_state
FROM dbo.museum$ 
WHERE country = 'USA'
GROUP BY [state];



--Which museums have the most paintings?
SELECT m.museum_id, 
	m.[name], 
	m.[address], 
	num_of_paintings
FROM museum$ m
	INNER JOIN
		(SELECT museum_id, COUNT(work_id) as num_of_paintings
		FROM work$
		GROUP BY museum_id) sub
	ON m.museum_id = sub.museum_id
ORDER BY 4 DESC



--Identifying opening time and identification information for USA-based museums.

SELECT m.[name],
	m.[state],
	m.[address],
	mh.[day],
	mh.[open],
	mh.[close]
FROM museum$ m 
	INNER JOIN museum_hours$ mh
	ON m.museum_id = mh.museum_id
WHERE m.[country] = 'USA';


--Looking for museums that open before 11 AM and remain open until at least 5 PM.


SELECT m.[name],
	m.[address],
	mh.[open],
	mh.[close]
FROM museum$ m 
	INNER JOIN museum_hours$ mh
	ON m.museum_id = mh.museum_id
WHERE mh.[open] < '11:00:00' AND mh.[close] >= '05:00:00'
ORDER BY 3, 4;



--Which museums are available on the weekends(FRIDAY-SATURDAY-SUNDAY)?

SELECT mh.museum_id,
	m.[name],
	m.city
FROM [dbo].[museum_hours$] mh
INNER JOIN museum$ m
ON mh.museum_id = m.museum_id
WHERE [day] = 'Friday'
AND EXISTS 
(SELECT museum_id 
	 FROM [dbo].[museum_hours$] mh2
	 WHERE mh2.museum_id = mh.museum_id
	 AND mh2.[day] = 'Saturday')
AND EXISTS 
(SELECT museum_id
	FROM [dbo].[museum_hours$] mh3
	WHERE mh3.museum_id = mh.museum_id
	AND mh3.[day] = 'Sunday');