--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

-- Задание 1: Вывести name, class по кораблям, выпущенным после 1920
--
select
    name, class
from ships s
where s.launched > 1920

-- Задание 2: Вывести name, class по кораблям, выпущенным после 1920, но не позднее 1942
--
select
    t.name, t.class
from ships t
where t.launched > 1920
      and t.launched < 1942
      
-- Задание 3: Какое количество кораблей в каждом классе. Вывести количество и class
--
select
   c.class, count(t.name)
from ships t
join classes c on t.class = c.class
group by c.class

-- Задание 4: Для классов кораблей, калибр орудий которых не менее 16, укажите класс и страну. (таблица classes)
--
select
  t.class, t.country
from classes t
where t.bore >= 16

-- Задание 5: Укажите корабли, потопленные в сражениях в Северной Атлантике (таблица Outcomes, North Atlantic). Вывод: ship.
--
select t.ship
from outcomes t
where t.battle = 'North Atlantic' 
      and t.result = 'sunk'

-- Задание 6: Вывести название (ship) последнего потопленного корабля
--
select
  t.ship
from outcomes t
left join battles b on b.name = t.battle
where 
  b.date = (select max(date)
                from battles b
                join outcomes t on t.battle = b.name
                where t.result = 'sunk')
-- Задание 7: Вывести название корабля (ship) и класс (class) последнего потопленного корабля
--
select
  t.ship, c."class"  
from outcomes t
left join battles b on b.name = t.battle
left join ships s on s.name = t.ship
left join classes c on c.class = s.class
where 
  b.date = (select max(date)
                from battles b
                join outcomes t on t.battle = b.name
                where t.result = 'sunk')
-- Задание 8: Вывести все потопленные корабли, у которых калибр орудий не менее 16, и которые потоплены. Вывод: ship, class
--
select
  t.ship, c.bore
from outcomes t
left join ships s on s.name = t.ship
left join classes c on c.class = s.class
where 
  t."result" = 'sunk' and c.bore >= 16
  
-- Задание 9: Вывести все классы кораблей, выпущенные США (таблица classes, country = 'USA'). Вывод: class
--
select
  t.class
from classes t
where t.country = 'USA'

-- Задание 10: Вывести все корабли, выпущенные США (таблица classes & ships, country = 'USA'). Вывод: name, class
select
  s.name, t."class"
from classes t
join ships s on s.class = t."class"
where t.country = 'USA'