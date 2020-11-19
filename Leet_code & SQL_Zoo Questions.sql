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

/* 18. show the name of all players who scored a goal against Germany. */

SELECT distinct player
  FROM game JOIN goal ON matchid = id 
    WHERE (team1='GER' OR team2='GER')
and teamid != 'GER'

/* 19. List every match with the goals scored by each team as shown. This will use "CASE WHEN" which has not been explained in any previous exercises.
mdate	team1	score1	team2	score2
1 July 2012	ESP	4	ITA	0
10 June 2012	ESP	1	ITA	1
10 June 2012	IRL	1	CRO	3
...
Notice in the query given every goal is listed. If it was a team1 goal then a 1 appears in score1, otherwise there is a 0. You could SUM this column to get a count of the goals scored by team1. Sort your result by mdate, matchid, team1 and team2. */

select mdate, team1,
sum(case when teamid = team1 then 1 else 0 end) as score1,
team2,
sum(case when teamid = team2 then 1 else 0 end) as score2
from game left join goal on matchid = id
group by mdate,team1,team2
order by mdate, matchid, team1,team2

--- More Join 

/* 20. Obtain a list, in alphabetical order, of actors who've had at least 15 starring roles */

select name
from actor
join casting on 
actor.id = actorid
join movie on
movie.id = movieid
where ord = 1
group by name
having count(name) >=15
order by name

/* 21. List all the people who have worked with 'Art Garfunkel'. */

select name
from actor
join casting on 
actor.id = actorid
join movie on
movie.id = movieid
where movieid in (select movieid
from actor
join casting on 
actor.id = actorid
join movie on
movie.id = movieid
where name = 'Art Garfunkel')
and name != 'Art Garfunkel'

/* 22. List the film title and the leading actor for all of the films 'Julie Andrews' played in. */

select title,name
from actor
join casting on 
actor.id = actorid
join movie on
movie.id = movieid
where movieid in (select movieid
from actor
join casting on 
actor.id = actorid
join movie on
movie.id = movieid
where name = 'Julie Andrews')
and ord = 1

-- Using NULL
/*23. Use the COALESCE function and a LEFT JOIN to print the teacher name and department name. Use the string 'None' where there is no department. */

SELECT teacher.name, COALESCE(dept.name,'None')
 FROM teacher left JOIN dept
           ON (teacher.dept=dept.id)
		   
/* 24. Use COUNT to show the number of teachers and the number of mobile phones. */

select count(name), count(mobile)
from teacher

/* 25. Use COUNT and GROUP BY dept.name to show each department and the number of staff. Use a RIGHT JOIN to ensure that the Engineering department is listed. */

select dept.name, count(teacher.name)
from teacher
right join dept
on teacher.dept = dept.id
group by 1


/* 26. Use CASE to show the name of each teacher followed by 'Sci' if the teacher is in dept 1 or 2 and 'Art' otherwise. */

select name,
case
when (dept = 1 or dept =2) then 'Sci'
else 'Art'
End 
from teacher

--- SELF JOIN

/* 27. Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus, including 'Craiglockhart' itself, offered by the LRT company. Include the company and bus no. of the relevant services. */

select s.name,  a.company, a.num 
from route a
inner join route b
on (a.num = b.num ) and (a.company = b.company)
join stops s
on s.id = a.stop
where b.stop = (select id from stops where name = 'Craiglockhart')

/* 28. Find the routes involving two buses that can go from Craiglockhart to Lochend.
Show the bus no. and company for the first bus, the name of the stop for the transfer,
and the bus no. and company for the second bus. */

select  a.num , a.company, s.name, b1.num , b1.company
from route a
inner join route b
on (a.num = b.num ) and (a.company = b.company)
join stops s
on s.id = a.stop
join route a1
on s.id = a1.stop
inner join route b1
on (a1.num = b1.num ) and (a1.company = b1.company)
where b.stop = (select id from stops where name = 'Craiglockhart')
and
b1.stop = (select id from stops where name = 'Lochend')
group by a.num , a.company, s.name, b1.num , b1.company



