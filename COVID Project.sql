-- Project by Yakubu Andrew

Select *
From MyPortfolio.dbo.CovidDeaths
Where continent is not null
Order by 3,4

--Select the datat to use

Select Location, date, total_cases, new_cases, total_deaths, population
From MyPortfolio.dbo.CovidDeaths
Order by 1,2

-- Total Cases vs Total Deaths (probability of dying if infected)

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as PercentageDeath
From MyPortfolio.dbo.CovidDeaths
Where Location = 'Nigeria'
Order by 1,2


-- Total cases vs Population(Percentage of population that got covid)
Select Location, date, total_cases, population, (total_cases/population)*100 as PercentagePopulation
From MyPortfolio.dbo.CovidDeaths
--Where Location = 'Nigeria'
Order by 1,2

-- Countries with highest infection rate compared to population

Select Location, population, Max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentagePopulationInfected
From MyPortfolio.dbo.CovidDeaths
--Where Location = 'Nigeria'
Group by Location, Population
Order by PercentagePopulationInfected desc

-- Countries with highest death count per population

Select Location, Max(total_deaths) as TotalDeathCount
From MyPortfolio.dbo.CovidDeaths
--Where Location = 'Nigeria'
Group by Location
Order by TotalDeathCount desc

--cont..


Select Location, Max(Cast(total_deaths as int)) as TotalDeathCount
From MyPortfolio.dbo.CovidDeaths
--Where Location = 'Nigeria
Where continent is not null
Group by Location
Order by TotalDeathCount desc

-- Selecting by continent

Select Continent, Max(Cast(total_deaths as int)) as TotalDeathCount
From MyPortfolio.dbo.CovidDeaths
--Where Location = 'Nigeria
Where continent is not null
Group by Continent
Order by TotalDeathCount desc

--Global Numbers

Select date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
From MyPortfolio.dbo.CovidDeaths
Where continent is not null
Order by 1,2

select  Sum(new_cases) as total_cases, Sum(cast(new_deaths as int)) as total_deaths, Sum(cast(new_deaths as int))/Sum(new_cases)*100 as DeathPercentage
From MyPortfolio.dbo.CovidDeaths
Where continent is not null
--Group by date
Order by 1,2


Select *
From MyPortfolio.dbo.CovidVaccinations
Where continent is not null
Order by 3,4

--Total Population vs Vaccinations

Select Dea.continent, Dea.Location, Dea.date, Dea.population, Vac.new_vaccinations
From MyPortfolio.dbo.CovidDeaths Dea
Join MyPortfolio.dbo.CovidVaccinations Vac
  On Dea.Location = Vac.Location
  and Dea.date = Vac.date
  Where Dea.continent is not null
  Order by 1,2


  Select Dea.continent, Dea.Location, Dea.date, Dea.population, Vac.new_vaccinations,
  Sum(Cast(Vac.new_vaccinations as int)) OVER (Partition by Dea.Location)
From MyPortfolio.dbo.CovidDeaths Dea
Join MyPortfolio.dbo.CovidVaccinations Vac
  On Dea.Location = Vac.Location
  and Dea.date = Vac.date
  Where Dea.continent is not null
  Order by 1,2

  
  Select Dea.continent, Dea.Location, Dea.date, Dea.population, Vac.new_vaccinations,
  Sum(Convert(int,Vac.new_vaccinations)) OVER (Partition by Dea.Location order by Dea.location, Dea.date)
  As RollingPeopleVaccinated
From MyPortfolio.dbo.CovidDeaths Dea
Join MyPortfolio.dbo.CovidVaccinations Vac
  On Dea.Location = Vac.Location
  and Dea.date = Vac.date
  Where Dea.continent is not null
  Order by 1,2


With PopvsVac (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
as
(
  Select Dea.continent, Dea.Location, Dea.date, Dea.population, Vac.new_vaccinations,
  Sum(Convert(int,Vac.new_vaccinations)) OVER (Partition by Dea.Location order by Dea.location, Dea.date)
  As RollingPeopleVaccinated
From MyPortfolio.dbo.CovidDeaths Dea
Join MyPortfolio.dbo.CovidVaccinations Vac
  On Dea.Location = Vac.Location
  and Dea.date = Vac.date
  Where Dea.continent is not null
  --Order by 1,2
)
Select*, (RollingPeopleVaccinated/Population)*100
From PopvsVac


-- TEMP TABLE
Create Table #PercentPopulationVaccinated
( 
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)


Insert into  #PercentPopulationVaccinated

 Select Dea.continent, Dea.Location, Dea.date, Dea.population, Vac.new_vaccinations,
  Sum(Convert(int,Vac.new_vaccinations)) OVER (Partition by Dea.Location order by Dea.location, Dea.date)
  As RollingPeopleVaccinated
From MyPortfolio.dbo.CovidDeaths Dea
Join MyPortfolio.dbo.CovidVaccinations Vac
  On Dea.Location = Vac.Location
  and Dea.date = Vac.date
  Where Dea.continent is not null
  order by 2,3
  Select*, (RollingPeopleVaccinated/Population)*100
From  #PercentPopulationVaccinated


--Creating view to store data for later visualization

Create view PercentPopulationVaccinated as

 Select Dea.continent, Dea.Location, Dea.date, Dea.population, Vac.new_vaccinations,
  Sum(Convert(int,Vac.new_vaccinations)) OVER (Partition by Dea.Location order by Dea.location, Dea.date)
  As RollingPeopleVaccinated
From MyPortfolio.dbo.CovidDeaths Dea
Join MyPortfolio.dbo.CovidVaccinations Vac
  On Dea.Location = Vac.Location
  and Dea.date = Vac.date
  Where Dea.continent is not null
  --order by 2,3