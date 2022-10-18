/* 

Queries used for Tableau Project

*/

---------------------------------------------------------------------------------------------------------


-- 1. 

SELECT
	SUM(new_cases) AS total_cases, 
	SUM(CAST(new_deaths AS INT)) AS total_deaths, 
	SUM(CAST(new_deaths AS INT))/SUM(New_Cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
--WHERE location LIKE '%Canada%'
WHERE continent IS NOT NULL 
--GROUP BY date
ORDER BY 1,2


---------------------------------------------------------------------------------------------------------


-- Just a double check based off the data provided
-- numbers are extremely close so we will keep them - The Second includes "International"  Location

/*

Select 
	SUM(new_cases) as total_cases, 
	SUM(cast(new_deaths as int)) as total_deaths, 
	SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location like '%states%' AND location like 'World'
GROUP BY date
ORDER BY 1,2

*/


---------------------------------------------------------------------------------------------------------


-- 2. 

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

SELECT 
	location, 
	SUM(CAST(new_deaths AS INT)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
--Where location like '%states%'
WHERE 
	continent IS NULL 
	AND location NOT IN ('World', 'European Union', 'International')
GROUP BY location
ORDER BY TotalDeathCount DESC


---------------------------------------------------------------------------------------------------------


-- 3.

SELECT 
	Location, 
	Population, 
	MAX(total_cases) AS HighestInfectionCount,  
	MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
--Where location like '%states%'
GROUP BY 
	Location, 
	Population
ORDER BY PercentPopulationInfected DESC


---------------------------------------------------------------------------------------------------------


-- 4.

SELECT 
	location, 
	population,
	date, 
	MAX(total_cases) AS HighestInfectionCount,  
	MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
--Where location like '%states%'
GROUP BY 
	Location, 
	Population, 
	date
ORDER BY PercentPopulationInfected DESC


---------------------------------------------------------------------------------------------------------
