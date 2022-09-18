--task1  (lesson8)
-- oracle: https://leetcode.com/problems/department-top-three-salaries/

-- Ответ списал с листа 'Solution' :-)
SELECT
    d.Name AS 'Department', e1.Name AS 'Employee', e1.Salary
FROM
    Employee e1
        JOIN
    Department d ON e1.DepartmentId = d.Id
WHERE
    3 > (SELECT
            COUNT(DISTINCT e2.Salary)
        FROM
            Employee e2
        WHERE
            e2.Salary > e1.Salary
                AND e1.DepartmentId = e2.DepartmentId
        )
		
--task2  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/17
SELECT fm.member_name, fm.status, sum(p.amount*p.unit_price) as costs FROM Payments p
left join FamilyMembers fm on fm.member_id = p.family_member
WHERE year(p.date) = '2005'
GROUP BY p.family_member


--task3  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/13
select distinct name from (
SELECT p.name, count(*) over (partition by p.name) ct 
FROM Passenger P ) tq
where tq.ct>1

--task4  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38
select count(*) as 'count' from Student 
where first_name = 'Anna'

--task5  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/35
select count(*) as 'count' from Schedule
where date like '2019-09-02%'

--task6  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38
select count(*) as 'count' from Student 
where first_name = 'Anna'

--task7  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/32
select floor( year(current_date) - avg(year(fm.birthday)) ) as age
from FamilyMembers fm

--task8  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/27
select gt.good_type_name, sum(p.amount*p.unit_price) as costs 
  from Payments p
   left join goods g on g.good_id=p.good
   left join GoodTypes gt on gt.good_type_id=g.type
where year(p.date) = 2005
group by good_type_name

--task9  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/37
SELECT 
(
floor(min((YEAR(CURRENT_DATE) - YEAR(birthday)) -                             
    (DATE_FORMAT(CURRENT_DATE, '%m%d%Y') < DATE_FORMAT(birthday, '%m%d%Y')))
    )
    ) as year
from Student s
--task10  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/44
SELECT max((YEAR(CURRENT_DATE) - YEAR(birthday)) -                             
    (DATE_FORMAT(CURRENT_DATE, '%m%d%Y') < DATE_FORMAT(birthday, '%m%d%Y'))) as 'max_year' FROM Student S 
left join Student_in_class cl on cl.student = s.id
left join class c on c.id = cl.class
where c.name = 10

--task11 (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/20
SELECT fm.status, fm.member_name, sum(p.unit_price * p.amount) 'costs'
FROM Payments p
    left join FamilyMembers fm on fm.member_id = p.family_member 
    left join Goods g on g.good_id = p.good
    left join GoodTypes gt on g.type=gt.good_type_id
WHERE gt.good_type_name = 'entertainment'
GROUP BY fm.member_name, fm.status


--task12  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/55
delete from company c where c.id in 
(
WITH cnt_w AS (
select min(t.cnt) from (SELECT t.company company, count(*) as cnt
from Trip t 
group by t.company) t
)

select a.company from (SELECT t.company company, count(*) as cnt
from Trip t 
group by t.company) A 
where a.cnt = (SELECT * FROM cnt_w)
)

--task13  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/45
select tq.classroom from(
select t.*,
    dense_rank() over (order by cnt desc) 'first'
                from (   
                        select classroom, count(*) cnt
                            from Schedule s
                        group by s.classroom 
                        order by count(*) desc
                    ) t
) tq where first=1  

--task14  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/43
select t.last_name 
from Schedule s
 left join subject sub on s.subject=sub.id
 left join teacher t on t.id = s.teacher
where sub.name = 'Physical Culture'
order  by t.last_name


--task15  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/63

SELECT concat(last_name,'.', LEFT(first_name,1),'.', LEFT(middle_name,1), '.') as name 
  FROM Student S 
ORDER BY last_name, first_name, middle_name DESC 
