select * from covid_deathss order by 4

select location,date,total_cases,new_cases,total_deaths,population_density from covid_deathss order by 1,2

ALTER TABLE covid_deathss ALTER COLUMN total_deaths FLOAT
ALTER TABLE covid_deathss ALTER COLUMN total_cases FLOAT
ALTER TABLE covid_deathss ALTER COLUMN population_density FLOAT

select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from covid_deathss
WHERE location like '%states%'
order by 1,2

select location,date,total_cases,population_density, (total_cases/population_density)*100 as ContaminatePercentage
from covid_deathss
WHERE location like '%states%'
order by 1,2

select location,MAX(total_cases) as highest_cases,population_density, MAX(total_cases/population_density) as MaxContaminatePercentage
from covid_deathss
--WHERE location like '%states%'
group by location,population_density
order by MaxContaminatePercentage desc

select continent,MAX(total_deaths) as highest_death
from covid_deathss
WHERE continent is not null 
group by continent
order by highest_death desc

select date,SUM(total_cases), SUM(cast(new_deaths as float))
from covid_deathss
--WHERE location like '%states%'
WHERE continent is not null
group by date
order by 1,2

select dea.continent, dea.location, dea.date,dea.population_density,vac.new_vaccinations, SUM(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location,dea.date) as rolling
from covid_deathss dea
join covid_vaccination vac
on dea.location=vac.location 
and dea.date=vac.date
where dea.continent is not null
order by 1,2,3

create view percentepopulation as
select dea.continent, dea.location, dea.date,dea.population_density,vac.new_vaccinations, SUM(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location,dea.date) as rolling
from covid_deathss dea
join covid_vaccination vac
on dea.location=vac.location 
and dea.date=vac.date
where dea.continent is not null
--order by 1,2,3