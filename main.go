package main

import (
	"log"

	"./database"
	"github.com/icrowley/fake"

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
	const QUANT = 20

	users := make(map[string]bool, 0)
	userNumbers := make([]string, 0, info.UsersCount)
	for i := 0; i < info.UsersCount; i++ {
		usr := models.GenerateUser()
		for _, exist := users[usr.Pnumber]; exist; {
			usr = models.GenerateUser()
		}
		users[usr.Pnumber] = true
		userNumbers = append(userNumbers, usr.Pnumber)
		usr.Insert(db)
		if i%QUANT == 0 {
			log.Println("USERS ", i, " added")
		}
	}

	// Добавление машин
	cars := make(map[string]bool, 0)
	carsNumbers := make([]string, 0, info.CarsCount)
	for i := 0; i < info.CarsCount; i++ {
		car := models.GenerateCar()
		for _, exist := cars[car.Number]; exist; {
			car = models.GenerateCar()
		}
		cars[car.Number] = true
		carsNumbers = append(carsNumbers, car.Number)
		car.Insert(db)
		if i%QUANT == 0 {
			log.Println("CAR ", i, " added")
		}
	}

	// Добавление водителей
	drivers := make(map[string]bool, 0)
	driverNumbers := make([]string, 0, info.DriversCount)
	for i := 0; i < info.DriversCount; i++ {
		driver := models.GenerateDriver()
		for _, exist := drivers[driver.Pnumber]; exist; {
			driver = models.GenerateDriver()
		}
		drivers[driver.Pnumber] = true
		driverNumbers = append(driverNumbers, driver.Pnumber)
		driver.CarNumber = carsNumbers[i]
		driver.Insert(db)
		if i%QUANT == 0 {
			log.Println("DRIVER ", i, " added")
		}
	}

	// Добавление поездки
	for i := 0; i < info.DrivesCount; i++ {
		drive := models.GenerateDrive()
		drive.UserNumber = userNumbers[i]
		drive.DriverNumber = driverNumbers[i]
		drive.Insert(db)
		if i%QUANT == 0 {
			log.Println("DRIVE ", i, " added")
		}
	}
}

func main() {
	fake.SetLang("ru")
	db := database.CreateDB()
	generate(db, GenerateInfo{UsersCount: 1000, CarsCount: 1000, DriversCount: 1000, DrivesCount: 1000})
}
