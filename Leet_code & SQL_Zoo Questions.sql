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
  
  
/* 6. Show the 1984 winners and subject ordered by subject and winner name; but list Chemistry and Physics last. */

SELECT winner, subject
FROM nobel
WHERE yr=1984
ORDER BY 
case 
when subject IN ('Physics','Chemistry') then 1 else 0 
end, 
subject, winner;