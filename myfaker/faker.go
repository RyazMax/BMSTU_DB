package myfaker

import (
	"math/rand"
	"strconv"
	"time"
	"unicode/utf8"
)

var (
	marks = [...]string{"Acura", "Alfa Romeo", "Aston Martin", "Audi", "Bentley", "BMW", "Bugatti", "Buick",
		"Opel", "Mazda", "Mercedes", "Lada", "Kia", "Honda", "Infinity", "Gelly"}
	letters = []string{"E", "T", "Y", "O", "P", "A", "H", "K", "X", "B", "M"}
)

func init() {
	rand.Seed(int64(time.Now().UnixNano()))
}

// MobilePhoneNumber - Generate mobile phone number
func MobilePhoneNumber(prefix string) string {
	len := utf8.RuneCountInString(prefix)
	for i := len; i < 11; i++ {
		prefix += strconv.Itoa(rand.Intn(10))
	}
	return prefix
}

// CarMark - Generate car mark and model
func CarMark() (mark string) {
	return marks[rand.Intn(len(marks))]
}

// CarModel - Generates model
func CarModel() string {
	res := letters[rand.Intn(len(letters))]
	if rand.Intn(2) == 0 {
		res += letters[rand.Intn(len(letters))]
	}
	res += strconv.Itoa(rand.Intn(10))
	res += strconv.Itoa(rand.Intn(10))
	if rand.Intn(2) == 0 {
		res += letters[rand.Intn(len(letters))]
	}
	if rand.Intn(2) == 0 {
		res += strconv.Itoa(rand.Intn(10))
	}
	return res
}

func SeatsCount() int {
	if rand.Intn(10) > 7 {
		return 4
	} else {
		return rand.Intn(4)*2 + 4
	}
}

// CarNumber - Generate car number
func CarNumber() string {
	res := letters[rand.Intn(len(letters))]
	for i := 0; i < 3; i++ {
		res += strconv.Itoa(rand.Intn(10))
	}
	res += letters[rand.Intn(len(letters))]
	res += letters[rand.Intn(len(letters))]
	res += " "
	res += strconv.Itoa(rand.Intn(200) + 1)
	return res
}

// CarStatus - Generate Car status(READY, BUSY, OFFLINE)
func CarStatus() string {
	arr := []string{"BUSY", "OFFLINE", "READY"}
	return arr[rand.Intn(3)]
}

// DriveDuration - Generate duration between a and b
func DriveDuration() time.Duration {
	arr := []time.Duration{time.Hour + time.Minute*32, 2*time.Hour + time.Minute*45, time.Minute * 52, time.Minute * 15}
	return arr[rand.Intn(len(arr))]
}

// DrivePrice - Generate price of drive between a and b
func DrivePrice(a, b int) string {
	return strconv.Itoa(rand.Intn(b-a) + a)
}
