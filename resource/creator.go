package main

import (
	"io/ioutil"
	"log"
	"os"
	"strings"

	"github.com/jackc/pgx"
)

func initDB(connPool *pgx.ConnPool) error {
	dir, err := os.Open(".")
	if err != nil {
		log.Fatal(err)
		return err
	}

	files, err := dir.Readdirnames(-1)
	if err != nil {
		log.Fatal(err)
		return err
	}

	for _, val := range files {
		if !strings.HasSuffix(val, ".sql") {
			continue
		}
		pd, err := ioutil.ReadFile(val)
		if err != nil {
			log.Fatal(err)
			return err
		}
		_, err = connPool.Exec(string(pd))
		if err != nil {
			log.Fatal(err)
		}
	}
	log.Println("Inited")
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
	initDB(connPool)
}
