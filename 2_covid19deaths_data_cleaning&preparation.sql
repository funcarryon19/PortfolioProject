--1. Select the data that we need for the project

SELECT
	location,
	date,
	total_cases,
	new_cases,
	total_deaths,
	population
FROM covid19deaths
ORDER BY
	1, total_deaths NULLS LAST;
	
--2. Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country
SELECT
	location,
	date,
	total_cases,
	total_deaths,
	((total_deaths::NUMERIC / total_cases::NUMERIC) * 100) AS death_rate
FROM covid19deaths
WHERE
	location = 'Thailand';
	
--3. Total Cases vs Population
-- Show what percentage of population got Covid19
SELECT
	location,
	date,
	population,
	total_cases,
	((total_cases::NUMERIC / population::NUMERIC) * 100) AS infect_rate
FROM covid19deaths
WHERE
	location = 'Thailand';
	
--4. Top countries with Highest Infection Rate compared to Population
SELECT
	location,
	population,
	MAX(total_cases) AS highest_infection,
	ROUND(MAX((total_cases::NUMERIC / population::NUMERIC) * 100), 3) AS percent_pop_infected
FROM covid19deaths
GROUP BY
	1,2
ORDER BY
	(CASE 
	 	WHEN MAX((total_cases::NUMERIC / population::NUMERIC) * 100) IS NULL THEN 1
	 	ELSE 0
	 END), percent_pop_infected DESC;
	 
--5. Top continent with Highest Death Count
-- Due to continent's data column incorrect, Null value in there while Location data are continent names.
-- We need to correct them to be able to show the highest death count of each continent
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
	 
--6. Top countries with Highest Death Count per Population
SELECT
	location,
	MAX(total_deaths) AS total_death_count
FROM covid19deaths
WHERE
	location NOT IN 
		('World', 'Europe', 'North America', 'European Union', 
		 'South America', 'Asia')
GROUP BY
	1
ORDER BY
	(CASE
		WHEN MAX(total_deaths) IS NULL THEN 1
	 	ELSE 0
	 END),
	 total_death_count DESC;
	
--7. Continents with the highest death count per population
SELECT
	continent,
	MAX(total_deaths) AS total_death_count
FROM covid19deaths
WHERE
	continent IS NOT NULL
GROUP BY
	1
ORDER BY
	2 DESC;

--8. Global numbers
SELECT
	date,
	SUM(new_cases) AS total_cases,
	SUM(new_deaths) AS total_deaths,
	(SUM(new_deaths::NUMERIC) / SUM(new_cases::NUMERIC) * 100) AS death_percentage
FROM covid19deaths
WHERE
	continent IS NOT NULL
GROUP BY
	date
ORDER BY
	1,2;

