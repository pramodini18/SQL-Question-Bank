/* 1. Best teacher
Given the table marks containing the details of marks obtained by students containing the following columns

Student_id : Storing the id of the student
Course         : Storing the name of the course 
Marks           : Storing the marks obtained by the student in the particular course

and the table teacher containing the details of the teacher with the following columns

Teacher_name : Storing the name of the teacher
Course                 : Storing the course taught by the teacher

Write a query to find the name of the teacher teaching the course with the highest average. */

select t.Teacher_name
from teacher t 
where t.Course = (select course from marks group by course order by avg(marks) desc limit 1);

/* 2. Possible scores
Consider two tables named mathematics and science storing the possible marks a student can get in the two courses. Both tables contain one column named score.
Write a query to list all possible total scores a student can get. Order the result in the descending order of total score. 
If total score is similar for two cases, priority shall be given to the mathematics score.
 */
select mathematics.score + science.score
from mathematics, science
order by  mathematics.score + science.score desc,mathematics.score desc;


/* 3. Average Salary
Description
Consider the following table named salary containing the details of employee salary of the employees in an organisation along with their department names. 
Find the name of the department having the maximum average salary.

| Emp_Id | Dep_name | Salary |
 */
select dep_name
from salary
group by dep_name
order by avg(salary) desc
limit 1;

/* 4. Better than average
Consider the following table marks part of a school database containing the following columns
Student_id : Storing the id of the student
Course         : Storing the name of the course 
Marks           : Storing the marks obtained by the student in the particular course

Write a query to determine the id of the students having average makes higher than the overall average. Order the results by student id in ascending order */


select student_id 
from marks
group by student_id
having avg(marks) > (select avg(marks) from marks)
order by student_id asc;


/* 5. Grandfather
Consider a table named 'father' storing the details of all father-son pairs in a residential society. 
Write a code to determine the number of grandfather-grandson pairs in the society. For the purpose of the problem, consider grandson as son of one's son.
Note that the table stores data in the following form = father table : 2 columns father_id and son_id */

select count(*)
from father f1, father f2
where f1.father_id = f2.son_id;


/* 
6. Dependents
Consider the schema containing two table employee and dependent containing the columns as given below.
employee table: ssn and dno columns
dependent table : essn and dependent_name
﻿Write a query to determine the name of all dependents of the employees of department number 5? Order the results by name of dependents. */


select d.dependent_name
from dependent d 
inner join employee e
on d.essn = e.ssn
where e.dno =5
order by d.dependent_name;

/* 
7. MP vs MLA
Consider two tables, storing the date of commencement of tenures of MP (Member of Parliament) and 
MLA (Member of Legislative Assembly) . Note that is it possible that a person has become the MP or MLA multiple 
times so he or she will be in the table multiple times.﻿

﻿Write a query to determine the name of the person who took the longest time to be elected as an MP after being elected as a MLA. 
Consider the first time a person was elected as a MLA and MP. Note that the dates are in form (YYYY-DD-MM format) */

select mla.mla_name
from mla 
inner join mp 
on mla.mla_name = mp.mp_name
group by mla.mla_name
order by min(mp.joining_date) - min(mla.joining_date) desc
limit 1;


/* 8. Joining Date
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
order by joining_date, designation;

or

alter table employee
add designation_level smallint
default 1;

update employee
set designation_level = 2
where designation = 'Department Head';

update employee
set designation_level = 3 
where designation = 'Regional Manager';

select employee_name
from employee
order by joining_date, designation_level;

/* 9. Average marks
Consider the two tables from a university database, student and marks.
Student table contains two columns
student_id          : storing the unique id of the student
student_name  : storing the name of the student
The table marks contains the marks obtained by students in various courses.
student_id : storing the id of the student
marks           : storing the marks obtained by the student in one course.

Please note that the name of a student may not be present in the marks obtained table; this is because the student has not yet attempted the exam

Write a query to print the name of the student along with the average marks obtained by the student. Order your result by average marks obtained, 
highest first. 
In case a student has not attempted any exam, it should also be included in the result with average marks as NULL and displayed at the end of the resulting table.
 */


with avg_marks as (
select student_id, avg(marks) as av_ma
from marks
group by student_id)

