package database

import (
	"database/sql"
	"fmt"
	_ "github.com/go-sql-driver/mysql"
	"html"
	"strings"
)

// Database provides functionalities for database interactions.
//
// Author: Mokter Hossain
// Email: mo@gglink.uk
// Website: www.gglink.uk
// GitHub: https://github.com/moktermd08
// LinkedIn: https://www.linkedin.com/in/mr-mokter/
// Twitter: https://twitter.com/moGGLink
//
type Database struct {
	Host       string
	User       string
	Password   string
	DBName     string
	Connection *sql.DB
}

// Connect establishes a database connection.
//
// It returns true on successful connection, false on failure
// and may return an error if connection to the database fails.
//
func (db *Database) Connect() (bool, error) {
	connString := fmt.Sprintf("%s:%s@tcp(%s)/%s", db.User, db.Password, db.Host, db.DBName)
	conn, err := sql.Open("mysql", connString)
	if err != nil {
		return false, err
	}

	db.Connection = conn

	return true, nil
}

// Disconnect closes the database connection.
//
// It returns true on success and false on failure.
//
func (db *Database) Disconnect() bool {
	if db.Connection != nil {
		err := db.Connection.Close()
		return err == nil
	}

	return false
}

// SanitizeInput sanitizes user input.
//
// It takes a string (user input data) and returns a sanitized version of that string.
//
func (db *Database) SanitizeInput(data string) string {
	data = strings.TrimSpace(data)
	data = strings.Replace(data, "\\", "\\\\", -1)
	data = html.EscapeString(data)

	if db.Connection != nil {
		data = db.Connection.Escape(data)
	}

	return data
}

// SanitizeOutput sanitizes output.
//
// It takes a string (the data to be sent to the client) and returns a sanitized version of that string.
//
func (db *Database) SanitizeOutput(data string) string {
	return html.EscapeString(data)
}

// MySQLDatabase is a concrete implementation of the Database struct for MySQL databases.
//
// You can implement methods specific to MySQLDatabase here.
// It embeds all methods from the Database struct.
//
type MySQLDatabase struct {
	Database
}

// Example usage:
// db := &database.MySQLDatabase{}
// db.Host = "localhost"
// db.User = "user"
// db.Password = "password"
// db.DBName = "database"
// connected, err := db.Connect()
// if err != nil {
// 	fmt.Println("Failed to connect to the database:", err)
// }
// fmt.Println("Connected:", connected)
// fmt.Println("Sanitized Input:", db.SanitizeInput("user' OR '1'='1"))
// db.Disconnect()
