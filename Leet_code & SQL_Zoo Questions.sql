--------------------------     This has SQL questions from SQL Zoo, Leet code and upGrad ---------------------------------------------------

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


/* 3.Show the name and per-capita GDP for those countries with a GDP of at least one trillion (1000000000000; that is 12 zeros). Round this value to the nearest 1000.Show per-capita GDP for the trillion dollar countries to the nearest $1000. */

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

select w1.id as 'Id'
from weather w1, weather w2
where datediff(w1.recordDate, w2.recordDate) = 1
and w1.temperature > w2.temperature

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

/*43. Exchange Seats

Mary is a teacher in a middle school and she has a table seat storing students' names and their corresponding seat ids.
The column id is continuous increment.
Mary wants to change seats for the adjacent students.
Can you write a SQL query to output the result for Mary?

+---------+---------+
|    id   | student |
+---------+---------+
|    1    | Abbot   |
|    2    | Doris   |
|    3    | Emerson |
|    4    | Green   |
|    5    | Jeames  |
+---------+---------+
For the sample input, the output is:
+---------+---------+
|    id   | student |
+---------+---------+
|    1    | Doris   |
|    2    | Abbot   |
|    3    | Green   |
|    4    | Emerson |
|    5    | Jeames  |
+---------+---------+
Note:If the number of students is odd, there is no need to change the last one's seat. */

select s1.id, s2.student
from seat s1 , seat s2
where 
CASE
when s1.id%2 = 1 AND s1.id = (select max(id) from seat) then s1.id = s2.id
when s1.id%2 = 0 then s1.id = s2.id+1
else s2.id = s1.id + 1
END
order by s1.id;

select
(CASE
when (((select count(id) from seat)%2 = 1) and id = (select max(id) from seat)) then id
when (id %2 = 1) then id+1
else id-1
END) as id, student
from seat
order by id;

/* 44. Swap Salary
Table: Salary

+-------------+----------+
| Column Name | Type     |
+-------------+----------+
| id          | int      |
| name        | varchar  |
| sex         | ENUM     |
| salary      | int      |
+-------------+----------+
id is the primary key for this table.
The sex column is ENUM value of type ('m', 'f').
The table contains information about an employee.
Write an SQL query to swap all 'f' and 'm' values (i.e., change all 'f' values to 'm' and vice versa) with a single update statement and no intermediate temp table(s).

Note that you must write a single update statement, DO NOT write any select statement for this problem.
The query result format is in the following example:

Salary table:
+----+------+-----+--------+
| id | name | sex | salary |
+----+------+-----+--------+
| 1  | A    | m   | 2500   |
| 2  | B    | f   | 1500   |
| 3  | C    | m   | 5500   |
| 4  | D    | f   | 500    |
+----+------+-----+--------+

Result table:
+----+------+-----+--------+
| id | name | sex | salary |
+----+------+-----+--------+
| 1  | A    | f   | 2500   |
| 2  | B    | m   | 1500   |
| 3  | C    | f   | 5500   |
| 4  | D    | m   | 500    |
+----+------+-----+--------+
(1, A) and (2, C) were changed from 'm' to 'f'.
(2, B) and (4, D) were changed from 'f' to 'm'. */

update Salary
set sex = CASE sex
when 'f' then 'm'
when 'm' then 'f'
end

/* 44. Best teacher
Given the table marks containing the details of marks obtained by students containing the following columns

Student_id : Storing the id of the student
Course         : Storing the name of the course 
Marks           : Storing the marks obtained by the student in the particular course

and the table teacher containing the details of the teacher with the following columns

Teacher_name : Storing the name of the teacher
Course                 : Storing the course taught by the teacher

Write a query to find the name of the teacher teaching the course with the highest average. */

select Teacher_name
from Teacher
where course = (select course 
from marks
group by course
order by avg(marks) desc 
limit 1);

/* 45. Possible scores
Consider two tables named mathematics and science storing the possible marks a student can get in the two courses. Both tables contain one column named score.
Write a query to list all possible total scores a student can get. Order the result in the descending order of total score. If total score is similar for two cases, priority shall be given to the mathematics score. */


select mathematics.score + science.score
from mathematics, science
order by  mathematics.score + science.score desc,mathematics.score desc; 

/*46. Average Salary
Consider the following table named salary containing the details of employee salary of the employees in an organisation along with their department names. Find the name of the department having the maximum average salary.

| Emp_Id | Dep_name | Salary | */

select dep_name
from salary
group by(dep_name)
order by avg(salary) desc
limit 1;

/* 47.Better than average
Consider the following table marks part of a school database containing the following columns
Student_id : Storing the id of the student
Course         : Storing the name of the course 
Marks           : Storing the marks obtained by the student in the particular course

Write a query to determine the id of the students having average makes higher than the overall average. Order the results by student id in ascending order */
select student_id
from marks
group by student_id
having avg(Marks) >(select avg(Marks) from marks)
order by student_id;

/*48. Grandfather
Consider a table named 'father' storing the details of all father-son pairs in a residential society. Write a code to determine the number of grandfather-grandson pairs in the society. For the purpose of the problem, consider grandson as son of one's son. Note that the table stores data in the following form﻿
father
father_id | son_id */

select count(*)
from father f1 inner join father f2
on f1.father_id = f2.son_id;

