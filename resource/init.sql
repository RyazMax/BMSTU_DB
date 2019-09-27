CREATE EXTENSION IF NOT EXISTS cube;
CREATE EXTENSION IF NOT EXISTS earthdistance;

CREATE TYPE car_status AS ENUM (
    'BUSY',
    'READY',
    'OFFLINE'
);

CREATE TABLE IF NOT EXISTS CAR (
    cnumber varchar(10) NOT NULL PRIMARY KEY,
    seats_count SMALLINT NOT NULL CHECK(seats_count > 3 AND seats_count < 20),
    mark varchar(20) NOT NULL,
    model varchar(20) NOT NULL,
    curr_status CAR_STATUS,
    curr_location point
);

CREATE TABLE IF NOT EXISTS "USER"  (
    pnumber varchar(30) NOT NULL PRIMARY KEY,
    first_name varchar(30) NOT NULL,
    second_name varchar(30) NOT NULL,
    patronymic varchar(30) NULL DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS DRIVER (
    driver_number varchar(30) NOT NULL PRIMARY KEY,
    first_name varchar(30) NOT NULL,
    patronymic varchar(30) NULL DEFAULT NULL,
    second_name varchar(30) NOT NULL,
    rating FLOAT NOT NULL CHECK(rating >= 0 AND rating <=5),
    car_number varchar(30) NOT NULL REFERENCES CAR(cnumber)
);

CREATE TABLE IF NOT EXISTS DRIVE (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    user_number VARCHAR(30) NOT NULL REFERENCES "USER"(pnumber),
    driver_number VARCHAR(30) NOT NULL REFERENCES Driver(driver_number),
    drive_date TIMESTAMP WITH TIME ZONE CHECK(drive_date <= current_timestamp) DEFAULT current_timestamp,
    duration INTERVAL,
    price MONEY,
    departure TEXT,
    destination TEXT
);