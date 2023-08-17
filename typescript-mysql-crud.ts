import mysql, { Connection, MysqlError } from 'mysql';

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
 */
abstract class Database {
    private host: string = 'localhost';
    private user: string = 'user';
    private password: string = 'password';
    private database: string = 'database';
    protected connection: Connection | null = null;

    /**
     * Establishes a database connection.
     *
     * @returns {Promise<boolean>} True on successful connection, False on failure
     *
     * @throws {Error} If connection to the database fails
     */
    public connect(): Promise<boolean> {
        return new Promise((resolve, reject) => {
            this.connection = mysql.createConnection({
                host: this.host,
                user: this.user,
                password: this.password,
                database: this.database
            });

            this.connection.connect((err: MysqlError | null) => {
                if (err) {
                    reject(new Error('Failed to connect to the database: ' + err.message));
                } else {
                    resolve(true);
                }
            });
        });
    }

    /**
     * Closes the database connection.
     *
     * @returns {Promise<boolean>} True on success, False on failure
     */
    public disconnect(): Promise<boolean> {
        return new Promise((resolve, reject) => {
            if (this.connection) {
                this.connection.end(err => {
                    if (err) {
                        reject(false);
                    } else {
                        resolve(true);
                    }
                });
            } else {
                resolve(false);
            }
        });
    }

    /**
     * Sanitize user input.
     *
     * @param {string} data - The user input data
     * @returns {string} The sanitized data
     */
    public sanitizeInput(data: string): string {
        data = data.trim();
        data = this.connection ? this.connection.escape(data).toString() : data;
        return data;
    }

    /**
     * Sanitize output.
     *
     * @param {string} data - The data to be sent to the client
     * @returns {string} The sanitized data
     */
    public sanitizeOutput(data: string): string {
        return data
            .toString()
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#039;');
    }
}

/**
 * Class MySQLDatabase
 * 
 * A concrete implementation of the Database abstract class for MySQL databases.
 */
class MySQLDatabase extends Database {
    // Here you can implement methods specific to MySQLDatabase.
}

// Example Usage:
// const db = new MySQLDatabase();
// db.connect()
//   .then(() => {
//     console.log('Connected to the database');
//     console.log('Sanitized Input:', db.sanitizeInput("user' OR '1'='1"));
//     return db.disconnect();
//   })
//   .then(() => {
//     console.log('Disconnected from the database');
//   })
//   .catch(err => {
//     console.error(err.message);
//   });
