/* SQL Zoo Questions */

-- From WORLD Tutorial ---

/* 1. One or the other (but not both)
Exclusive OR (XOR). Show the countries that are big by area (more than 3 million) or big by population (more than 250 million) but not both. Show name, population and area.

Australia has a big area but a small population, it should be included.
Indonesia has a big population but a small area, it should be included.
China has a big population and big area, it should be excluded.
United Kingdom has a small population and a small area, it should be excluded. */

select name, population , area
from world
where (area > 3000000) XOR (population > 250000000);

/* 2. Show the name and population in millions and the GDP in billions for the countries of the continent 'South America'. Use the ROUND function to show the values to two decimal places.

For South America show population in millions and GDP in billions both to 2 decimal places.
Millions and billions */

select name , round((population/1000000),2), round((gdp/1000000000),2)
from world
where continent =  'South America'


/* 3.Show the name and per-capita GDP for those countries with a GDP of at least one trillion (1000000000000; that is 12 zeros). Round this value to the nearest 1000.

Show per-capita GDP for the trillion dollar countries to the nearest $1000. */

select name, round((gdp/population),-3)
from world
where gdp >= 1000000000000;

/* 4. The capital of Sweden is Stockholm. Both words start with the letter 'S'.

Show the name and the capital where the first letters of each match. Don't include countries where the name and the capital are the same word. */

SELECT name, capital
FROM world
where LEFT(name,1) = left(capital,1)
and name <> capital;

/* 5. Equatorial Guinea and Dominican Republic have all of the vowels (a e i o u) in the name. They don't count because they have more than one word in the name.

Find the country that has all the vowels and no spaces in its name. */

SELECT name
   FROM world
WHERE (name LIKE '%a%') and (name LIKE '%e%') and (name LIKE '%i%') and (name LIKE '%o%') and (name LIKE '%u%')
  AND name NOT LIKE '% %';
  
-- From Nobel Tutorial  
  
/* 6. Show the 1984 winners and subject ordered by subject and winner name; but list Chemistry and Physics last. */

SELECT winner, subject
FROM nobel
WHERE yr=1984
ORDER BY 
case 
when subject IN ('Physics','Chemistry') then 1 else 0 
end, 
subject, winner;

-- From Select within Select Tutorial

/* 7. Show the countries in Europe with a per capita GDP greater than 'United Kingdom'. */

select name
from world
where (gdp/population) > (select (gdp/population) from world where name =  'United Kingdom')
and continent = 'Europe';

/* 8. List the name and continent of countries in the continents containing either Argentina or Australia. Order by name of the country. */

select name, continent
from world
where continent = (select continent from world where name = 'Argentina') or continent = (select continent from world where name = 'Australia')
order by name;

/* 9. Which country has a population that is more than Canada but less than Poland? Show the name and the population. */

select name, population
from world
where population > ( select population from world where name = 'Canada') and
population < ( select population from world where name = 'Poland');

/* 10. Which countries have a GDP greater than every country in Europe? [Give the name only.] (Some countries may have NULL gdp values) */

select name
from world
where gdp > (select max(gdp) from world where continent = 'Europe')

/* 11. Germany (population 80 million) has the largest population of the countries in Europe. Austria (population 8.5 million) has 11% of the population of Germany.

Show the name and the population of each country in Europe. Show the population as a percentage of the population of Germany. */

select name, Concat(round(((population/(select population from world where name = 'Germany'))*100)),'%')
from world
where continent = 'Europe';

/*12. Find the largest country (by area) in each continent, show the continent, the name and the area */

select continent,name, area 
from world x
where area >= All(select area from world y
where y.continent = x.continent);

/*13. Some countries have populations more than three times that of any of their neighbours (in the same continent). Give the countries and continents. */

SELECT x.name, x.continent FROM world x
WHERE x.population > All(SELECT 3*(y.population) FROM world y
WHERE y.continent=x.continent
and x.name != y.name)

/*14. List each continent and the name of the country that comes first alphabetically. */

select continent, name
from world x
where name =
(select name from world y
where x.continent = y.continent
order by name
limit 1)

/* 15. List the continents that have a total population of at least 100 million. */

select continent
from world 
group by continent
having sum(population) >= 100000000

-- The JOIN operation
/* 16. For every match involving 'POL', show the matchid, date and the number of goals scored. */

SELECT matchid,mdate,count(teamid)
FROM game JOIN goal ON matchid = id 
WHERE (team1 = 'POL' OR team2 = 'POL')
group by 1,2

/* 17. For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER' */

SELECT matchid,mdate,count(teamid)
  FROM game JOIN goal ON matchid = id 
 WHERE (team1 = 'GER' OR team2 = 'GER')
and teamid = 'GER'
group by 1,2


