/* Import a csv.file into table in PostgreSQL database
 by creating a new table and defining data types 
 
 There are 2 tables 
    1. covid19deaths
    2. covid19vac

Do the same method for both tables
 */
CREATE TABLE covid19vac (

	iso_code VARCHAR (10),
	continent VARCHAR (25),
	location VARCHAR (50),
	date VARCHAR (25),
	new_tests INT,
	total_tests BIGINT,
	total_tests_per_thousand NUMERIC,
	new_tests_per_thousand NUMERIC,
	new_tests_smoothed NUMERIC,
	new_tests_smoothed_per_thousand NUMERIC,
	positive_rate NUMERIC,
	tests_per_case NUMERIC,
	tests_units VARCHAR(25),
	total_vaccinations INT,
	people_vaccinated INT,
	people_fully_vaccinated INT,
	new_vaccinations INT,
	new_vaccinations_smoothed INT,
	total_vaccinations_per_hundred NUMERIC,
	people_vaccinated_per_hundred NUMERIC,
	people_fully_vaccinated_per_hundred NUMERIC,
	new_vaccinations_smoothed_per_million INT,
	stringency_index NUMERIC,
	population_density NUMERIC,
	median_age NUMERIC,
	aged_65_older NUMERIC,
	aged_70_older NUMERIC,
	gdp_per_capita NUMERIC,
	extreme_poverty NUMERIC,
	cardiovasc_death_rate NUMERIC,
	diabetes_prevalence NUMERIC,
	female_smokers NUMERIC,
	male_smokers NUMERIC,
	handwashing_facilities NUMERIC,
	hospital_beds_per_thousand NUMERIC,
	life_expectancy NUMERIC(5,2),
	human_development_index NUMERIC (4,3)
	
);
