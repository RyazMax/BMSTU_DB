package main

import (
	"io/ioutil"
	"log"
	"os"

	"github.com/jackc/pgx"
)

func execFile(fileName string, connPool *pgx.ConnPool) error {

	pd, err := ioutil.ReadFile(fileName)
	if err != nil {
		log.Fatal(err)
		return err
	}
	_, err = connPool.Exec(string(pd))
	if err != nil {
		log.Fatal(err)
	}
	log.Println("DONE")
	return nil
}

func main() {
	connPool, err := pgx.NewConnPool(pgx.ConnPoolConfig{
		ConnConfig: pgx.ConnConfig{
			Host:     "localhost",
			Port:     5432,
			User:     "max",
			Password: "pass",
			Database: "DB_CURSE_TAXI",
		},
		MaxConnections: 50,
	})
	if err != nil {
		log.Fatal(err)
	}

	execFile(os.Args[1], connPool)
}
