--                                             QUERY PLAN

-- --------------------------------------------------------------------------------
-- ------------------
--  Seq Scan on human  (cost=0.00..49.56 rows=1 width=110) (actual time=0.013..0.13
-- 4 rows=4 loops=1)
--    Filter: (name = 'Human n+1'::text)
--    Rows Removed by Filter: 1001
--  Planning Time: 0.096 ms
--  Execution Time: 0.147 ms
-- (5 строк)

-- db_coursework=# create index on human (name);
-- CREATE INDEX
-- db_coursework=# explain analyze select * from human where name = 'Human n+1';
--                                                        QUERY PLAN

-- --------------------------------------------------------------------------------
-- ----------------------------------------
--  Index Scan using human_name_idx on human  (cost=0.28..8.29 rows=1 width=110) (a
-- ctual time=0.014..0.015 rows=4 loops=1)
--    Index Cond: (name = 'Human n+1'::text)
--  Planning Time: 0.115 ms
--  Execution Time: 0.024 ms
-- (4 строки)

CREATE INDEX ON human (name);

--                                               QUERY PLAN

-- --------------------------------------------------------------------------------
-- -----------------------
--  Seq Scan on tournament  (cost=0.00..1.31 rows=25 width=85) (actual time=0.011..
-- 0.013 rows=14 loops=1)
--    Filter: (place = 'Улица Пушкина, дом Колотушкина'::text)
--    Rows Removed by Filter: 11
--  Planning Time: 0.055 ms
--  Execution Time: 0.023 ms
-- (5 строк)

-- db_coursework=# create index on tournament (place);
-- CREATE INDEX
-- db_coursework=# explain analyze select * from tournament where place = 'Улица Пушкина, дом Колотушкина';
--                                               QUERY PLAN

-- --------------------------------------------------------------------------------
-- -----------------------
--  Seq Scan on tournament  (cost=0.00..1.31 rows=14 width=68) (actual time=0.009..
-- 0.011 rows=14 loops=1)
--    Filter: (place = 'Улица Пушкина, дом Колотушкина'::text)
--    Rows Removed by Filter: 11
--  Planning Time: 0.184 ms
--  Execution Time: 0.021 ms
-- (5 строк)

-- Делать индекс на place -- не лучший выбор, т.к. время планирования увеличивается,
-- а производительность -- нет (и сам индекс не используется)
