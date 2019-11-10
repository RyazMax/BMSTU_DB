-- Скалярная функция
-- Средня цена поездок для пользователя (номер для тестирования 85956181524)
CREATE FUNCTION avg_price_by_user(phone varchar) RETURNS money AS $$
    SELECT (avg(price::numeric)::money) FROM DRIVE
    JOIN "USER" ON user_number = pnumber
    WHERE pnumber = phone; 
$$ LANGUAGE SQL;

-- Подставляiемая табличная функция
-- Сумарный заработок каждого водителя
CREATE FUNCTION get_salaries() RETURNS TABLE(number varchar, salary money) AS $$
    SELECT d.driver_number, SUM(price) AS Salary
    FROM Driver d
    JOIN drive dr ON dr.driver_number = d.driver_number
    GROUP BY d.driver_number;
$$ LANGUAGE SQL;


-- Многоператорная табличная функция
-- Информация о водителях с рейтингом выше r
DROP TABLE IF EXISTS driver_info;
CREATE TABLE IF NOT EXISTS driver_info (
    number varchar,
    first_name varchar,
    second_name varchar,
    patronymic varchar,
    rating float,
    car_mark varchar,
    car_model varchar
);

CREATE FUNCTION get_driver_info(r float)
RETURNS TABLE(number varchar, first_name varchar, second_name varchar, patronymic varchar, rating float,
car_mark varchar, car_model varchar) as $$
    INSERT into driver_info
    (number, first_name, second_name, patronymic, rating, car_mark, car_model)
    SELECT driver_number, first_name, second_name, patronymic, rating, mark, model
    FROM driver
    JOIN car ON car_number = cnumber
    WHERE rating > r;

    SELECT * FROM driver_info
    WHERE rating > r;
$$ language sql; 

-- Функция с рекурсивным OTB
-- Выбираем всех пользователей которые ездили с теми же водителями, что и пользователь с заданным номером
CREATE FUNCTION same_drivers(phone varchar) RETURNS
TABLE (user_number varchar, driver_number varchar) AS $$
WITH RECURSIVE REC AS (
    SELECT u.pnumber, d.driver_number FROM "USER" u
    JOIN drive dr ON dr.user_number = u.pnumber
    JOIN driver d ON dr.driver_number = d.driver_number
    WHERE u.pnumber = phone

    UNION

    SELECT u.pnumber, dr.driver_number FROM rec r
    JOIN drive dr ON dr.driver_number = r.driver_number
    JOIN "USER" u ON dr.user_number = u.pnumber
)
SELECT * FROM REC;
$$ LANGUAGE SQL;

select * from same_drivers('85956181524');

-- Хранимая процедура
-- Увеличение рейтинга водителей с рейтингом ниже r на delta 
CREATE FUNCTION inc_with_rating(r float, delta float) RETURNS VOID AS $$
    UPDATE DRIVER
    SET rating = rating + delta
    WHERE rating < r;
$$ LANGUAGE SQL;

-- Рекурсивная хранимая процедура или процедура с рекурсивным ОТВ
-- Создание таблицы с пользователями, у которых есть поездки с теми же водителями
CREATE FUNCTION create_same_drivers(phone varchar) RETURNS
VOID AS $$
WITH RECURSIVE REC AS (
    SELECT u.pnumber, d.driver_number FROM "USER" u
    JOIN drive dr ON dr.user_number = u.pnumber
    JOIN driver d ON dr.driver_number = d.driver_number
    WHERE u.pnumber = phone

    UNION

    SELECT u.pnumber, dr.driver_number FROM rec r
    JOIN drive dr ON dr.driver_number = r.driver_number
    JOIN "USER" u ON dr.user_number = u.pnumber
)
select * 
INTO with_same_driver
FROM rec;
$$ LANGUAGE SQL;

