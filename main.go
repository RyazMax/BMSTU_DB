package main

import (
	"log"
	"time"

	"./database"

	"./models"
)

// GenerateInfo describes structure of generating db i.e Number of entities
type GenerateInfo struct {
	UsersCount   int
	DriversCount int
	CarsCount    int
	DrivesCount  int
}

func generate(db *database.DB, info GenerateInfo) {
	// Добавление пользователей
	users := make(map[string]bool, 0)
	for i := 0; i < info.UsersCount; i++ {
		usr := models.GenerateUser()
		for _, exist := users[usr.Pnumber]; exist; {
			usr = models.GenerateUser()
		}
		usr.Insert(db)
	}

	// Добавление машин
	cars := make(map[string]bool, 0)
	for i := 0; i < info.CarsCount; i++ {
		car := models.GenerateCar()
		for _, exist := cars[car.Number]; exist; {
			car = models.GenerateCar()
		}
		car.Insert(db)
	}
}

func main() {
	db := database.CreateDB()
	usr := models.User{Fname: "Максим",
		Sname:      "Рязанов",
		Patronymic: "Отчество",
		Pnumber:    "+79063130227"}
	log.Println(usr.Insert(db))
	car := models.Car{Number: "a127pm",
		Mark:       "Lada",
		Model:      "2107",
		SeatsCount: 4,
		Status:     "OFFLINE"}
	log.Println(car.Insert(db))
	driver := models.Driver{Pnumber: "+79190203143",
		Fname:     "Валерий",
		Sname:     "Евтюхов",
		Rating:    3,
		CarNumber: "a127pm"}
	log.Println(driver.Insert(db))
	drive := models.Drive{UserNumber: usr.Pnumber,
		CarNumber:   car.Number,
		Departure:   "Москва Измайловский пр-т д 73/2",
		Destination: "Москва Рубцовская набережная 2",
		DriveDate:   time.Now(),
		Duration:    time.Hour * 2,
		Price:       "300",
	}
	log.Println(drive.Insert(db))
}