select s.student_name, avg_marks.av_ma
from student s 
left join avg_marks
on s.student_id = avg_marks.student_id
order by 2 desc;


/* 10. Symmetric Pair
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

A student is called as being a part of a symmetric pair if the marks obtained by that student in science is equal 
to the marks obtained by some other student in mathematics and the marks obtained in mathematics are the same as marks obtained by the other student in science.

For example, if Sanskar obtained 78 marks in Mathematics and 80 in Science while Vikas received 80 in Mathematics 
and 78 in Science, Vikas and Sanskar are both parts of a symmetric pair.
Write a SQL query to find the name of the students who are a part of a symmetric pair. Arrange the output in the order of student name. (A first, z last) */


create table t as 
(
select s.student_id as id, s.student_name as name, m.score as m_sc , sc.score as s_sc
from student s 
inner join mathematics_marks m
on s.student_id = m.student_id
inner join science_marks sc 
on s.student_id = sc.student_id
);

select t1.name
from t t1, t t2
where t1.m_sc = t2.s_sc
and t2.m_sc = t1.s_sc 
order by 1;

/* 
11. Even marks
Consider a table consisting the marks of students in a mathematics test along with their unique student_id. 
Write a query to determine which students got the marks that is divisible by 10 and which students did not. Make sure that the output is ordered by student_id. */

alter table marks
add div_by_ten varchar(15)
default 'no';

update marks
set div_by_ten = 'yes'
where mod(marks,10) =0; 

select *
from marks
order by student_id;

/* 
12. Topper
Consider a table storing the marks obtained by student in five course, physics, chemistry, mathematics, history and philosophy in comma separated form. ﻿

﻿Write a query to determine the id of the student who has the highest average in Physics, Chemistry and Mathematics.
Assume that the marks are all stored as two digit numbers. 
 */

select student_id
from marks
order by substring(marks,1,2) + substring(marks,4,2) + substring(marks,7,2) desc
limit 1;


/* 13. Average distance
Consider a table employee storing the details of the employee. 

ssn : social security number of the employee
address : storing the address of the employee

Looking at the address field in the employee table, you would notice that all the employees reside in "Fondren, Houston, TX". Consider the integer in the address field as house number. Consider the distance between the two houses as the difference in the house numbers, so the distance between house number 2 and 38 is 36 units. Write a query to determine the average distance between the house of the employee with ssn '123456789' and the other employees' houses. Print the answer to two decimal places. Make sure that the answer is formatted with a comma like x,xxx.xx . */ 

alter table employee
add hno int; 

update employee
set hno = (select substring_index(address,' ',1));

select format(avg(abs(hno- (select hno from employee where ssn = '123456789'))),2)
from employee
where ssn != '123456789';

or 

select format (avg(abs(substring_index(address, ' ', 1)-(select substring_index(address, ' ', 1)
from employee
where ssn = '123456789'
))), 2)
from employee
where ssn != '123456789';


/* 14. Employee gender
Consider the table employee with the following columns

fname         : Storing the first name of the employee
minit            : storing the middle initial of the employee
lname          : Storing the last name of the employee
ssn                : Storing the social security number of the employee
bdate          : Storing the date of birth of the employee
address      : Storing the address of the employee
sex                : Storing the gender of the employee
salary          : Storing the annual salary of the employee
super_ssn : Storing the socila security number of the supervisor of the employee
dno               : Storing the department number of the employee

Write a query to find the social security number of all employees who are either female or have salary greater than 30000. 
Order the results on the basis of social security number in ascending order. Please note that the gender is denoted by either F or M. */

select ssn from employee
where sex = 'F' or 
salary > 30000
order by 1 asc;


/* 15. Same Salary
Given the tables student, roommate, salary

student
student_id (Primary Key) | smallint
student_name                         | varchar(30)

roommate
student_id (Primary Key) | smallint
roommate_id                           | smallint

salary
student_id (Primary Key) | smallint
salary                   | float(10,2)

Write a SQL query to print the name of the students with the same salary as their roommate in order of their student id?
 */
 
select student_name
from student
where student_id =
(
select r.student_id
from roommate r
inner join salary s 
on r.student_id = s.student_id
inner join salary s1
on r.roommate_id = s1.student_id and s.salary = s1.salary)
order by student_id;


