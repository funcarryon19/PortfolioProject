-------------------------------------------------------------------------
/* 
5. Create a view to store data for later visualizations
*/
--5.1 Total % of population vs vaccinations day by day
CREATE VIEW perpopvsvac AS (
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

--5.2 Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country
CREATE VIEW total_case_vs_total_deaths AS (
	SELECT
		location,
		date,
		total_cases,
		total_deaths,
		((total_deaths::NUMERIC / total_cases::NUMERIC) * 100) AS death_rate
	FROM covid19deaths
	WHERE
		location = 'Thailand'
);

--5.3 Total Cases vs Population
-- Show what percentage of population got Covid19
CREATE VIEW total_cases_vs_population AS (
	SELECT
		location,
		date,
		population,
		total_cases,
		((total_cases::NUMERIC / population::NUMERIC) * 100) AS infect_rate
	FROM covid19deaths
	WHERE
		location = 'Thailand'
);

--5.4 Top countries with Highest Infection Rate compared to Population
CREATE VIEW top_infect_rate_countries AS (
	SELECT
		location,
		population,
		MAX(total_cases) AS highest_infection,
		ROUND(MAX((total_cases::NUMERIC / population::NUMERIC) * 100), 3) AS percent_pop_infected
	FROM covid19deaths
	GROUP BY
		1,2
);

--5.5 Top countries with Highest Death Count per Population
CREATE VIEW top_death_count_per_pop AS (
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
);

--5.6 Continents with the highest death count per population
CREATE VIEW top_cont_death_per_pop AS (
	SELECT
		continent,
		MAX(total_deaths) AS total_death_count
	FROM covid19deaths
	WHERE
		continent IS NOT NULL
	GROUP BY
		1
);

--5.7 Global numbers
CREATE VIEW glob_total_cases AS (
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
);

