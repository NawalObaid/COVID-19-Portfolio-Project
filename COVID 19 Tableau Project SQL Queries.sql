/*

Queries used for the COVID 19 Tableau Project

*/

----#1
--(GLOBAL NUMBERS) of deaths since day 1 of the pandemic
Select sum(new_cases) as Total_cases, sum(cast(new_deaths as int)) as Total_death, sum(cast(new_deaths as int))/sum(new_cases)*100 as Death_Percentage
From PortfolioProject..CovidDeaths
where continent is not Null
order by 1,2

----#2
--(GLOBAL NUMBERS) total number of deaths per cotinent
Select location, sum(cast(new_deaths as int)) as TotalDeathsCount
From PortfolioProject..CovidDeaths
where continent is Null
and location not in ('World', 'European Union', 'International', 'Upper middle income',
'Upper middle income','Upper middle income','High income','Lower middle income','Low income')
Group by location
order by TotalDeathsCount desc

----#3
--Percentage of Infected Population Per Country
Select location, population, max(total_cases)as Highest_Infection_Count, max((total_cases/population)*100) as Percent_Population_Infected
From PortfolioProject..CovidDeaths
where continent is not Null
Group by location, population
Order by Percent_Population_Infected desc

----#4
--Percentage of Infected Population
Select location, population,date, max(total_cases)as Highest_Infection_Count, max((total_cases/population)*100) as Percent_Population_Infected
From PortfolioProject..CovidDeaths
Group by location, population, date
Order by Percent_Population_Infected desc

