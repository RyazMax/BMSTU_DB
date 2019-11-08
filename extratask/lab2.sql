-- Создать таблицы:
-- Table1{id: integer, var1: string, valid_from_dttm: date, valid_to_dttm: date}
-- Table2{id: integer, var2: string, valid_from_dttm: date, valid_to_dttm: date}
-- Версионность в таблицах непрерывная, разрывов нет (если valid_to_dttm = '2018-09-05', то
-- для следующей строки соответсвующего ID valid_from_dttm = '2018-09-06', т.е. на день
-- больше). Для каждого ID дата начала версионности и дата конца версионности в Table1 и
-- Table2 совпадают.
 --Выполнить версионное соединение двух талиц по полю id.

CREATE TABLE IF NOT EXISTS table1 (
    id integer,
    var1 varchar,
    valid_from date,
    valid_to date
);

CREATE TABLE IF NOT EXISTS table2 (
    id integer,
    var2 varchar,
    valid_from date,
    valid_to date
);

-- Первый кейс (Пересечение по концу интервала)
--Первая табица
INSERT INTO table1(id, var1, valid_from, valid_to) 
VALUES (1, 'A', '2018-09-01', '2018-09-15');
INSERT INTO table1(id, var1, valid_from, valid_to) 
VALUES (1, 'B', '2018-09-16', '5999-12-31');
-- Вторая таблица
INSERT INTO table2(id, var2, valid_from, valid_to) 
VALUES (1, 'A', '2018-09-01', '2018-09-18');
INSERT INTO table2(id, var2, valid_from, valid_to) 
VALUES (1, 'B', '2018-09-19', '5999-12-31');

--Второй кейс (Пересечение по началу и концу интервала)
--Первая таблица
INSERT INTO table1(id, var1, valid_from, valid_to)
VALUES (2, 'A', '2018-09-01', '2018-09-15');
INSERT INTO table1(id, var1, valid_from, valid_to)
VALUES (2, 'B', '2018-09-16', '5999-12-31');
--Вторая таблица
INSERT INTO table2(id, var2, valid_from, valid_to)
VALUES (2, 'A', '2018-09-01', '2018-09-13');
INSERT INTO table2(id, var2, valid_from, valid_to)
VALUES (2, 'B', '2018-09-14', '2018-09-20');
INSERT INTO table2(id, var2, valid_from, valid_to)
VALUES (2, 'A', '2018-09-21', '5999-12-31');

-- Третий кейс (Пересечение по началу интервала)
-- Первая таблица
INSERT INTO table1(id, var1, valid_from, valid_to)
VALUES (3, 'A', '2018-09-01', '2018-09-15');
INSERT INTO table1(id, var1, valid_from, valid_to)
VALUES (3, 'B', '2018-09-16', '5999-12-31');
--Вторая таблица
INSERT INTO table2(id, var2, valid_from, valid_to)
VALUES (3, 'A', '2018-09-01', '2018-09-13');
INSERT INTO table2(id, var2, valid_from, valid_to)
VALUES (3, 'B', '2018-09-14', '5999-12-31');

-- Четвертый кейс (Cовпадение интервалов)
-- Первая таблица
INSERT INTO table1(id, var1, valid_from, valid_to)
VALUES (4, 'A', '2018-09-01', '2018-09-15');
INSERT INTO table1(id, var1, valid_from, valid_to)
VALUES (4, 'B', '2018-09-16', '5999-12-31');
--Вторая таблица
INSERT INTO table2(id, var2, valid_from, valid_to)
VALUES (4, 'A', '2018-09-01', '2018-09-15');
INSERT INTO table2(id, var2, valid_from, valid_to)
VALUES (4, 'B', '2018-09-16', '5999-12-31');

-- Пятый кейс (Пересечение в 1 день)
-- Первая таблица
INSERT INTO table1(id, var1, valid_from, valid_to)
VALUES (5, 'A', '2018-09-01', '2018-09-15');
INSERT INTO table1(id, var1, valid_from, valid_to)
VALUES (5, 'B', '2018-09-16', '5999-12-31');
-- Вторая таблица
INSERT INTO table2(id, var2, valid_from, valid_to)
VALUES (5, 'A', '2018-09-01', '2018-09-14');
INSERT INTO table2(id, var2, valid_from, valid_to)
VALUES (5, 'B', '2018-09-15', '5999-12-31');


SELECT t1.id, var1, var2, 
GREATEST(t1.valid_from, t2.valid_from) AS valid_from,
LEAST(t1.valid_to, t2.valid_to) AS valid_to
FROM table1 AS t1
JOIN table2 AS t2
ON t1.id = t2.id
WHERE GREATEST(t1.valid_from, t2.valid_from) <= LEAST(t1.valid_to, t2.valid_to);