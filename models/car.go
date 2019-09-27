package models

import "../database"

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

// Car - struct with car fields
type Car struct {
	Number     string
	Mark       string
	Model      string
	SeatsCount int
	Status     string
}

// Insert - inserts car in database
func (c *Car) Insert(db *database.DB) (err error) {
	_, err = db.Exec("INSERT INTO CAR(cnumber,seats_count,mark,model,curr_status) VALUES($1,$2,$3,$4,$5);",
		c.Number, c.SeatsCount, c.Mark, c.Model, c.Status)
	return
}

func GenerateCar() Car {
	return Car{}
}
