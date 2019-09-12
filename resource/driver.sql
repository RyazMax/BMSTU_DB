CREATE TABLE IF NOT EXISTS DRIVER (
    driver_number varchar(30) NOT NULL PRIMARY KEY,
    first_name varchar(30) NOT NULL,
    patronymic varchar(30) NULL,
    last_name varchar(30) NOT NULL,
    rating INTEGER NOT NULL
)