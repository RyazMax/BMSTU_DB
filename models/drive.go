package models

import "time"

// Drive - struct with information about drive
type Drive struct {
	ID         int
	UserNumber string
	CarNumber  string
	DriveDay   time.Time
	Duration   time.Duration
	Price      int
}
