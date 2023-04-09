--DROP PROCEDURE IF EXISTS CountryDeaths
CREATE PROCEDURE CountryDeaths
@location varchar(100)
AS
CREATE TABLE #Temp(
location nvarchar(100),
CountryDeaths int,
CountryCases int)

INSERT INTO #Temp
SELECT location, MAX(cast(total_deaths as int)) AS TotalDeaths, MAX(cast(total_cases as int)) AS TotalCases
FROM PortfolioProject..CovidDeathsReal
WHERE location = @location
GROUP BY location 

SELECT *
FROM #Temp

--Syntax for selecting a country
--EXEC CountryDeaths @location = 'Country_Name'
