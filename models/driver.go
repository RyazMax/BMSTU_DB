package models

import (
	"log"
	"math/rand"

	"../database"
	"../myfaker"
	"github.com/icrowley/fake"
)

// Driver - driver struct
type Driver struct {
	Pnumber    string
	Fname      string
	Sname      string
	Patronymic string
	Rating     float32
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
	if err != nil {
		log.Fatal(err)
	}
	return
}

func GenerateDriver() (d Driver) {
	if rand.Intn(2) == 0 {
		d.Fname = fake.MaleFirstName()
		d.Sname = fake.MaleLastName()
		d.Patronymic = fake.MalePatronymic()
	} else {
		d.Fname = fake.FemaleFirstName()
		d.Sname = fake.FemaleLastName()
		d.Patronymic = fake.FemalePatronymic()
	}
	d.Pnumber = myfaker.MobilePhoneNumber("8")
	d.Rating = rand.Float32() * 5
	return d
}
