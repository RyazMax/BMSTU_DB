CREATE TABLE IF NOT EXISTS DRIVE (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    user_number VARCHAR(30) NOT NULL REFERENCES "USER"(pnumber),
    car_number VARCHAR(10) NOT NULL REFERENCES CAR(cnumber),
    drive_day TIMESTAMP WITH TIME ZONE NULL,
    duration INTERVAL,
    price MONEY
)