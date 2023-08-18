<?php

namespace GGlink\Database;

use mysqli;
use Exception;

/**
 * Class Database
 *
 * Provides functionalities for database interactions.
 *
 * @author Mokter Hossain
 * @email mo@gglink.uk
 * @website www.gglink.uk
 * @github https://github.com/moktermd08
 * @linkedin https://www.linkedin.com/in/mr-mokter/
 * @twitter https://twitter.com/moGGLink
 * 
 * @package GGlink\Database
 */
class Database
{
    
    private string $host = "localhost";         // @var string Database host name
    private string $user = "user";             //  @var string Database user name
    private string $password = "password";     //  @var string Database password
    private string $database = "database";     //  @var string Name of the database to connect to
    private ?mysqli $connection = null;        //  @var mysqli|null Database connection object

    /**
     * Connect to the database.
     *
     * @return bool true if connection is successful
     * @throws Exception If connection fails
     */
    public function connect(): bool
    {
        // Create a new mysqli object to establish a connection
        $this->connection = new mysqli($this->host, $this->user, $this->password, $this->database);
        
        // Check for connection errors and throw an exception if any
        if ($this->connection->connect_error) {
            throw new Exception("Failed to connect to the database: " . $this->connection->connect_error);
        }
        
        return true;
    }

    /**
     * Disconnect from the database.
     *
     * @return bool true if disconnection is successful, false otherwise
     */
    public function disconnect(): bool
    {
        // Close the existing database connection if any
        if ($this->connection) {
            return $this->connection->close();
        }
        
        return false;
    }

    /**
     * Execute a generic query on the database.
     *
     * @param string $sql The SQL query string
     * @return mixed The result of the query
     * @throws Exception If the query fails
     */
    public function query(string $sql)
    {
        // Sanitize and execute the SQL query
        $result = $this->connection->query($this->sanitizeInput($sql));
        
        // Check for query errors and throw an exception if any
        if ($result === false) {
            throw new Exception("Failed to execute query: " . $this->connection->error);
        }

        return $result;
    }

    /**
     * Select records from a table.
     *
     * @param string $table The name of the table to select from
     * @param string $rows The columns to select
     * @param string|null $where The WHERE clause
     * @param string|null $order The ORDER BY clause
     * @param int|null $limit The LIMIT clause
     * @return mixed The result of the select query
     */
    public function select(string $table, string $rows = '*', string $where = null, string $order = null, int $limit = null)
    {
        // Construct the SELECT SQL query
        $sql = "SELECT $rows FROM $table";
        if ($where != null) {
            $sql .= " WHERE $where";
        }
        if ($order != null) {
            $sql .= " ORDER BY $order";
        }
        if ($limit != null) {
            $sql .= " LIMIT $limit";
        }
        
        return $this->query($sql);
    }

    /**
     * Insert records into a table.
     *
     * @param string $table The name of the table to insert into
     * @param array $values The values to insert
     * @param array|null $columns The columns to insert values into
     * @return mixed The result of the insert query
     */
    public function insert(string $table, array $values, array $columns = null)
    {
        // Construct the INSERT SQL query
        $sql = "INSERT INTO $table";
        if ($columns != null) {
            $columns = implode(", ", $columns);
            $sql .= " ($columns)";
        }
        $values = implode("', '", $this->sanitizeInputArray($values));
        $sql .= " VALUES ('$values')";
        
        return $this->query($sql);
    }

    /**
     * Update records in a table.
     *
     * @param string $table The name of the table to update
     * @param string $set The SET clause
     * @param string|null $where The WHERE clause
     * @return mixed The result of the update query
     */
    public function update(string $table, string $set, string $where = null)
    {
        // Construct the UPDATE SQL query
        $sql = "UPDATE $table SET $set";
        if ($where != null) {
            $sql .= " WHERE $where";
        }
        
        return $this->query($sql);
    }

    /**
     * Delete records from a table.
     *
     * @param string $table The name of the table to delete from
     * @param string|null $where The WHERE clause
     * @return mixed The result of the delete query
     */
    public function delete(string $table, string $where = null)
    {
        // Construct the DELETE SQL query
        $sql = "DELETE FROM $table";
        if ($where != null) {
            $sql .= " WHERE $where";
        }
        
        return $this->query($sql);
    }

    /**
     * Sanitize a single input value.
     *
     * @param string $data The input string
     * @return string The sanitized input string
     */
    private function sanitizeInput(string $data): string
    {
        // Trim the input, remove special HTML characters, and escape special SQL characters
        return $this->connection->real_escape_string(htmlspecialchars(trim($data), ENT_QUOTES, 'UTF-8'));
    }
    
    /**
     * Sanitize an array of input values.
     *
     * @param array $data The input array
     * @return array The sanitized input array
     */
    private function sanitizeInputArray(array $data): array
    {
        // Iterate through each value in the array and sanitize it
        foreach ($data as $key => $value) {
            $data[$key] = $this->sanitizeInput($value);
        }
        
        return $data;
    }
}

