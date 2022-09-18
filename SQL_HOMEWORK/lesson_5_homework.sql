--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1 (lesson5)
-- Компьютерная фирма: Сделать view (pages_all_products), в которой будет постраничная разбивка всех продуктов (не более двух продуктов на одной странице).
--Вывод: все данные из laptop, номер страницы, список всех страниц

create or replace view pages_all_products as (

SELECT *,
      CASE WHEN ROW_NUMBER() OVER() % 2 = 0 THEN ROW_NUMBER() OVER()/2 ELSE ROW_NUMBER() OVER()/2 + 1 END AS page_num,
      CASE WHEN COUNT(*) OVER() % 2 = 0 THEN COUNT(*) OVER()/2 ELSE COUNT(*) OVER()/2 + 1 END AS num_of_pages
      FROM Laptop l
      order by l.code)

--task2 (lesson5)
-- Компьютерная фирма: Сделать view (distribution_by_type), в рамках которого будет процентное соотношение всех товаров по типу устройства. 
--Вывод: производитель, тип, процент (%)

--моя любовь к PARTITION BY безгранична :-)      
create or replace view distribution_by_type as
select distinct maker, 
	   type, 
	   count('maker') over (PARTITION BY type,maker)*1.0*100/count('maker') over () as percent
	from product
	order by maker,type 	
	
select * from distribution_by_type 

--task3 (lesson5)
-- Компьютерная фирма: Сделать на базе предыдущенр view график - круговую диаграмму. Пример https://plotly.com/python/histograms/

--выложил на colab
--https://colab.research.google.com/drive/1cnQQb72EQsxma3lVRTiTfeQlTJ3VUtf4#scrollTo=9yFNH8h-hpNp


--task4 (lesson5)
-- Корабли: Сделать копию таблицы ships (ships_two_words), но название корабля должно состоять из двух слов
create table ships_two_words as (
      select *
      from ships s where s."name" like '% %'
 

drop table ships_two_words
--task5 (lesson5)
-- Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL) и название начинается с буквы "S"
select *
from (
  select name, class from ships
   union all
  select ship, result from outcomes) tq
where tq.name like 'S%' and tq.class is null
      
--task6 (lesson5)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'C'
-- и три самых дорогих (через оконные функции). Вывести model
select model
from (
select maker, printer.model, price,
       row_number() over (partition by maker) as rn
from printer
       left join
     product on printer.model = product.model) tq
where (tq.rn <= 3) or (maker = 'A'
and price > (select avg(price)
                    from printer p
                   left join product p1 on p.model = p1.model
                    where maker = 'C'))     
      
