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

SELECT name, population,area
FROM world WHERE
(population>250000000 OR area>3000000)
AND NOT(population>250000000 AND area>3000000);

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

select name, continent
from world
where continent in (select continent from world where name = 'Argentina' 
or name = 'Australia')
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

SELECT name  
  FROM world  
 WHERE gdp > ALL (SELECT gdp FROM world WHERE continent ='Europe' and gdp is not null)


/* 11. Germany (population 80 million) has the largest population of the countries in Europe. Austria (population 8.5 million) has 11% of the population of Germany.

Show the name and the population of each country in Europe. Show the population as a percentage of the population of Germany. */

select name, Concat(round(((population/(select population from world where name = 'Germany'))*100)),'%')
from world
where continent = 'Europe';

select name, concat(cast(round(100*(population/(select population from world where name = 'Germany')),0)as int),'%') as percentage
from world
where continent = 'Europe'

/*12. Find the largest country (by area) in each continent, show the continent, the name and the area */

select continent,name, area 
from world x
where area >= All(select area from world y
where y.continent = x.continent);

select continent,name, area 
from world 
where area IN (select max(area) from world group by continent);

select x.continent,name, x.area 
from world x
join
(select continent, max(area) as AREA
from world y
group by y.continent) as w2
on x.continent = w2.continent 
and x.area = w2.area

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

select continent, min(name) as name
from world
group by continent
order by continent;

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
group by mdate,matchid,team1,team2
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

---- Leet Code

/* 29.  Reformat Department Table
Table: Department

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| revenue       | int     |
| month         | varchar |
+---------------+---------+
(id, month) is the primary key of this table.
The table has information about the revenue of each department per month.
The month has values in ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"].
 

Write an SQL query to reformat the table such that there is a department id column and a revenue column for each month.

The query result format is in the following example:

Department table:
+------+---------+-------+
| id   | revenue | month |
+------+---------+-------+
| 1    | 8000    | Jan   |
| 2    | 9000    | Jan   |
| 3    | 10000   | Feb   |
| 1    | 7000    | Feb   |
| 1    | 6000    | Mar   |
+------+---------+-------+

Result table:
+------+-------------+-------------+-------------+-----+-------------+
| id   | Jan_Revenue | Feb_Revenue | Mar_Revenue | ... | Dec_Revenue |
+------+-------------+-------------+-------------+-----+-------------+
| 1    | 8000        | 7000        | 6000        | ... | null        |
| 2    | 9000        | null        | null        | ... | null        |
| 3    | null        | 10000       | null        | ... | null        |
+------+-------------+-------------+-------------+-----+-------------+

Note that the result table has 13 columns (1 for the department id + 12 for the months). */

select id,
max(case when month = 'Jan' then revenue else null end)'Jan_revenue',
max(case when month = 'Feb' then revenue else null end)'Feb_revenue',
max(case when month = 'Mar' then revenue else null end)'Mar_revenue',
max(case when month = 'Apr' then revenue else null end)'Apr_revenue',
max(case when month = 'May' then revenue else null end)'May_revenue',
max(case when month = 'Jun' then revenue else null end)'Jun_revenue',
max(case when month = 'Jul' then revenue else null end)'Jul_revenue',
max(case when month = 'Aug' then revenue else null end)'Aug_revenue',
max(case when month = 'Sep' then revenue else null end)'Sep_revenue',
max(case when month = 'Oct' then revenue else null end)'Oct_revenue',
max(case when month = 'Nov' then revenue else null end)'Nov_revenue',
max(case when month = 'Dec' then revenue else null end)'Dec_revenue'
from Department
group by id;

-- Note: Results are the same even if I use different aggregrate function like min or sum.
-- Note : Read more max(case) here : https://boards.straightdope.com/t/sql-query-max-case-when/689438

/* 30. Big Countries
There is a table World

+-----------------+------------+------------+--------------+---------------+
| name            | continent  | area       | population   | gdp           |
+-----------------+------------+------------+--------------+---------------+
| Afghanistan     | Asia       | 652230     | 25500100     | 20343000      |
| Albania         | Europe     | 28748      | 2831741      | 12960000      |
| Algeria         | Africa     | 2381741    | 37100000     | 188681000     |
| Andorra         | Europe     | 468        | 78115        | 3712000       |
| Angola          | Africa     | 1246700    | 20609294     | 100990000     |
+-----------------+------------+------------+--------------+---------------+
A country is big if it has an area of bigger than 3 million square km or a population of more than 25 million.

Write a SQL solution to output big countries' name, population and area.

For example, according to the above table, we should output:

+--------------+-------------+--------------+
| name         | population  | area         |
+--------------+-------------+--------------+
| Afghanistan  | 25500100    | 652230       |
| Algeria      | 37100000    | 2381741      |
+--------------+-------------+--------------+   */

select name, population , area
from world
where area > 3000000 or population > 25000000;

