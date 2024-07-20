Select *
From PortfolioProject..CovidDeaths
Where continent is not null
Order by 3,4

SELECT *
From PortfolioProject..CovidVaccinations
Order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Order by 1,2

Select location, date, total_cases,total_deaths, 
(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS Deathpercentage
from PortfolioProject..covidDeaths
where location like '%Malaysia%'
Order by 1,2


Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..covidDeaths
Group by location, population
order by PercentPopulationInfected desc


Select location, MAX(cast(Total_deaths as int)) as TotalDeathsCount
from PortfolioProject..covidDeaths
Where continent is not null
Group by location
order by TotalDeathsCount desc


Select continent, MAX(cast(Total_deaths as int)) as TotalDeathsCount
from PortfolioProject..covidDeaths
Where continent is not null
Group by continent
order by TotalDeathsCount desc


Select SUM(new_cases) as total_cases, SUM(cast(total_deaths as bigint)) as total_deaths, SUM(cast(new_deaths as bigint))/SUM(New_Cases)*100 as DeathPercentage
from PortfolioProject..covidDeaths
Where continent is not null
Order by 1,2





WITH PopVsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..covidDeaths dea
Join PortfolioProject..CovidVaccinations vac
  on dea.location = vac.location
  and dea.date = vac.date
  Where dea.continent is not null
  )
SELECT *, (RollingPeopleVaccinated/Population)*100
From PopVsVac



--DROP Table if exists #PercentPeopleVaccinated
Create Table #PercentPeopleVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPeopleVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..covidDeaths dea
Join PortfolioProject..CovidVaccinations vac
  on dea.location = vac.location
  and dea.date = vac.date
  Where dea.continent is not null


  SELECT *, (RollingPeopleVaccinated/Population)*100
From #PercentPeopleVaccinated



--Creating View to store data for later visualizations

Create View PercentPeopleVaccinated 
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..covidDeaths dea
Join PortfolioProject..CovidVaccinations vac
  on dea.location = vac.location
  and dea.date = vac.date
  Where dea.continent is not null
  )


  Select *
  From PercentPeopleVaccinated