-- Хранимая процедура с курсором
-- Вывести всех водителей с рейтингом выше point
create or replace function list_who_more(point_ float) RETURNS VOID
language plpgsql as $$
declare
	cur cursor
	for select
	driver_number, first_name, second_name, rating 
	from driver
	where rating > point_;
	row record;
begin
	open cur;
	loop
		fetch cur into row;
		exit when not found;
		raise notice '(number = %) { % % } { rating =  % }',
		row.driver_number, row.first_name, row.second_name, row.rating;
	end loop;
	close cur;
end;
$$;


-- Хранимая процедура доступа к метаданным
create or replace FUNCTION table_size_list() RETURNS VOID as $$
declare
cur cursor
for select
table_name, size
from (
select table_name,
pg_relation_size(cast(table_name as varchar)) as size
from information_schema.tables
where table_schema not in ('information_schema','pg_catalog') AND table_name != 'USER'
order by size desc
) as tmp;
row record;
begin
open cur;
loop
fetch cur into row;
exit when not found;
raise notice '{ table : % } { size : % }',
row.table_name, row.size;
end loop;
close cur;
end;
$$ language plpgsql;

-- Триггер AFTER
-- Обновление таблицы salaries при добавлении новой поездки
CREATE OR REPLACE FUNCTION inc_salary() RETURNS trigger AS $$
BEGIN
    UPDATE salaries
    SET salary = salary + NEW.price
    WHERE driver_number = NEW.driver_number;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_drive_add
AFTER INSERT ON drive
    FOR EACH ROW EXECUTE PROCEDURE inc_salary();

INSERT INTO DRIVE(user_number, dirver_number, duration, price, departure, destination) VALUES('85956181524','80729725651'
,make_interval(hours => 2),'250', 'Пр-т Ленина', 'Пр-т Кирова');

-- Tриггер INSTEAD OF
-- Добавление данных о поездке через view drive_info

CREATE VIEW drive_info AS 
SELECT d.id, d.price, d.duration,d.drive_date, d.departure, d.destination,
u.first_name AS user_firstname, u.second_name AS user_secondname, u.patronymic AS user_patronymic, 
dr.first_name AS driver_firstname, dr.second_name AS driver_secondname, dr.patronymic AS driver_patronymic
FROM drive d
JOIN driver dr ON d.driver_number = dr.driver_number
JOIN "USER" u ON u.pnumber = d.user_number;

CREATE OR REPLACE FUNCTION insert_in_driver_info() RETURNS TRIGGER as $$
DECLARE
    u_number varchar;
    d_number varchar;
BEGIN 
    SELECT pnumber FROM "USER"
    INTO u_number
        WHERE first_name = NEW.user_firstname AND
        second_name = NEW.user_secondname AND
        patronymic = NEW.user_patronymic
    LIMIT 1;

    SELECT driver_number FROM driver
    INTO d_number
    WHERE first_name = NEW.driver_firstname AND
          second_name = NEW.driver_secondname AND
          patronymic = NEW.driver_patronymic
    LIMIT 1;

    IF u_number IS NOT NULL AND d_number IS NOT NULL THEN
    INSERT INTO drive(price, duration, drive_date, departure, destination, user_number, driver_number) VALUES
    (NEW.price, NEW.duration, NEW.drive_date, NEW.departure, NEW.destination, u_number, d_number);
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql; 

DROP TRIGGER on_drive_info;

CREATE TRIGGER on_drive_info
INSTEAD OF Insert ON driver_into
    FOR EACH ROW EXECUTE PROCEDURE insert_in_driver_info();

INSERT INTO driver_into(price, duration, drive_date, departure, destination, user_firstname, user_secondname,
user_patronymic, driver_firstname, driver_secondname, driver_patronymic) VALUES
('322', make_interval(hours=>1), now(), 'Дом', 'Работа', 'Ольга', 'Осипова', 'Анатольевна', 'Зоя', 'Леонтьева', 'Архиповна');