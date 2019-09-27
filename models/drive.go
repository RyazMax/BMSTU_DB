package models

import (
	"time"

	"../database"
)

// Drive - struct with information about drive
type Drive struct {
	ID          int
	UserNumber  string
	CarNumber   string
	Departure   string
	Destination string
	DriveDate   time.Time
	Duration    time.Duration
	Price       string
}

func (d *Drive) Insert(db *database.DB) (err error) {
	_, err = db.Exec("INSERT INTO DRIVE(user_number,car_number,drive_date,duration,price,departure,destination) VALUES($1,$2,$3,$4,$5,$6,$7);",
		d.UserNumber, d.CarNumber, d.DriveDate, d.Duration, d.Price, d.Departure, d.Destination)
	return
}

func GenerateDrive() Drive {
	return Drive{}
}
