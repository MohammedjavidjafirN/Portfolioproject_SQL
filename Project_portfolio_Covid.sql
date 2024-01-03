--select *
--from portfolio_project..CovidDeaths
--order by 3,4


select * 
from portfolio_project..CovidVaccinations
order by 3,4


select location,date,total_cases,new_cases,total_deaths,population
from portfolio_project..CovidDeaths
order by 1,2

--Death percent
select location,date,total_cases, total_deaths, (total_deaths/total_cases) as Death_percent
from portfolio_project..CovidDeaths
where location='India'
order by 1,2


--Death percent on totalpop in india
select location,date,population, total_cases, (total_cases/population) as Death_percent
from portfolio_project..CovidDeaths
where location like '%India%'
order by 1,2

--max cases and population

select location,population  , max( total_cases) as max_cases,(max(total_cases)/cast (population as int)) * 100 as pecentage_case
from portfolio_project..CovidDeaths
group by location,population
--where location like '%India%'
order by 1 ,2 desc

--highest death in countries

select location,max(total_deaths) as Hightest_death
from portfolio_project..CovidDeaths
where continent is not null
group by location
order by 2 desc


--highest death in continent
select location ,max(total_deaths) as Hightest_death
from portfolio_project..CovidDeaths
where continent is null
group by location
order by 2 desc

--highest death in asia
select location,max(total_deaths) as Hightest_death
from portfolio_project..CovidDeaths
where continent ='Asia'
group by location
order by 2 desc


--Global exploration

select date,sum(new_cases) as total_cases,sum(new_deaths) as total_death ,sum(new_deaths)/sum(new_cases) * 100 as death_percent
from portfolio_project..CovidDeaths
where continent is not null
group by date
order by date

--Join both table

select * 
from portfolio_project..CovidVaccinations vac
join portfolio_project..CovidDeaths dea
   on vac.location=dea.location and vac.date=dea.date

--population vs vaccine

select dea.location,dea.date,dea.population,vac.new_vaccinations
from portfolio_project..CovidVaccinations vac
join portfolio_project..CovidDeaths dea
   on vac.location=dea.location and vac.date=dea.date
where dea.continent is not null
order by 1,3

--Roll over method
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations
from portfolio_project..CovidVaccinations vac
join portfolio_project..CovidDeaths dea
   on vac.location=dea.location and vac.date=dea.date
where dea.continent is not null
order by 1,2,3

--Vaccine per day by each country on total pop
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations, sum (convert(int,vac.new_vaccinations)) 
over(partition by vac.location order by dea.date)
from portfolio_project..CovidVaccinations vac
join portfolio_project..CovidDeaths dea
   on vac.location=dea.location and vac.date=dea.date
where dea.continent is not null
order by 2,3

--cte exp 

with rollvac (continent,location,date,population,new_vaccine ,rolling_vac )
as
(
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations, sum (convert(int,vac.new_vaccinations)) 
over(partition by vac.location order by dea.date) as rolling_vac
from portfolio_project..CovidVaccinations vac
join portfolio_project..CovidDeaths dea
   on vac.location=dea.location and vac.date=dea.date
where dea.continent is not null)

select *,( rolling_vac / population)* 100 as percent_vac
from rollvac


--create tempteable
drop table if exists #percent_vac
create table #percent_vac
( continent varchar(255),location varchar(255),date date,population numeric,vaccine numeric,rolling_vac numeric)


insert into #percent_vac
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations, sum (convert(int,vac.new_vaccinations)) 
over(partition by vac.location order by dea.date) as rolling_vac
from portfolio_project..CovidVaccinations vac
join portfolio_project..CovidDeaths dea
   on vac.location=dea.location and vac.date=dea.date


   select *,(rolling_vac/population) * 100 as percent_vac
   from #percent_vac


-- create view

create view rollover_vaccine as 
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations, sum (convert(int,vac.new_vaccinations)) 
over(partition by vac.location order by dea.date) as rolling_vac
from portfolio_project..CovidVaccinations vac
join portfolio_project..CovidDeaths dea
   on vac.location=dea.location and vac.date=dea.date
where dea.continent is not null
