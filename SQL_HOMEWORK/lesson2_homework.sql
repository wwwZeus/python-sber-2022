--����� ��: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

-- ������� 1: ������� name, class �� ��������, ���������� ����� 1920
--
select
    name, class
from ships s
where s.launched > 1920

-- ������� 2: ������� name, class �� ��������, ���������� ����� 1920, �� �� ������� 1942
--
select
    t.name, t.class
from ships t
where t.launched > 1920
      and t.launched < 1942
      
-- ������� 3: ����� ���������� �������� � ������ ������. ������� ���������� � class
--
select
   c.class, count(t.name)
from ships t
join classes c on t.class = c.class
group by c.class

-- ������� 4: ��� ������� ��������, ������ ������ ������� �� ����� 16, ������� ����� � ������. (������� classes)
--
select
  t.class, t.country
from classes t
where t.bore >= 16

-- ������� 5: ������� �������, ����������� � ��������� � �������� ��������� (������� Outcomes, North Atlantic). �����: ship.
--
select t.ship
from outcomes t
where t.battle = 'North Atlantic' 
      and t.result = 'sunk'

-- ������� 6: ������� �������� (ship) ���������� ������������ �������
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
-- ������� 7: ������� �������� ������� (ship) � ����� (class) ���������� ������������ �������
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
-- ������� 8: ������� ��� ����������� �������, � ������� ������ ������ �� ����� 16, � ������� ���������. �����: ship, class
--
select
  t.ship, c.bore
from outcomes t
left join ships s on s.name = t.ship
left join classes c on c.class = s.class
where 
  t."result" = 'sunk' and c.bore >= 16
  
-- ������� 9: ������� ��� ������ ��������, ���������� ��� (������� classes, country = 'USA'). �����: class
--
select
  t.class
from classes t
where t.country = 'USA'

-- ������� 10: ������� ��� �������, ���������� ��� (������� classes & ships, country = 'USA'). �����: name, class
select
  s.name, t."class"
from classes t
join ships s on s.class = t."class"
where t.country = 'USA'