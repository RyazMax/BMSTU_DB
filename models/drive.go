package models

import (
	"log"
	"time"

	"github.com/icrowley/fake"

	"../database"
	"../myfaker"
)

// Drive - struct with information about drive
type Drive struct {
	ID           int
	UserNumber   string
	DriverNumber string
	Departure    string
	Destination  string
	DriveDate    time.Time
	Duration     time.Duration
	Price        string
}

func (d *Drive) Insert(db *database.DB) (err error) {
	_, err = db.Exec("INSERT INTO DRIVE(user_number,driver_number,drive_date,duration,price,departure,destination) VALUES($1,$2,$3,$4,$5,$6,$7);",
		d.UserNumber, d.DriverNumber, d.DriveDate, d.Duration, d.Price, d.Departure, d.Destination)
	if err != nil {
		log.Fatal(err)
	}
	return
}

func GenerateDrive() (d Drive) {
	d.Departure = fake.StreetAddress()
	d.Destination = fake.StreetAddress()
	d.DriveDate = time.Now()
	d.Price = myfaker.DrivePrice(45, 2000)
	d.Duration = myfaker.DriveDuration()
	return
}
