--DROP PROCEDURE IF EXISTS DeathRatePerCountry
--DROP TABLE IF EXISTS #TempDP
CREATE PROCEDURE DeathRatePerCountry
AS	
CREATE TABLE #TempDP
(
location varchar(100),
total_deaths int,
total_cases int,
death_percentage float)

INSERT INTO #TempDP 
SELECT location, SUM(new_deaths), SUM(new_cases)
, (SUM(new_deaths)/NULLIF(SUM(new_cases),0)) * 100.0 AS DeathPercentage
FROM PortfolioProject..CovidDeathsReal
WHERE continent is not null
GROUP BY location

SELECT *
FROM #TempDP 
ORDER BY 1

--Command to execute
--EXEC DeathRatePerCountry