--Showing the population infection rate

SELECT location, population, MAX(cast(total_cases as int)), (MAX(cast(total_cases as int))/population)*100 AS PopulationInfectionRate
FROM PortfolioProject..CovidDeathsReal
GROUP BY location, population
ORDER BY 4 desc

--Showing the population death rate

SELECT location, population, MAX(cast(total_deaths as int)) as total_deaths, (MAX(cast(total_deaths as int)/population)) as DeathRate 
FROM PortfolioProject..CovidDeathsReal
GROUP BY population, location
ORDER BY 4 desc

--Showing the total death count per continent 

SELECT continent, (SUM(new_deaths)) AS TotalDeathCount
FROM PortfolioProject..CovidDeathsReal
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc

--Showing the total death count worldwide

SELECT MAX(cast(total_deaths as int)) AS TotalDeathCountGlobal
FROM PortfolioProject..CovidDeathsReal

--Showing the total death rate worldwide

SELECT MAX(cast(total_deaths as int)) AS GlobalTotalDeaths, MAX(cast(total_cases as int)) AS TotalCases, SUM(new_deaths)/SUM(new_cases)*100 AS GlobalDeathRate
FROM PortfolioProject..CovidDeathsReal

--Showing the new vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM PortfolioProject..CovidDeathsReal dea
JOIN PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3

--Showing the new vaccination rate per location

WITH cte (continent, location, date, population, new_vaccinations, RollingCountNewVaccinations)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingCountNewVaccinations
FROM PortfolioProject..CovidDeathsReal dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null 
)
SELECT *, (RollingCountNewVaccinations/population)*100 as VaccinationRate  
FROM cte

--DROP VIEW IF EXISTS NewVacPerPop
--CREATE VIEW cte as 
--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingCountNewVaccinations
--FROM PortfolioProject..CovidDeathsReal dea
--JOIN PortfolioProject..CovidVaccinations vac
--	ON dea.location = vac.location
--	AND dea.date = vac.date
--WHERE dea.continent is not null 

--CREATE VIEW TotalDeaths as
--SELECT MAX(cast(total_deaths as int)) AS TotalDeathCountGlobal
--FROM PortfolioProject..CovidDeathsReal

