package models

import "../database"

// Driver - driver struct
type Driver struct {
	Pnumber    string
	Fname      string
	Sname      string
	Patronymic string
	Rating     int
	CarNumber  string
}

// Insert - inserts driver in database
func (d *Driver) Insert(db *database.DB) (err error) {
	if d.Patronymic != "" {
		_, err = db.Exec("INSERT INTO DRIVER(driver_number,first_name,second_name,patronymic,rating,car_number) VALUES($1,$2,$3,$4,$5,$6);",
			d.Pnumber, d.Fname, d.Sname, d.Patronymic, d.Rating, d.CarNumber)
	} else {
		_, err = db.Exec("INSERT INTO DRIVER(driver_number,first_name,second_name,rating,car_number) VALUES($1,$2,$3,$4,$5);",
			d.Pnumber, d.Fname, d.Sname, d.Rating, d.CarNumber)
	}
	return
}

func GenerateDriver() Driver {
	return Driver{}
}