/* 31. Not Boring Movies
X city opened a new cinema, many people would like to go to this cinema. The cinema also gives out a poster indicating the movies’ ratings and descriptions.
Please write a SQL query to output movies with an odd numbered ID and a description that is not 'boring'. Order the result by rating.

 

For example, table cinema:

+---------+-----------+--------------+-----------+
|   id    | movie     |  description |  rating   |
+---------+-----------+--------------+-----------+
|   1     | War       |   great 3D   |   8.9     |
|   2     | Science   |   fiction    |   8.5     |
|   3     | irish     |   boring     |   6.2     |
|   4     | Ice song  |   Fantacy    |   8.6     |
|   5     | House card|   Interesting|   9.1     |
+---------+-----------+--------------+-----------+
For the example above, the output should be:
+---------+-----------+--------------+-----------+
|   id    | movie     |  description |  rating   |
+---------+-----------+--------------+-----------+
|   5     | House card|   Interesting|   9.1     |
|   1     | War       |   great 3D   |   8.9     |
+---------+-----------+--------------+-----------+ */

select * from cinema
where (id%2) != 0
and description != 'boring'
order by rating desc;

/* 32. Delete Duplicate Emails
Write a SQL query to delete all duplicate email entries in a table named Person, keeping only unique emails based on its smallest Id.

+----+------------------+
| Id | Email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
| 3  | john@example.com |
+----+------------------+
Id is the primary key column for this table.
For example, after running your query, the above Person table should have the following rows:

+----+------------------+
| Id | Email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
+----+------------------+

Note: this will work only if use delete function. */

Delete p1
from person p1, person p2
where (p1.email = p2.email) and (p1.id > p2.id)

delete from person 
where id not in
(
select * from 
(select min(id) from person 
group by email)as p);

/* 33. Duplicate Emails
Write a SQL query to find all duplicate emails in a table named Person.

+----+---------+
| Id | Email   |
+----+---------+
| 1  | a@b.com |
| 2  | c@d.com |
| 3  | a@b.com |
+----+---------+
For example, your query should return the following for the above table:

+---------+
| Email   |
+---------+
| a@b.com |
+---------+
Note: All emails are in lowercase. */

select Email
from Person
group by Email
having count(Email) > 1;

/* 34. Second Highest Salary
Write a SQL query to get the second highest salary from the Employee table.

+----+--------+
| Id | Salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+
For example, given the above Employee table, the query should return 200 as the second highest salary. If there is no second highest salary, then the query should return null.

+---------------------+
| SecondHighestSalary |
+---------------------+
| 200                 |
+---------------------+ */


select COALESCE((select distinct salary from employee order by Salary desc limit 1,1),null) as 'SecondHighestSalary' ;

/* 35. Nth Highest Salary
Write a SQL query to get the nth highest salary from the Employee table.

+----+--------+
| Id | Salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+
For example, given the above Employee table, the nth highest salary where n = 2 is 200. If there is no nth highest salary, then the query should return null.

+------------------------+
| getNthHighestSalary(2) |
+------------------------+
| 200                    |
+------------------------+ */

CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
    set N = N-1;
  RETURN (
      select ifnull((Select distinct Salary
      from employee
      order by Salary desc
      limit N,1),null)
  );
END

/* 36. Customers Who Never Order
Suppose that a website contains two tables, the Customers table and the Orders table. Write a SQL query to find all customers who never order anything.

Table: Customers.

+----+-------+
| Id | Name  |
+----+-------+
| 1  | Joe   |
| 2  | Henry |
| 3  | Sam   |
| 4  | Max   |
+----+-------+
Table: Orders.

+----+------------+
| Id | CustomerId |
+----+------------+
| 1  | 3          |
| 2  | 1          |
+----+------------+
Using the above tables as example, return the following:

+-----------+
| Customers |
+-----------+
| Henry     |
| Max       |
+-----------+ */

select Name As Customers
from Customers
where id not in (select Customerid from Orders);

/* 37. Combine Two Tables

Table: Person

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| PersonId    | int     |
| FirstName   | varchar |
| LastName    | varchar |
+-------------+---------+
PersonId is the primary key column for this table.
Table: Address

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| AddressId   | int     |
| PersonId    | int     |
| City        | varchar |
| State       | varchar |
+-------------+---------+
AddressId is the primary key column for this table.
 

Write a SQL query for a report that provides the following information for each person in the Person table, regardless if there is an address for each of those people:

FirstName, LastName, City, State */

select p.FirstName, p.LastName, a.City, a.State
from Person p
left join Address a
on p.PersonId = a.PersonId;

