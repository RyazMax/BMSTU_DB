CREATE TYPE car_status AS ENUM (
    'BUSY',
    'READY',
    'OFFLINE'
);

CREATE TABLE IF NOT EXISTS CAR (
    cnumber varchar(10) NOT NULL PRIMARY KEY,
    --driver_number varchar(30) NOT NULL REFERENCES DRIVER(driver_number),
    seats_count SMALLINT NOT NULL,
    mark varchar(20) NOT NULL,
    model varchar(20) NOT NULL,
    curr_status CAR_STATUS
    --curr_location geometry
);

CREATE TABLE IF NOT EXISTS "USER"  (
    pnumber varchar(30) NOT NULL PRIMARY KEY,
    first_name varchar(30) NOT NULL,
    second_name varchar(30) NOT NULL,
    patronymic varchar(30) NULL
);

CREATE TABLE IF NOT EXISTS DRIVER (
    driver_number varchar(30) NOT NULL PRIMARY KEY,
    first_name varchar(30) NOT NULL,
    patronymic varchar(30) NULL,
    last_name varchar(30) NOT NULL,
    rating INTEGER NOT NULL,
    car_number varchar(30) NOT NULL REFERENCES CAR(cnumber)
);

CREATE TABLE IF NOT EXISTS DRIVE (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    user_number VARCHAR(30) NOT NULL REFERENCES "USER"(pnumber),
    car_number VARCHAR(10) NOT NULL REFERENCES CAR(cnumber),
    drive_day TIMESTAMP WITH TIME ZONE NULL,
    duration INTERVAL,
    price MONEY
);