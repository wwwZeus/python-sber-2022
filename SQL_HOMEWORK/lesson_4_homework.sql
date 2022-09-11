--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task13 (lesson3)
--Компьютерная фирма: Вывести список всех продуктов и производителя с указанием типа продукта (pc, printer, laptop). Вывести: model, maker, type
SELECT model, maker, p."type" FROM product p


--task14 (lesson3)
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, у кого цена вышей средней PC - "1", у остальных - "0"


select p.*,
	   case when p.price > (select avg(k.price) from pc k) then 1 else 0 
	   end as "rel_avg_pc"
from printer p


--task15 (lesson3)
--Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL)
select name 
	from ships 
	where class is null
	
--task16 (lesson3)
--Корабли: Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду.
with sh_name as(
	select name, date_part('year', date) as date 
	from battles
)
select t.*
	from sh_name t
	where date not in (select distinct launched from ships)
	

--task17 (lesson3)
--Корабли: Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.
with sh_name as(select s."name" from ships s where s."class"='Kongo')
select
t.*
from outcomes t 
where t.ship in (select * from sh_name)
	
--task1  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_300) для всех товаров (pc, printer, laptop) с флагом, 
--если стоимость больше > 300. Во view три колонки: model, price, flag
create or replace view all_products_flag_300 as
(
with tmp as (
	select model, price from pc
      union all
	select model, price from printer
      union all
	select model, price from laptop
)
select t.*, case when t.price > 300 then 1 else 0 end as "flag"
	from tmp t
)
	
--task2  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_avg_price) для всех товаров (pc, printer, laptop)
--с флагом, если стоимость больше cредней . Во view три колонки: model, price, flag

create view all_products_flag_avg_price as
with tmp as (
	select model, price from pc
union all
	select model, price from printer
union all
	select model, price from laptop
)
select t.*,
case when t.price > (select avg(t.price) from tmp t) then 1 else 0 end as "flag"
from tmp t

--task3  (lesson4)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model
with tmp as (
select p.model,s.maker,p.price 
	from printer p 
	left join product s on p.model = s.model 
)
select t.model 
	from tmp t 
	where t.maker = 'A' 
		and t.price > (select avg(price) from tmp where maker in('D', 'C'))
		
		
--task4 (lesson4)
-- Компьютерная фирма: Вывести все товары производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model

with tmp as (
select tq.*,s.maker,s."type"  from (	
    select model, price from pc t
union all
	select model, price from printer
union all
	select model, price from laptop) tq left join product s on tq.model = s.model 
)
--select avg(price) from tmp where maker in('D', 'C') and tmp."type"='Printer'
select t.model 
	from tmp t 
	where t.maker = 'A' 
		and t.price > (select avg(price) from tmp where maker in('D', 'C') and tmp."type"='Printer')

--task5 (lesson4)
-- Компьютерная фирма: Какая средняя цена среди уникальных продуктов производителя = 'A' (printer & laptop & pc)
		
--вывел среднее значение по всем 14 объектам без разделения на типы продуктов
with tmp as (
select distinct tq.model, tq.price from (	
    select model, price from pc t
union all
	select model, price from printer
union all
	select model, price from laptop) tq  join product s on tq.model = s.model and s.maker ='A' 
)

select avg(tmp.price) average from tmp
		

--task6 (lesson4)
-- Компьютерная фирма: Сделать view с количеством товаров (название count_products_by_makers) по каждому производителю. Во view: maker, count

--осознанно не обращался к таблицам pc, printer, laptop т.к. в задании не сказано, что в разрезе типов товаров
create or replace view count_products_by_makers as 
	select t.maker, count(t.*) count_product 
	from product t 
	group by t.maker


--task7 (lesson4)
-- По предыдущему view (count_products_by_makers) сделать график в colab (X: maker, y: count)
	
--https://colab.research.google.com/drive/1EpxC7nY3hWPY-GC3CtikE98_SXtCj5qd


--task8 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы printer (название printer_updated) и удалить из нее все принтеры производителя 'D'

--создание копии таблицы
create table printer_updated as
select * from printer

--удаление производителя 'D'
delete from printer_updated
where model in (
		select p.model 
		from product p
		   join
		     printer pr on pr.model = p.model 
		where p.maker = 'D')


--task9 (lesson4)
-- Компьютерная фирма: Сделать на базе таблицы (printer_updated) view с дополнительной колонкой производителя (название printer_updated_with_makers)
		
--создание view
create view printer_updated_with_makers as
select p.maker, tq.* 
from printer_updated tq
   join
     product p on p.model = tq.model

--task10 (lesson4)
-- Корабли: Сделать view c количеством потопленных кораблей и классом корабля (название sunk_ships_by_classes). 
--Во view: count, class (если значения класса нет/IS NULL, то заменить на 0)
     
--NVL(s."class", '0'),
create view sunk_ships_by_classes as
select t.cl, count(*) count from (
 select 
case when concat(c."class", s."class")=''  then '0' else concat(c."class", s."class") end cl
 from outcomes o 
      left join ships s on s."name" = o.ship 
      left join classes c on c."class" = o.ship 
where o."result" = 'sunk'
) t
group by t.cl   


	
--task11 (lesson4)
-- Корабли: По предыдущему view (sunk_ships_by_classes) сделать график в colab (X: class, Y: count)

--https://colab.research.google.com/drive/1EpxC7nY3hWPY-GC3CtikE98_SXtCj5qd

--task12 (lesson4)
-- Корабли: Сделать копию таблицы classes (название classes_with_flag) и добавить в нее flag: если количество орудий больше или равно 9 - то 1, иначе 0
create table classes_with_flag as
select c.*, case when c.numguns >= 9 then 1 else 0 end as flag
from classes c 

drop table classes_with_flag

--task13 (lesson4)
-- Корабли: Сделать график в colab по таблице classes с количеством классов по странам (X: country, Y: count)


--task14 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название начинается с буквы "O" или "M".
select count(*) from ships s 
where --s."name" like ('O%') or s."name" like 'M%' 
regexp_match(s."name", '^O|^M') is not null

--task15 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название состоит из двух слов.
select count(*) from ships s 
where --s."name" like ('O%') or s."name" like 'M%' 
regexp_match(s."name", ' ') is not null

--task16 (lesson4)
-- Корабли: Построить график с количеством запущенных на воду кораблей и годом запуска (X: year, Y: count)

--https://colab.research.google.com/drive/1EpxC7nY3hWPY-GC3CtikE98_SXtCj5qd
