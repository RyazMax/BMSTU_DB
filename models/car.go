package models

import (
	"log"

	"github.com/icrowley/fake"

	"../database"
	"../myfaker"
)

// CarStatus - enumeration of possible car statuses
type CarStatus int

const (
	// BUSY - Car is busy and unable to get order
	BUSY CarStatus = 1
	// READY - Car is ready to get new order
	READY CarStatus = 2
	// OFFLINE - Car is offline and can not get new order
	OFFLINE CarStatus = 3
)

type Location struct {
	Latitude  float32
	Longitude float32
}

// Car - struct with car fields
type Car struct {
	Number       string
	Mark         string
	Model        string
	SeatsCount   int
	Status       string
	CurrLocation Location
}

// Insert - inserts car in database
func (c *Car) Insert(db *database.DB) (err error) {
	_, err = db.Exec("INSERT INTO CAR(cnumber,seats_count,mark,model,curr_status, curr_location) VALUES($1,$2,$3,$4,$5, point($6,$7));",
		c.Number, c.SeatsCount, c.Mark, c.Model, c.Status, c.CurrLocation.Longitude, c.CurrLocation.Latitude)
	if err != nil {
		log.Fatal(err)
	}
	return
}

// GenerateCar - generates Car
func GenerateCar() (c Car) {
	c.Number = myfaker.CarNumber()
	c.Mark = myfaker.CarMark()
	c.Model = myfaker.CarModel()
	c.Status = myfaker.CarStatus()
	c.SeatsCount = myfaker.SeatsCount()
	c.CurrLocation = Location{Longitude: fake.Longitude(), Latitude: fake.Latitude()}
	return
}
