select *
from Covidvaccinationss

select *
from CovidDeaths

select date,location,total_deaths,total_cases,
(cast (total_deaths as decimal) / cast(total_cases as decimal))*100 as percentageofdeaths
from CovidDeaths
where continent is not null

select date,location,population,total_cases,
(total_cases/ population)*100 as percentageofcases
from CovidDeaths
where continent is not null

select location, population, max(total_cases) as highestinfectioncount,
max((total_cases / population))*100 as percentpopulationinfection
from CovidDeaths
where continent is not null
group by location ,population
order by percentpopulationinfection desc

select location,  max(cast(total_deaths as int)) as deathscount
from CovidDeaths
where continent is not null
group by location 
order by deathscount desc

select location,  max(cast(total_deaths as int)) as deathscount
from CovidDeaths
where continent is null
group by location 
order by deathscount desc

select continent,sum(new_cases)as totalcases, sum(new_deaths)as totaldeaths, 
(sum(new_deaths)/sum(new_cases))*100 as deathpercentage
from CovidDeaths
where continent is not null
group by continent

select dea.location, dea.date,dea.population, vac.new_vaccinations 
from CovidDeaths as dea join Covidvaccinations as vac on 
dea.location=vac.location and dea.date=vac.date
where dea.continent is not null and vac.new_vaccinations is not null
order by 1,2

select dea.location,sum(cast(vac.new_vaccinations as float))as totalvaccinations
from CovidDeaths as dea join Covidvaccinations as vac on 
dea.location=vac.location and dea.date=vac.date
where dea.continent is not null 
group by dea.location


--cte
with vacs (date,location,population,new_vaccinations,totalvaccinations)
as
(
select dea.date,dea.location,dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as float))
over(partition by dea.location order by dea.location,dea.date)as totalvaccinations 
from CovidDeaths as dea join Covidvaccinations as vac on 
dea.location=vac.location and dea.date=vac.date
where dea.continent is not null 
)
select *,(totalvaccinations/population)*100 as percentpopvacc
from vacs



--temp table
drop table if exists #vaccs
create table #vaccs(
date datetime,
location nvarchar(255),
population numeric,
new_vaccinations numeric,
totalvaccinations numeric,
)
insert into #vaccs
select dea.date,dea.location,dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as float))
over(partition by dea.location order by dea.location,dea.date)as totalvaccinations 
from CovidDeaths as dea join Covidvaccinations as vac on 
dea.location=vac.location and dea.date=vac.date
where dea.continent is not null 

select *,(totalvaccinations/population)*100 as percentpopvacc
from #vaccs

create view deathspercent as
select date,location,total_deaths,total_cases,(cast (total_deaths as decimal) / cast(total_cases as decimal))*100 as percentageofdeaths
from CovidDeaths
where continent is not null


create view casespercent as
select date,location,population,total_cases,
(total_cases/ population)*100 as percentageofcases
from CovidDeaths
where continent is not null


create view casestopoppercent as
select location, population, max(total_cases) as highestinfectioncount,
max((total_cases / population))*100 as percentpopulationinfection
from CovidDeaths
where continent is not null
group by location ,population


create view totaldeathspercontinent as
select location,  max(cast(total_deaths as int)) as deathscount
from CovidDeaths
where continent is null
group by location 

create view totaldeathsperlocation as
select location,  max(cast(total_deaths as int)) as deathscount
from CovidDeaths
where continent is not null
group by location 


create view totalvaccinations as
select dea.location,sum(cast(vac.new_vaccinations as float))as totalvaccinations
from CovidDeaths as dea join Covidvaccinations as vac on 
dea.location=vac.location and dea.date=vac.date
where dea.continent is not null 
group by dea.location

create view totalvaccs as
select dea.date,dea.location,dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as float))
over(partition by dea.location order by dea.location,dea.date)as totalvaccinations 
from CovidDeaths as dea join Covidvaccinations as vac on 
dea.location=vac.location and dea.date=vac.date
where dea.continent is not null 

select*
from totalvaccs


