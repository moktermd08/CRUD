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
abstract class Database
{
    private string $host = "localhost";
    private string $user = "user";
    private string $password = "password";
    private string $database = "database";
    protected ?mysqli $connection = null;

    /**
     * Establishes a database connection.
     *
     * @return bool True on successful connection, False on failure
     *
     * @throws Exception If connection to the database fails
     */
    public function connect(): bool
    {
        $this->connection = new mysqli($this->host, $this->user, $this->password, $this->database);
        
        if ($this->connection->connect_error) {
            throw new Exception("Failed to connect to the database: " . $this->connection->connect_error);
        }
        
        return true;
    }

    /**
     * Closes the database connection.
     *
     * @return bool True on success, False on failure
     */
    public function disconnect(): bool
    {
        if ($this->connection) {
            return $this->connection->close();
        }
        
        return false;
    }

    // ... other methods ...

    /**
     * Sanitize user input.
     *
     * @param string $data The user input data.
     * @return string The sanitized data.
     */
    public function sanitizeInput(string $data): string
    {
        $data = trim($data);
        $data = stripslashes($data);
        $data = htmlspecialchars($data);
        $data = $this->connection->real_escape_string($data);
        return $data;
    }

    /**
     * Sanitize output.
     *
     * @param string $data The data to be sent to the client.
     * @return string The sanitized data.
     */
    public function sanitizeOutput(string $data): string
    {
        return htmlspecialchars($data, ENT_QUOTES, 'UTF-8');
    }
}

/**
 * Class MySQLDatabase
 *
 * A concrete implementation of the Database abstract class for MySQL databases.
 */
final class MySQLDatabase extends Database
{
    // Here you can implement the abstract methods defined in the Database class,
    // as well as any additional methods specific to MySQLDatabase.
}