/*  16. Maximum Price
Consider a table named 'food' in a restaurant database having the following columns
name : storing the name of the dish
price : storing the price of the dish

Write a query to determine the type of food item (Maggi, Pasta, Sandwich,Mojito,Shake,....) 
which has the maximum average price along with the average price of the said food type. 
Please note that the food item type is determined by the last word in the food_name. */

select substring_index(name,' ',-1),
avg(price)
from food
group by 1
order by 2 desc
limit 1;

/* 17. A country is big if it has an area of bigger than 3 million square km or a population of more than 25 million.

Write a SQL solution to output big countries' name, population and area. */

select name, population,
area
from world
where area > 3000000
or
population > 25000000;

/* 18.X city opened a new cinema, many people would like to go to this cinema. The cinema also gives out a poster indicating the movies’ ratings and descriptions.
Please write a SQL query to output movies with an odd numbered ID and a description that is not 'boring'. Order the result by rating.
 */
 select * from cinema
where id%2 !=0
and description != 'boring'
order by rating desc;


/* 19. Write a SQL query to find all duplicate emails in a table named Person. */

select email as Email
from person
group by email
having count(email) >1;


/* 20. Write a SQL query for a report that provides the following information for each person in the Person table, regardless if there is an address for each of those people:
FirstName, LastName, City, State
person:
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| PersonId    | int     |
| FirstName   | varchar |
| LastName    | varchar |
+-------------+---------+
PersonId is the primary key column for this table.

Address:
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| AddressId   | int     |
| PersonId    | int     |
| City        | varchar |
| State       | varchar |
+-------------+---------+
AddressId is the primary key column for this table. */


select p.FirstName,p.LastName, a.city, a.state
from person p
left join address a
on p.personid = a.personid;

/* 
21.Suppose that a website contains two tables, the Customers table and the Orders table. Write a SQL query to find all customers who never order anything.

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
+----+------------+ */

/* 22. select c.name as Customers
from customers c
where c.id not in (select CustomerId from orders);

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
Note:

Your output is the whole Person table after executing your sql. Use delete statement. */

delete p1 from person p1, person p2
where p1.email = p2.email and p1.id > p2.id;

/* 23.Write a SQL query to get the second highest salary from the Employee table.

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

SELECT max(Salary) as 'SecondHighestSalary'
FROM Employee
WHERE Salary < (SELECT max(Salary) FROM Employee)
order by salary desc;

select
CASE 
WHEN salary = NULL THEN null ELSE employee.salary END AS 'SecondHighestSalary'
from employee
order by salary desc
limit 1,1;

select ifnull((select distinct salary 
             from employee
             order by salary desc
             limit 1,1), Null) as SecondHighestSalary ;

/* 24.Write a SQL query to rank scores. If there is a tie between two scores, both should have the same ranking. Note that after a tie, the next ranking number should be the next consecutive integer value. In other words, there should be no "holes" between ranks.

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

+-------+------+
| Score | Rank |
+-------+------+
| 4.00  | 1    |
| 4.00  | 1    |
| 3.85  | 2    |
| 3.65  | 3    |
| 3.65  | 3    |
| 3.50  | 4    |
+-------+------+
 */
 
 select score as Score, dense_rank() over(order by score desc) as Rank
 from scores;
 
 select s.score as Score,
 (select count(distinct score) from scores where score >=s.score) as Rank
 from scores s
 order by s.score desc;
 
 /* 25. Combine Two Tables
 
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

select p.FirstName, p.LastName,
a.City, a.State
from Person p
left join Address a
on p.PersonId = a.PersonId;

6 -2 1962
1:30 pm


/* 26. Consecutive Numbers
Write a SQL query to find all numbers that appear at least three times consecutively.

+----+-----+
| Id | Num |
+----+-----+
| 1  |  1  |
| 2  |  1  |
| 3  |  1  |
| 4  |  2  |
| 5  |  1  |
| 6  |  2  |
| 7  |  2  |
+----+-----+
For example, given the above Logs table, 1 is the only number that appears consecutively for at least three times.

+-----------------+
| ConsecutiveNums |
+-----------------+
| 1               |
+-----------------+
*/