/*49. Dependents
Consider the schema containing two table employee and dependent containing the columns as given below.
employee
ssn | dno

dependent
essn | dependent_name

﻿Write a query to determine the name of all dependents of the employees of department number 5? Order the results by name of dependents. */

select d.dependent_name
from dependent d
inner join employee e
on d.essn = e.ssn
where e.dno = 5
order by d.dependent_name;

/* 50. MP vs MLA
Consider two tables, storing the date of commencement of tenures of MP (Member of Parliament) and MLA (Member of Legislative Assembly) . Note that is it possible that a person has become the MP or MLA multiple times so he or she will be in the table multiple times.
﻿Write a query to determine the name of the person who took the longest time to be elected as an MP after being elected as a MLA. Consider the first time a person was elected as a MLA and MP. Note that the dates are in form (YYYY-DD-MM format) */

select m.mp_name
from MP m
inner join MLA l
on m.mp_name = l.mla_name
group by m.mp_name
order by (min(m.joining_date) - min(l.joining_date)) desc
limit 1;

/* 51. Student Salary
Given the following table salary from a university database, write a query to find the student_id of with salary greater than 59,999. 

| Student_id | Salary |

Order your results in the order of student_id. */

select student_id
from salary
where salary > 59999

/*52. Average marks
Consider the following table marks part of a school database containing the following columns
Student_id : Storing the id of the student
Course         : Storing the name of the course 
Marks           : Storing the marks obtained by the student in the particular course

Write a query to determine the average marks obtained by students. Order the results in the descending order of average marks. In case the average marks are same for two students, student with a lower student_id should appear first.

The output should be of the form
|Student_id|avg(marks)| */
select student_id, avg(marks)
from marks
group by student_id
order by avg(marks) desc, student_id;

/*53. Winning Arsenal

Consider a table named 'home' storing Arsenal football club's performance in the league at home in 2003-04 season, while the table 'away' stores Arsenal's performance away in the same season.
home
opponent | goals_scored | goals_conceded
away
opponent | goals_scored | goals_conceded
Note that a team is awarded three points for a win, one for a draw and zero for a loss. Write a query to determine the number of teams against whom Arsenal won all the available six points. */

select count(*)
from home h
inner join away a
on h.opponent = a.opponent
where h.goals_scored > h.goals_conceded
and a.goals_scored > a.goals_conceded

/* 54. Joining Date
Consider the table employee having the following columns

employee_id : storing the unique id of the employee
employee_name : storing the name of the employee
designation : storing the designation of the employee
joining_date : storing the date employee joined the organisation in YYYY-MM-DD format

Write a query to print the name of the employees in the order they joined the organisation.(Earliest first) In case two people have joined the organisation on the same date, the person higher in the organisational hierarchy should appear first. (CEO first)

CEO - First level
Department Head - Second level
Regional Manager - Third level */

select employee_name
from employee
order by joining_date,
case
when designation = 'CEO' then 1
when designation = 'Department Head' then 2
when designation = 'Regional Manager' then 3
End asc;

/* 55.Average marks
Consider the two tables from a university database, student and marks.
Student table contains two columns
student_id          : storing the unique id of the student
student_name  : storing the name of the student
The table marks contains the marks obtained by students in various courses.
student_id : storing the id of the student
marks           : storing the marks obtained by the student in one course.

Please note that the name of a student may not be present in the marks obtained table; this is because the student has not yet attempted the exam

Write a query to print the name of the student along with the average marks obtained by the student. Order your result by average marks obtained, highest first. In case a student has not attempted any exam, it should also be included in the result with average marks as NULL and displayed at the end of the resulting table.*/

select s.student_name, avg(m.marks)
from student s
left join marks m
on s.student_id = m.student_id
group by s.student_name
order by avg(m.marks) desc

/* 56. Symmetric Pair
Given the tables student, mathematics_marks, science_marks

student
student_id (Primary Key) | smallint
student_name                         | varchar(30)

mathematics_marks
student_id (Primary Key) | smallint
score                                            | float (5,2)

science_marks
student_id (Primary Key) | smallint
score                                             | float (5,2)

A student is called as being a part of a symmetric pair if the marks obtained by that student in science is equal to the marks obtained by some other student in mathematics and the marks obtained in mathematics are the same as marks obtained by the other student in science.
For example, if Sanskar obtained 78 marks in Mathematics and 80 in Science while Vikas received 80 in Mathematics and 78 in Science, Vikas and Sanskar are both parts of a symmetric pair.
Write a SQL query to find the name of the students who are a part of a symmetric pair. Arrange the output in the order of student name. (A first, z last) */


select student1.student_name, student2.student_name
from (
         select s1.student_id, s1.student_name, m1.score "m_score", sc1.score "sc_score"
         from student s1
                  join mathematics_marks m1 on s1.student_id = m1.student_id
                  join science_marks sc1 on s1.student_id = sc1.student_id) student1,
     (
         select s2.student_id, s2.student_name, m2.score "m_score", sc2.score "sc_score"
         from student s2
                  join mathematics_marks m2 on s2.student_id = m2.student_id
                  join science_marks sc2 on s2.student_id = sc2.student_id) student2

where student1.student_id<>student2.student_id
  and student1.m_score = student2.sc_score
  and student1.sc_score = student2.m_score 
group by 1,2
order by 1,2