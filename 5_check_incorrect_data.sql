/*
    Due to Covid19deaths incorrect data
    continent column = Null 
    location column = continent name
    Need to check whether it is correct or not
*/

SELECT
	continent,
	MAX(total_deaths) AS total_death_count
FROM covid19deaths
GROUP BY
	1
ORDER BY
	total_death_count DESC;
	
SELECT
	(CASE
	 	WHEN continent IS NULL AND location = 'Asia' THEN 'Asia'
	 	WHEN continent IS NULL AND location = 'World' THEN 'World'
	 	WHEN continent IS NULL AND location = 'Europe' THEN 'Europe'
	 	WHEN continent IS NULL AND location = 'North America' THEN 'North America'
	 	WHEN continent IS NULL AND location = 'European Union' THEN 'European Union'
	 	WHEN continent IS NULL AND location = 'South America' THEN 'South America'
	 	WHEN continent IS NULL AND location = 'Africa' THEN 'Africa'
	 	WHEN continent IS NULL AND location = 'World' THEN 'World'
	 	ELSE continent
	 END) AS continent,
	 MAX(total_deaths) AS total_death_count
FROM covid19deaths
GROUP BY
	1
ORDER BY
	total_death_count DESC;

WITH t1 AS (
	SELECT
		location,
		MAX(total_deaths) AS total_death_count
	FROM covid19deaths
	WHERE
		continent IS NULL
	GROUP BY
		1
	ORDER BY
		total_death_count DESC
)
SELECT
	t1.*,
	SUM(total_death_count) OVER() AS world_total_death
FROM t1
-------------------------------------------------------------------
/* Check continents' total death count by Window Function  */
WITH t2 AS (
	SELECT
		continent,
		total_deaths,
		MAX(total_deaths) OVER(PARTITION BY continent ORDER BY total_deaths DESC) AS max_deaths,
		DENSE_RANK() OVER(PARTITION BY continent ORDER BY total_deaths DESC) AS rank
	FROM covid19deaths
	WHERE
		total_deaths IS NOT NULL
)
SELECT
	t2.*
FROM t2
WHERE
	rank <= 3;


