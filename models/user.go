package models

import "../database"

// User - user struct
type User struct {
	Fname      string
	Sname      string
	Patronymic string
	Pnumber    string
}

// Insert - inserts user in database
func (u *User) Insert(db *database.DB) (err error) {
	if u.Patronymic != "" {
		_, err = db.Exec("INSERT INTO \"USER\"(pnumber,first_name,second_name,patronymic) VALUES($1,$2,$3,$4);",
			u.Pnumber, u.Fname, u.Sname, u.Patronymic)
	} else {
		_, err = db.Exec("INSERT INTO \"USER\"(pnumber,first_name,second_name) VALUES($1,$2,$3);",
			u.Pnumber, u.Fname, u.Sname)
	}
	return
}

// GenerateUser - randomly generate user info
func GenerateUser() User {
	return User{}
}
