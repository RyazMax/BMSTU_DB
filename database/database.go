package database

import (
	"log"

	"github.com/jackc/pgx"
)

// DB - wrapper on connPool
type DB struct {
	connPool *pgx.ConnPool
}

// CreateDB - connects to database
func CreateDB() *DB {
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
	return &DB{connPool}
}

// Exec - wrapper on standart Query Execution
func (d *DB) Exec(sql string, args ...interface{}) (pgx.CommandTag, error) {
	return d.connPool.Exec(sql, args...)
}
