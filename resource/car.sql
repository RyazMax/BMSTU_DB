CREATE TYPE car_status AS ENUM (
    'BUSY',
    'READY',
    'OFFLINE'
);

CREATE TABLE IF NOT EXISTS CAR (
    cnumber varchar(10) NOT NULL PRIMARY KEY,
    driver_number varchar(30) NOT NULL REFERENCES DRIVER(driver_number),
    seats_count SMALLINT NOT NULL,
    mark varchar(20) NOT NULL,
    model varchar(20) NOT NULL,
    curr_status CAR_STATUS,
    curr_location geometry
);