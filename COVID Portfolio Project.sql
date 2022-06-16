Select * 
From PortfolioProject..CovidDeaths
where continent is not Null
order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
where continent is not Null
order by 1,2

--Shows the likelihood of dying if a person contracts covid in the US
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
From PortfolioProject..CovidDeaths
Where location like '%states%'
and continent is not Null
order by 1,2

--Total cases vs population got covid
Select location, date, population, total_cases, (total_cases/population)*100 as Percent_Population_Infected
From PortfolioProject..CovidDeaths
Where location like '%States%'
and continent is not Null
order by 1,2

--Countries with highest Infection rate compared to population
Select location, population, max(total_cases)as Highest_Infection_Count, max((total_cases/population)*100) as Percent_Population_Infected
From PortfolioProject..CovidDeaths
where continent is not Null
Group by location, population
Order by Percent_Population_Infected desc

--Showing countries with highest death count per population
Select location, max(cast(total_deaths as int)) as Highest_Deaths_Count
From PortfolioProject..CovidDeaths
where continent is not Null
Group by location
Order by Highest_Deaths_Count desc

--Showing continents with highest death count per population
Select continent, max(cast(total_deaths as int)) as Highest_Deaths_Count
From PortfolioProject..CovidDeaths
where continent is not Null
Group by continent
Order by Highest_Deaths_Count desc

--(GLOBAL NUMBERS) of deaths day by day
Select date, sum(new_cases) as Total_cases, sum(cast(new_deaths as int)) as Total_death, sum(cast(new_deaths as int))/sum(new_cases)*100 as Death_Percentage
From PortfolioProject..CovidDeaths
where continent is not Null
Group by date
order by 1,2

--(GLOBAL NUMBERS) of deaths since day 1 of the pandemic
Select sum(new_cases) as Total_cases, sum(cast(new_deaths as int)) as Total_death, sum(cast(new_deaths as int))/sum(new_cases)*100 as Death_Percentage
From PortfolioProject..CovidDeaths
where continent is not Null
order by 1,2

--Looking at total population vs. vaccinations
--Total number of people in the world who have been vaccinated
Select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
    on dea.location = vac.location
	and dea.date =vac.date
where dea.continent is not Null
order by 2,3

--Total number of people in the world who have been vaccinated
--Adding rolling count feature
Select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,
dea.date) as VaccinatedPeople_Rolling_count
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
    on dea.location = vac.location
	and dea.date =vac.date
where dea.continent is not Null
order by 2,3

--What is the percentage of vaccinated people in each country
---------------Using CTE----------------
With PopulationVsVaccinations (continent,location, date, population, new_vaccinations, VaccinatedPeople_Rolling_count)
as
(
Select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,
dea.date) as VaccinatedPeople_Rolling_count
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
    on dea.location = vac.location
	and dea.date =vac.date
where dea.continent is not Null
)
Select *, (VaccinatedPeople_Rolling_count/population)* 100 as VaccinatedPeoplePercentage
from PopulationVsVaccinations


--What is the percentage of vaccinated people in each country
---------------Using TEMP TABLE----------------
Drop Table if exists #PercentageVaccinatedPeople
Create Table #PercentageVaccinatedPeople
(
Continent nvarchar(255),
location nvarchar(255), 
date datetime,
population numeric,
new_vaccinations numeric,
VaccinatedPeople_Rolling_count numeric
)
Insert into #PercentageVaccinatedPeople

Select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,
dea.date) as VaccinatedPeople_Rolling_count
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
    on dea.location = vac.location
	and dea.date =vac.date
where dea.continent is not Null

Select *, (VaccinatedPeople_Rolling_count/population)* 100 as VaccinatedPeoplePercentage
from #PercentageVaccinatedPeople

--Creating a View to store data for later visualizations
Create View PercentageVaccinatedPeopleView as
Select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,
dea.date) as VaccinatedPeople_Rolling_count
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
    on dea.location = vac.location
	and dea.date =vac.date
where dea.continent is not Null

