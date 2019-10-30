-- ЛР2
-- 1. SELECT использующий предикат сравнения
-- Пользователи с длительностью поездки больше часа
SELECT distinct  u.*, d.duration from "USER" u
JOIN DRIVE d ON u.pnumber = d.user_number
WHERE d.duration > make_interval(hours => 1)
ORDER BY d.duration;  

-- 2. Инструкция SELECT, использующая предикат BETWEEN
-- Пользователи с поездкой стоимостью от 200 до 300р
SELECT distinct u.*, d.price from "USER" u
JOIN DRIVE d ON u.pnumber = d.user_number
WHERE d.price BETWEEN '200' AND '300'
ORDER BY d.price;

-- 3. Инструкция SELECT, использующая предикат LIKE.
-- Пользователи с номером начинающимся на 8906(Билайн)
SELECT distinct * FROM "USER"
WHERE pnumber LIKE '8906%'
ORDER BY pnumber;

-- 4. Инструкция SELECT, использующая предикат IN с вложенным подзапросом.
-- Список поездок совершенных на машинах из 64 региона
SELECT distinct d.* FROM DRIVE d
WHERE d.driver_number IN
(
    SELECT driver_number FROM DRIVER
    WHERE car_number LIKE '%64'
);

-- 5. Инструкция SELECT, использующая предикат EXISTS с вложенным подзапросом.
-- Пользователи которые ездили на 8 местном транспортном средстве
SELECT u.* FROM "USER" u
WHERE EXISTS (
    SELECT * FROM DRIVE d
    JOIN driver ON d.driver_number = driver.driver_number
    JOIN car ON cnumber = driver.car_number
    WHERE car.seats_count = 8
);

-- 6. Инструкция SELECT, использующая предикат сравнения с квантором.
-- ID, Стоимость и продолжительность поездок стоимость которых выше чем стоимость всех поездок до получаса
SELECT d.id, d.price, d.duration FROM drive d
WHERE d.price > ALL 
(
    SELECT price FROM drive
    WHERE duration < make_interval(mins => 30)
);

-- 7. Инструкция SELECT, использующая агрегатные функции в выражениях столбцов.
-- Подсчет средней стоимости минуты поездки
SELECT AVG(duration) 
FROM DRIVE;

-- 8. Инструкция SELECT, использующая скалярные подзапросы в выражениях столбцов.
-- Для каждого пользователя средняя и максимальная стоимость его поездок.
SELECT pnumber,
    (
        SELECT AVG(price::numeric)
        FROM DRIVE
        WHERE user_number = pnumber
    ) AS AvgPrice,
    (
        SELECT MAX(price)
        FROM DRIVE
        WHERE user_number = pnumber
    ) AS MaxPrice
FROM "USER";

-- 9. Инструкция SELECT, использующая простое выражение CASE.
-- Транспортные средства разделенные на категории по числу сидений
SELECT cnumber, model, mark, model,
    CASE(seats_count)
        WHEN 2 THEN 'ONE SEATED'
        WHEN 4 THEN 'NORMAL'
        WHEN 6 THEN 'BUSINESS'
        WHEN 8 THEN 'MICROBUS'
        WHEN 10 THEN 'BUS'
        ELSE 'UNKNOWN VEHICLE'
    END AS vehicle_type
FROM CAR;

-- 10. Инструкция SELECT, использующая поисковое выражение CASE.
-- Поездки разбитые на категории по стоимости
SELECT id, duration, 
    CASE   
        WHEN price < '200'  THEN 'CHEAP'
        WHEN price < '700'  THEN 'FAIR'
        WHEN price < '1500' THEN 'EXPENSIVE'
        ELSE 'VERY EXPENSIVE'
    END AS PRICE_CATEGORY
FROM DRIVE;

-- 11. Создание новой временной локальной таблицы из результирующего набора данных инструкции SELECT.
-- Сумма заработанная каждым водителем, и сохраненная в новую таблицу
SELECT d.driver_number, SUM(price) AS Salary
INTO Salaries
FROM Driver d
JOIN drive dr ON dr.driver_number = d.driver_number
GROUP BY d.driver_number;

-- 12. Инструкция SELECT, использующая вложенные коррелированные
-- подзапросы в качестве производных таблиц в предложении FROM.
-- Общая стоимость поездок для каждого пользователя
SELECT u.*, sumPrice  FROM "USER" u
JOIN 
    (
        SELECT user_number, SUM(price) AS sumPrice FROM DRIVE
        GROUP BY user_number
    ) D ON u.pnumber = d.user_number;

