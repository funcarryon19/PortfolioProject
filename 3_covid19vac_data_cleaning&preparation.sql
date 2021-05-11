SELECT
	*
FROM covid19vac;

/*
1. Join "Covid19vac" and "Covid19deaths" tables together
*/
SELECT
	*
FROM covid19deaths AS dt
INNER JOIN covid19vac AS vc
	ON dt.location = vc.location
	AND dt.date = vc.date
ORDER BY
	dt.location ASC,
	dt.date DESC;
	
-------------------------------------------------------------------------
/*
2. Total population vs total vaccinations
What amount of people in the world that have been vacinated?
*/
SELECT
	dt.continent,
	dt.location,
	dt.date,
	dt.population,
	vc.new_vaccinations
FROM covid19deaths AS dt
INNER JOIN covid19vac AS vc
	ON dt.location = vc.location
	AND dt.date = vc.date
WHERE
	dt.continent IS NOT NULL
ORDER BY
	1, 2, 3;
	
-------------------------------------------------------------------------
/*
3. Find new vaccinations per day by using window function
*/
SELECT
	dt.continent,
	dt.location,
	TO_DATE(dt.date, 'DD MM YYYY') AS date,
	dt.population,
	vc.new_vaccinations,
	SUM(vc.new_vaccinations) OVER(PARTITION BY dt.location
								  ORDER BY dt.location, dt.date) AS roll_people_vac
FROM covid19deaths AS dt
INNER JOIN covid19vac AS vc
	ON dt.location = vc.location
	AND dt.date = vc.date
WHERE
	dt.continent IS NOT NULL
	AND dt.location = 'Albania';

-------------------------------------------------------------------------
/* CTE
4. Total Population vs Vaccinations by using MAX() of roll_people_vac
(max number is at the bottom of roll_people_vac column)
*/
WITH popvsvac AS (
SELECT
	dt.continent,
	dt.location,
	TO_DATE(dt.date, 'DD MM YYYY') AS date,
	dt.population,
	vc.new_vaccinations,
	SUM(vc.new_vaccinations) OVER(PARTITION BY dt.location
								  ORDER BY dt.location, dt.date) AS roll_people_vac
FROM covid19deaths AS dt
INNER JOIN covid19vac AS vc
	ON dt.location = vc.location
	AND dt.date = vc.date
WHERE
	dt.continent IS NOT NULL
)
SELECT
	*,
	ROUND((roll_people_vac::NUMERIC / population::NUMERIC), 3) * 100 AS pop_vs_vac
FROM popvsvac;

-------------------------------------------------------------------------
/* TEMP TABLE
4. Total Population vs Vaccinations by using MAX() of roll_people_vac
(max number is at the bottom of roll_people_vac column)
*/
/*
	CREATE TEMPORARY TABLE perpopvsvac AS (
	SELECT
		dt.continent,
		dt.location,
		TO_DATE(dt.date, 'DD MM YYYY') AS date,
		dt.population,
		vc.new_vaccinations,
		SUM(vc.new_vaccinations) OVER(PARTITION BY dt.location
									  ORDER BY dt.location, dt.date) AS roll_people_vac
	FROM covid19deaths AS dt
	INNER JOIN covid19vac AS vc
		ON dt.location = vc.location
		AND dt.date = vc.date
	WHERE
		dt.continent IS NOT NULL
	);
*/
SELECT
	*,
	ROUND((roll_people_vac::NUMERIC / population::NUMERIC), 3) * 100 AS pop_vs_vac
FROM perpopvsvac;





