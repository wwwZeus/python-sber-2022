--task1  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem
select case when grade < 8 then NULL else NAME end, grade, MARKS
from STUDENTS s
   left join grades g 
 on S.Marks between g.Min_Mark and g.Max_Mark
order by grades DESC, name ASC, marks ASC;

--task2  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/occupations/problem
-- про "max(IF(..." прочитал в Discussions

Select max(IF(ord.occupation = "Doctor",NAME,NULL)) AS dr,
max(IF(ord.occupation = "Professor",NAME,NULL)) AS prof,
max(IF(ord.occupation = "Singer",NAME,NULL)) AS sing,
max(IF(ord.occupation = "Actor",NAME,NULL)) AS act

From (
    select t.name,t.occupation,
    Row_number() Over (PARTITION BY t.occupation ORDER BY name asc) as cnt FROM occupations t) ord 
  
group by cnt;

--task3  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-9/problem

-- c буквой 'Y' выдает ошибку
select distinct s.city from station s
where regexp_like(s.city, '^[^aeiouAEIOU(*)]');

--task4  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-10/problem

-- c буквой 'Y' выдает ошибку
select distinct s.city from station s
where regexp_like(s.city, '[^aeiouAEIOU]$');

--task5  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-11/problem
select distinct s.city from station s
where regexp_like(s.city, '^[^aeiouAEIOU(*)]') or regexp_like(s.city, '[^aeiouAEIOU]$')


--task6  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-12/problem

select distinct s.city from station s
where regexp_like(s.city, '^[^aeiouAEIOU(*)]') and regexp_like(s.city, '[^aeiouAEIOU]$')

--task7  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/salary-of-employees/problem
select name from employee
where salary > 2000 and months < 10;


--task8  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem
select case when grade < 8 then NULL else NAME end, grade, MARKS
from STUDENTS s
   left join grades g 
 on S.Marks between g.Min_Mark and g.Max_Mark
order by grades DESC, name ASC, marks ASC;