/* 38. Employees Earning More Than Their Managers
The Employee table holds all employees including their managers. Every employee has an Id, and there is also a column for the manager Id.

+----+-------+--------+-----------+
| Id | Name  | Salary | ManagerId |
+----+-------+--------+-----------+
| 1  | Joe   | 70000  | 3         |
| 2  | Henry | 80000  | 4         |
| 3  | Sam   | 60000  | NULL      |
| 4  | Max   | 90000  | NULL      |
+----+-------+--------+-----------+
Given the Employee table, write a SQL query that finds out employees who earn more than their managers. For the above table, Joe is the only employee who earns more than his manager.

+----------+
| Employee |
+----------+
| Joe      |
+----------+ */

select e1.Name as Employee 
from Employee e1, employee e2
where e1.Salary > e2.Salary
and e1.managerId = e2.Id;

select e1.Name as Employee
from Employee e1
inner join Employee e2
on e1.managerid = e2.id
where e1.salary > e2.salary

/* 39. Rising Temperature
Table: Weather

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| recordDate    | date    |
| temperature   | int     |
+---------------+---------+
id is the primary key for this table.
This table contains information about the temperature in a certain day.
 

Write an SQL query to find all dates' id with higher temperature compared to its previous dates (yesterday).

Return the result table in any order.

The query result format is in the following example:

Weather
+----+------------+-------------+
| id | recordDate | Temperature |
+----+------------+-------------+
| 1  | 2015-01-01 | 10          |
| 2  | 2015-01-02 | 25          |
| 3  | 2015-01-03 | 20          |
| 4  | 2015-01-04 | 30          |
+----+------------+-------------+

Result table:
+----+
| id |
+----+
| 2  |
| 4  |
+----+
In 2015-01-02, temperature was higher than the previous day (10 -> 25).
In 2015-01-04, temperature was higher than the previous day (20 -> 30). */

/* 40. Department Highest Salary
The Employee table holds all employees. Every employee has an Id, a salary, and there is also a column for the department Id.

+----+-------+--------+--------------+
| Id | Name  | Salary | DepartmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 70000  | 1            |
| 2  | Jim   | 90000  | 1            |
| 3  | Henry | 80000  | 2            |
| 4  | Sam   | 60000  | 2            |
| 5  | Max   | 90000  | 1            |
+----+-------+--------+--------------+
The Department table holds all departments of the company.

+----+----------+
| Id | Name     |
+----+----------+
| 1  | IT       |
| 2  | Sales    |
+----+----------+
Write a SQL query to find employees who have the highest salary in each of the departments. For the above tables, your SQL query should return the following rows (order of rows does not matter).

+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Max      | 90000  |
| IT         | Jim      | 90000  |
| Sales      | Henry    | 80000  |
+------------+----------+--------+ */

select d.Name as Department, e.Name as Employee, e.Salary as Salary
from employee e
join department d
on e.departmentId = d.id
where (e.departmentId, e.salary) in (select DepartmentId, max(Salary) from employee group by departmentId)


With temp as
(
select DepartmentId as dp1, Max(Salary) as Sal1
    from employee
    group by DepartmentId
)
select d.Name as Department, e.Name as Employee, Sal1 as Salary
from employee e, temp t, Department d
where e.departmentid = t.dp1
and e.Salary = t.Sal1
and t.dp1 = d.id
	
/* 41. Rank Scores
Write a SQL query to rank scores. If there is a tie between two scores, both should have the same ranking. Note that after a tie, the next ranking number should be the next consecutive integer value. In other words, there should be no "holes" between ranks.

+----+-------+
| Id | Score |
+----+-------+
| 1  | 3.50  |
| 2  | 3.65  |
| 3  | 4.00  |
| 4  | 3.85  |
| 5  | 4.00  |
| 6  | 3.65  |
+----+-------+
For example, given the above Scores table, your query should generate the following report (order by highest score):

+-------+---------+
| score | Rank    |
+-------+---------+
| 4.00  | 1       |
| 4.00  | 1       |
| 3.85  | 2       |
| 3.65  | 3       |
| 3.65  | 3       |
| 3.50  | 4       |
+-------+---------+ */

select score, dense_rank() over(order by score desc)  as `Rank`
from Scores;

/* 42. Consecutive Numbers
Table: Logs

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| num         | varchar |
+-------------+---------+
id is the primary key for this table.
 

Write an SQL query to find all numbers that appear at least three times consecutively.

Return the result table in any order.

The query result format is in the following example:

 

Logs table:
+----+-----+
| Id | Num |
+----+-----+
| 1  | 1   |
| 2  | 1   |
| 3  | 1   |
| 4  | 2   |
| 5  | 1   |
| 6  | 2   |
| 7  | 2   |
+----+-----+

Result table:
+-----------------+
| ConsecutiveNums |
+-----------------+
| 1               |
+-----------------+
1 is the only number that appears consecutively for at least three times. */

select distinct num as ConsecutiveNums
from 
(select num, lead(num) over(order by id) as lead_num, 
lag(num) over(order by id) as lag_num
from logs)a
where num =lag_num and num = lead_num;
