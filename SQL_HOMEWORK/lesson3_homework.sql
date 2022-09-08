--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing

--task1
--Корабли: Для каждого класса определите число кораблей этого класса, потопленных в сражениях. Вывести: класс и число потопленных кораблей.
select 
	s."class", count(s.name) 
from ships s 
     join 
	 outcomes o on o.ship = s."name"
where o."result" = 'sunk'
group by 
	s."class" 
	
--task2
--Корабли: Для каждого класса определите год, когда был спущен на воду первый корабль этого класса. 
--Если год спуска на воду головного корабля неизвестен, определите минимальный год спуска на воду кораблей этого класса. 
--Вывести: класс, год.
select
	c."class", min(t.launched) 
from ships t 
left join 
	classes c on c."class" = t."class" 
group by c."class"
order by  min(t.launched) asc


--task3
--Корабли: Для классов, имеющих потери в виде потопленных кораблей и не менее 
--3 кораблей в базе данных, вывести имя класса и число потопленных кораблей.
			           
select a.class, sunk_cnt
from (
(select class, count(name) AS name_cnt
from ships
group by class
having count(name) >= 3 ) a
join (
select class, count(ship) as sunk_cnt
from outcomes
left join ships on ships.name = outcomes.ship
where result = 'sunk'
group by class) as tq on tq.class = a.class
)			           




--task4
--Корабли: Найдите названия кораблей, имеющих наибольшее
-- число орудий среди всех кораблей такого же водоизмещения (учесть корабли из таблицы Outcomes).

with gun as (
select max(c.numguns) as maxx, c.displacement 
from 
	classes c 
group by c.displacement)
select s."name", c.displacement, c.numguns
from 
		ships s
	join classes c 
		on c."class" = s."class"
	left join outcomes o 
		on o.ship = s."name" 
where
	(c.numguns, c.displacement) in (select * from gun)
order by c.numguns

--task5
--Компьютерная фирма: Найдите производителей принтеров, 
--которые производят ПК с наименьшим объемом RAM и с самым быстрым процессором среди всех ПК, 
--имеющих наименьший объем RAM. Вывести: Maker
with tq as (
   select max(p.speed) 
     from pc p where 
   p.ram = (select min(p.ram) from pc p)) 
select
	distinct pr.maker 
from product pr
where pr."type"  = 'Printer'
and pr.maker in (select p2.maker from pc p
					join product p2 on p2.model = p.model and p.speed in (select * from tq))
	
	
