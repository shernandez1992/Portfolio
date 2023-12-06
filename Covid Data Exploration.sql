/*
Covid 19 Data Exploration

Skills used: Joins, CTE's, Window Functions, 
Aggregate Functions, Creating Views, Converting Data Types

*/

--Select data we will be starting with

SELECT 
	location, 
	date, 
	total_cases, 
	new_cases, 
	total_deaths, 
	population
FROM deaths_covid
WHERE continent IS NOT null
ORDER BY 1,2;

--Looking at Total Cases VS Total Deaths
--Shows Liklihood of dying of Covid (%) in your country

SELECT 
	location, 
	date, 
	total_cases, 
	total_deaths, 
	(total_deaths/total_cases::float)*100 AS DeathPercentage
FROM deaths_covid
WHERE location like '%States%'
ORDER BY 1,2;

--Looking at Total Cases vs Population
--Shows what percentage of population got Covid

SELECT 
	location, 
	date,
	Population,
	total_cases, 
	(total_cases/population::float)*100 AS PercentPopInfected
FROM deaths_covid
ORDER BY 1,2

--Looking at Countries with highest infection rate compared to population

SELECT 
	location, 
	Population,
	MAX(total_cases) AS HighestInfectionCount, 
	MAX((total_cases/population::float))*100 AS percentpopinfected
FROM deaths_covid
GROUP BY location, population
ORDER BY PercentPopInfected DESC NULLS LAST;

--Showing Countries with Highest Death Count per Population

SELECT 
	location, 
	MAX(Total_deaths) AS Total_Death_Count
FROM deaths_covid
WHERE continent IS NOT null
GROUP BY location
ORDER BY Total_Death_Count desc NULLS LAST;

--BREAKING THINGS DOWN BY CONTINENT

--Showing continents with highest death per population


SELECT 
	continent, 
	MAX(Total_deaths) AS Total_Death_Count
FROM deaths_covid
WHERE continent IS NOT null
GROUP BY continent
ORDER BY Total_Death_Count desc NULLS LAST;

--Global Numbers

SELECT 
	SUM(new_cases) AS total_cases,
	SUM(new_deaths) AS total_deaths,
	NULLIF(SUM(new_deaths),0)/NULLIF(SUM(new_cases),0)*100 AS death_percentage
FROM deaths_covid
WHERE continent IS NOT null
ORDER BY 1,2;

--Looking at Total Population vs Vaccinations

SELECT 
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(new_vaccinations) OVER 
		(PARTITION BY dea.location ORDER BY dea.location, 
		 dea.date) AS rolling_vaccinations
FROM deaths_covid AS dea
JOIN vaccines AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT null
ORDER BY 2,3

--Using CTE to perform Calculation on Partition By in previous query

WITH PopVsVac 
(continent, location, date, population, new_vaccinations, rolling_vaccinations)
AS (
	SELECT 
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(new_vaccinations) OVER 
		(PARTITION BY dea.location ORDER BY dea.location, 
		 dea.date) AS rolling_vaccinations
FROM deaths_covid AS dea
JOIN vaccines AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT null
)
Select *, 
	(rolling_vaccinations/population::float)*100
FROM PopVsVac

--Creating View to Store data for later visualizations

CREATE VIEW PercentPopulationVaccicated AS
SELECT 
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(new_vaccinations) OVER 
		(PARTITION BY dea.location ORDER BY dea.location, 
		 dea.date) AS rolling_vaccinations
FROM deaths_covid AS dea
JOIN vaccines AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT null
ORDER BY 2,3