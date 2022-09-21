--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson6, дополнительно)
-- SQL: Создайте таблицу с синтетическими данными (10000 строк, 3 колонки, все типы int) и 
--заполните ее случайными данными от 0 до 1 000 000. Проведите EXPLAIN операции и сравните базовые операции.

CREATE TABLE test_table as (
SELECT 
 floor((random()*1000000.0)) AS col_1,
 round((random()*1000000.0)) AS col_2,
 round((random()*1000000.0)) AS col_3 
		FROM 
generate_series(1, 100000) a )

drop table test_table;

--Разными запросами сравниваю время выполнения (ответы у запросов разные)
explain
select * from test_table
--Seq Scan on test_table  (cost=0.00..1637.00 rows=100000 width=24)

explain 
select  t.* from test_table t
where  (t.col_1>13232 and t.col_2 < 12322 and t.col_3 >= 14524)
--Seq Scan on test_table t  (cost=0.00..2387.00 rows=1187 width=24)

explain 
select distinct t.* from test_table t
where  (t.col_1>13232 and t.col_2 < 12322 and t.col_3 >= 14524)
except 
select distinct t.* from test_table t
where  (t.col_1<5)
--HashSetOp Except  (cost=2395.90..4321.94 rows=1186 width=28)


--task2 (lesson6, дополнительно)
-- GCP (Google Cloud Platform): Через GCP загрузите данные csv в базу PSQL по личным реквизитам (используя только bash и интерфейс bash) 

--pgAdmin у меня не установлен, поэтому читал инструкции к PostgreSQL Shell и писал код 
--https://www.postgresqltutorial.com/postgresql-tutorial/export-postgresql-table-to-csv-file/

psql -h 52.157.159.24 -U student28 -d sql_ex_for_student0
create table avocado(id NUMERIC(50), "Date" date, AveragePrice decimal, Total_Volume decimal, "4046" decimal, "4225" decimal, "4770" decimal, Total_Bags decimal, Small_Bags decimal, Large_Bags decimal, XLarge_Bags decimal, "type" varchar(500), "year" NUMERIC(4), "region" varchar(500)
COPY avocado FROM 'C:\avocado.csv' DELIMETER ',' CSV HEADER;
