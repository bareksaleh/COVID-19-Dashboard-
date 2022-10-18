SELECT * 
FROM PortfolioProject.dbo.CovidDeaths
--WHERE continent is not null
ORDER BY 3,4

/*
--disregard, not in use
SELECT *
FROM PortfolioProject..CovidVaccinations
ORDER BY 3,4 

*/

---------------------------------------------------------------------------------------------------------


-- Select Data that we are going to be using 
SELECT 
	location, 
	date, 
	total_cases, 
	new_cases, 
	total_deaths, 
	population
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2


---------------------------------------------------------------------------------------------------------


-- Looking at the Total Cases vs Total Deaths 
	-- shows the likelihood of dying if you contract COVID in your country
SELECT 
	location, 
	date, 
	total_cases, 
	total_deaths,
	(total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location like '%Canada%'
ORDER BY 1,2


---------------------------------------------------------------------------------------------------------


-- Looking at the Total Cases vs Population  
	-- shows the percentage of population who contracted COVID in your country
SELECT 
	location, 
	date, 
	total_cases, 
	total_deaths,
	(total_cases/population)*100 as ContractionRate
FROM PortfolioProject..CovidDeaths
--WHERE location like '%Canada%'
ORDER BY 1,2


---------------------------------------------------------------------------------------------------------


--Looking at Countries with highest infection rate compared to population 
SELECT 
	location,
	population,
	MAX(total_cases) as HighestInfectionCount, 
	MAX((total_cases/population)*100) as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
--Where location like '%canada%'
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC


---------------------------------------------------------------------------------------------------------


-- Showing the countries with the highest death count per population 
SELECT 
	location,
	MAX(CAST(Total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
--Where location like '%canada%'
WHERE continent is not null
GROUP BY Location
ORDER BY TotalDeathCount DESC


---------------------------------------------------------------------------------------------------------


-- LETS BREAK THINGS DOWN BY CONTINENT 

-- Showing continents with the highest death count per population
SELECT 
	continent,
	MAX(CAST(Total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
--Where location like '%canada%'
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC


------------------------------


-- GLOBAL NUMBERS 
SELECT   
	SUM(new_cases) as total_cases, 
	SUM(CAST(new_deaths as int)) as total_deaths,
	SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
--WHERE location like '%Canada%'
WHERE continent is not null 
GROUP BY date 
ORDER BY 1,2

SELECT   
	SUM(new_cases) as total_cases, 
	SUM(CAST(new_deaths as int)) as total_deaths,
	SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
--WHERE location like '%Canada%'
WHERE continent is not null 
--GROUP BY date 
ORDER BY 1,2


------------------------------


-- Looking at Total Population vs Vaccinations 

SELECT 
	dea.continent,
	dea.location,
	dea.date, 
	dea.population,
	vac.new_vaccinations,
	SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER (PARTITION BY dea.location) AS rolling_ppl_vaccinated
	-- can alternatively use SUM(CONVERT(BIGINT,vac.new_vaccinations)) OVER (PARTITION BY dea.location) AS rolling_ppl_vaccinated
FROM PortfolioProject.dbo.CovidDeaths dea
JOIN PortfolioProject.dbo.CovidVaccinations vac
	ON dea.location = vac.location 
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3