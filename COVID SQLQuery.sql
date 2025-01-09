use covidproject

SELECT *FROM CovidDeaths
SELECT *FROM CovidVaccinations

--- 1. SELECT DATA THAT WE ARE GOING TO USE ---

SELECT Location,date,total_cases,new_cases,total_deaths,population
from CovidDeaths
order by 1,2

--- 2. TOTAL CASES VS TOTAL DEATHS ---

SELECT Location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathpercentage 
from CovidDeaths
order by 1,2

--- 3. DEATH PERCENTAGE OF PARTICULAR LOCATION ---

-- A.For LOCATION Which Has STATES In Its Name --

SELECT Location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathpercentage 
from CovidDeaths
WHERE Location like '%states%'
order by 1,2

-- B.For LOCATION Which Starts With A --

SELECT Location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathpercentage 
from CovidDeaths
WHERE Location like 'A%'
order by 1,2

-- C.For LOCATION Is INDIA --

SELECT Location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathpercentage 
from CovidDeaths
WHERE Location like 'INDIA'
order by 1,2


--- 4. TOTAL CASES VS POPULATION ---

SELECT Location,date,total_cases,Population,(total_cases/population)*100 as deathpercentage 
from CovidDeaths
order by 1,2

-- A.For LOCATION Which Has STATES In Its Name --

SELECT Location,date,total_cases,population,(total_cases/population)*100 as deathpercentage 
from CovidDeaths
WHERE Location like '%states%'
order by 1,2


--- 5. COUNTRIES WITH HIGHEST INFECTION RATE COMPARED TO POPULATION ---

SELECT Location,population,max(total_cases) as highestinfectioncount,max(total_cases/population)*100 as percentagepopinfected 
from CovidDeaths
group by Location,population
order by percentagepopinfected desc


--- 6. CONTRIES WITH HIGHEST DEATH COUNT PER POPULATION ---

SELECT Location,max(total_deaths) as totaldeathcount
from CovidDeaths
group by location
order by totaldeathcount desc

-- a. To cast into integer value --

SELECT Location,max(cast(total_deaths as int)) as totaldeathcount
from CovidDeaths
where continent is not NULL
group by location
order by totaldeathcount desc

-- b. DATA ON BASES OF CONTINENT --

SELECT continent,max(cast(total_deaths as int)) as totaldeathcount
from CovidDeaths
where continent is not NULL
group by continent
order by totaldeathcount desc


--- 7. GLOBAL NUMBERS ---

SELECT date, sum(new_cases)as totalcases,sum(cast(new_deaths as int)) as totaldeaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage
from CovidDeaths
where continent is not NULL
GROUP BY DATE
order by 1,2

-- a. DEATHPERCENTAGE OF WORLD --

SELECT sum(new_cases)as totalcases,sum(cast(new_deaths as int)) as totaldeaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage
from CovidDeaths
where continent is not NULL
order by 1,2


--- 8. JOINING DIFFERENT DATASETS OF COVIDDEATHS AND COVIDVACCINATIONS ---

SELECT *FROM CovidDeaths dea 
join CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date


--- 9. TOTAL POPULATION VS VACCINATION ---

SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations from CovidDeaths dea 
join CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3

-- a. To SHOW Increase In VACCINATED DATA Day BY Day --

SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,
dea.date) as rollingpeoplevaccinated
from CovidDeaths dea 
join CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3


--- 10. USE CTE ---

with PopvsVac(continent,location,date,population,new_vaccinations,rollingpeoplevaccinated)
as
(
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,
dea.date) as rollingpeoplevaccinated
from CovidDeaths dea 
join CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
)
SELECT *,(Rollingpeoplevaccinated/population)*100 as percentagevaccinated from PopvsVac

 
--- THIS IS THE SQL DATA EXPLORATION PROECT OF COVID DATASET ---