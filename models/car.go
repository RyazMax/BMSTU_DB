package models

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
	Status     CarStatus
}
