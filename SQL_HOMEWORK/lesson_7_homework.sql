--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson7)
-- sqlite3: Сделать тестовый проект с БД (sqlite3, project name: task1_7). В таблицу table1 записать 1000 строк с случайными значениями (3 колонки, тип int) от 0 до 1000.
-- Далее построить гистаграмму распределения этих трех колонко



--task2  (lesson7)
-- oracle: https://leetcode.com/problems/duplicate-emails/
select distinct t.email from (
select  p.email, count(1) OVER (PARTITION BY p.email) as cnt_eml from Person p 
    ) t where t.cnt_eml>1 
--task3  (lesson7)
-- oracle: https://leetcode.com/problems/employees-earning-more-than-their-managers/
select e.Name as Employee
from employee e
inner join employee m on m.id = e.ManagerId
where e.salary >= m.salary

--task4  (lesson7)
-- oracle: https://leetcode.com/problems/rank-scores/
select s.score,
    dense_rank() over (order by s.score desc) as 'rank' 
from Scores s

--task5  (lesson7)
-- oracle: https://leetcode.com/problems/combine-two-tables/
select
    p.FirstName, p.LastName, a.City, a.State
from
    person p
      left join address a on p.PersonId = a.PersonId