select distinct l1.num as ConsecutiveNums
from 
        logs l1,
        logs l2,
        logs l3
where l1.id = l2.id - 1
and l2.id = l3.id -1
and l1.num = l2.num
and l2.num = l3.num;


SELECT DISTINCT num as ConsecutiveNums
FROM
(
SELECT num,LEAD(num) OVER(ORDER BY id) AS next_num, LAG(num) OVER (ORDER BY id) AS before_num
FROM logs
 )t
WHERE num=next_num and num=before_num;


/* 27.Trips and Users

The Trips table holds all taxi trips. Each trip has a unique Id, while Client_Id and Driver_Id are both foreign keys to the Users_Id at the Users table. Status is an ENUM type of (‘completed’, ‘cancelled_by_driver’, ‘cancelled_by_client’).

+----+-----------+-----------+---------+--------------------+----------+
| Id | Client_Id | Driver_Id | City_Id |        Status      |Request_at|
+----+-----------+-----------+---------+--------------------+----------+
| 1  |     1     |    10     |    1    |     completed      |2013-10-01|
| 2  |     2     |    11     |    1    | cancelled_by_driver|2013-10-01|
| 3  |     3     |    12     |    6    |     completed      |2013-10-01|
| 4  |     4     |    13     |    6    | cancelled_by_client|2013-10-01|
| 5  |     1     |    10     |    1    |     completed      |2013-10-02|
| 6  |     2     |    11     |    6    |     completed      |2013-10-02|
| 7  |     3     |    12     |    6    |     completed      |2013-10-02|
| 8  |     2     |    12     |    12   |     completed      |2013-10-03|
| 9  |     3     |    10     |    12   |     completed      |2013-10-03| 
| 10 |     4     |    13     |    12   | cancelled_by_driver|2013-10-03|
+----+-----------+-----------+---------+--------------------+----------+
The Users table holds all users. Each user has an unique Users_Id, and Role is an ENUM type of (‘client’, ‘driver’, ‘partner’).

+----------+--------+--------+
| Users_Id | Banned |  Role  |
+----------+--------+--------+
|    1     |   No   | client |
|    2     |   Yes  | client |
|    3     |   No   | client |
|    4     |   No   | client |
|    10    |   No   | driver |
|    11    |   No   | driver |
|    12    |   No   | driver |
|    13    |   No   | driver |
+----------+--------+--------+
Write a SQL query to find the cancellation rate of requests made by unbanned users (both client and driver must be unbanned) between Oct 1, 2013 and Oct 3, 2013. The cancellation rate is computed by dividing the number of canceled (by client or driver) requests made by unbanned users by the total number of requests made by unbanned users.

For the above tables, your SQL query should return the following rows with the cancellation rate being rounded to two decimal places.

+------------+-------------------+
|     Day    | Cancellation Rate |
+------------+-------------------+
| 2013-10-01 |       0.33        |
| 2013-10-02 |       0.00        |
| 2013-10-03 |       0.50        |
+------------+-------------------+

 */
With query_1(Day1,total_request) as(
select t.Request_at as Day1 ,count(t.Id) as total_request
from trips t
inner join users u
on t.client_id = u.users_id and u.Role = 'client'
where t.Request_at between '2013-10-01' and '2013-10-03'
and u.Banned = 'No'
group by t.Request_at
order by t.Request_at),

query_2(Day2,cancel_request) as (
select t.Request_at as Day2,count(t.Id) as cancel_request
from trips t, users u
where t.client_id = u.users_id and u.Role = 'client'
and t.Request_at between '2013-10-01' and '2013-10-03'
and u.Banned = 'No'
and (t.status = 'cancelled_by_driver' or t.status = 'cancelled_by_client')
group by t.Request_at
order by t.Request_at)

select query_1.Day1 as Day, ifnull((round((query_2.cancel_request/query_1.total_request),2)),0) as 'Cancellation Rate'
from query_1 
left join query_2
on query_1.Day1 = query_2.Day2


/*
28.Nth Highest Salary

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
+------------------------+

*/
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
    DECLARE T int;
    set T = N-1;
    RETURN (
           
                select ifnull((select distinct salary 
                from employee
                order by salary desc
                limit T,1), Null)

            );
    END

/* 29.
Trying something


 */