-- 13. Инструкция SELECT, использующая вложенные подзапросы с уровнем вложенности 3.
-- Машины всех водителей, рейтинг которых выше среднего
SELECT * FROM CAR
WHERE cnumber = 
    (  
        SELECT car_number FROM driver
        WHERE rating > 
            (
                SELECT AVG(rating)
                FROM driver
            ) AND car_number = cnumber
    );

-- 14. Инструкция SELECT, консолидирующая данные с помощью предложения GROUP BY, но без предложения HAVING.
-- Для каждого средняя и максимальная стоимость поездки, cредняя длительность и максимальная длительность
SELECT pnumber, AVG(price::numeric), MAX(price), AVG(duration), MAX(duration)
FROM "USER"
JOIN drive ON pnumber = drive.user_number
GROUP BY pnumber;

-- 15. Инструкция SELECT, консолидирующая данные с помощью предложения GROUP BY и предложения HAVING.
-- Выбрать всех водителей с средней стоимостью поездки больше средней по всем
SELECT d.driver_number, AVG(price::numeric) FROM DRIVER d
JOIN DRIVE dr ON d.driver_number = dr.driver_number
GROUP BY d.driver_number
HAVING AVG(dr.price::numeric) > 
(
    SELECT AVG(price::numeric) as avPrice
    FROM drive
);

-- 16. Однострочная инструкция INSERT, выполняющая вставку в таблицу одной строки значений.
-- Добавление поездки
INSERT INTO DRIVE (user_number, driver_number, duration, price, departure, destination)
VALUES ('85956181524', '89379407709', make_interval(hours => 2), '250', 'Cосновая улица', 'Березовая улица');

-- 17. Многострочная инструкция INSERT, выполняющая вставку в таблицу результирующего 
-- набора данных вложенного подзапроса.
INSERT INTO DRIVE (user_number, driver_number, duration, price, departure, destination)
VALUES ('85956181524', '89379407709', make_interval(hours => 2), 
    (SELECT MAX(price) FROM drive), 'Cосновая улица', 'Березовая улица');

-- 18. Простая инструкция UPDATE.
-- Обновление рейтинга водителя
UPDATE DRIVER
SET rating = rating + 0.2
WHERE driver_number = '89379407709';

-- 19. Инструкция UPDATE со скалярным подзапросом в предложении SET.
-- Обновить значение рейтинга водителя минимальным рейтиногом выше 2
UPDATE DRIVER 
SET rating = 
(
    SELECT MIN(rating)
    FROM DRIVER
    WHERE rating > 2
)
WHERE driver_number = '89379407709';

-- 20. Простая инструкция DELETE.
-- Удаление поездки по ID
DELETE FROM DRIVE 
WHERE ID = 5;

-- 21. Инструкция DELETE с вложенным коррелированным подзапросом в предложении WHERE.
-- Удаление всех поездок у которых у водителя машина с номерами 63 региона
DELETE FROM DRIVE 
WHERE driver_number IN 
    (
        SELECT driver_number FROM DRIVER
        WHERE car_number LIKE '%63'
    );

-- 22. Инструкция SELECT, использующая простое обобщенное табличное 
-- Среднее число поездок
WITH TMP(driver_number, drives_number) 
AS
(
    SELECT d.driver_number, COUNT(dr.id)
    FROM DRIVER d
    JOIN DRIVE dr ON d.driver_number = dr.driver_number
    GROUP BY d.driver_number
)
SELECT AVG(drives_number) AS AverageDrives
FROM TMP;

-- 23. Инструкция SELECT, использующая рекурсивное табличное представление
-- Выбираем всех пользователей которые ездили с теми же водителями, что и пользователь с заданным номером
WITH RECURSIVE REC AS (
    SELECT u.pnumber, d.driver_number FROM "USER" u
    JOIN drive dr ON dr.user_number = u.pnumber
    JOIN driver d ON dr.driver_number = d.driver_number
    WHERE u.pnumber = '88590183337'

    UNION

    SELECT u.pnumber, dr.driver_number FROM rec r
    JOIN drive dr ON dr.driver_number = r.driver_number
    JOIN "USER" u ON dr.user_number = u.pnumber
)
SELECT * FROM REC;

-- 24. Оконные функции. Использование конструкций MIN/MAX/AVG OVER()
-- Вывести информацию о поездки и среднюю продолжительность для того же водителя и пользователя
SELECT id, price, duration, AVG(duration) OVER (PARTITION BY user_number) AS AvgUserDuration,
          AVG(duration) OVER (PARTITION BY driver_number) AS AvgDriverDuration
FROM DRIVE;

-- 25. Оконные фнкции для устранения дублей
-- Имена
SELECT * FROM (
    SELECT row_number() OVER (partition by first_name) AS n, first_name
    FROM "USER"
) T WHERE n = 1;
