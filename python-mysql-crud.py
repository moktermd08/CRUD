import mysql.connector
from mysql.connector import Error

class Database:
    """
    Database class.
    Provides functionalities for database interactions.

    Author: Mokter Hossain
    Email: mo@gglink.uk
    Website: www.gglink.uk
    Github: https://github.com/moktermd08
    Linkedin: https://www.linkedin.com/in/mr-mokter/
    Twitter: https://twitter.com/moGGLink

    """

    def __init__(self):
        self.host = "localhost"
        self.user = "user"
        self.password = "password"
        self.database = "database"
        self.connection = None

    def connect(self):
        """
        Establishes a database connection.

        Returns:
            bool: True on successful connection, False otherwise
        """
        try:
            self.connection = mysql.connector.connect(
                host=self.host,
                user=self.user,
                password=self.password,
                database=self.database
            )
            if self.connection.is_connected():
                return True
        except Error as e:
            print("Error:", e)
        return False

    def disconnect(self):
        """
        Closes the database connection.

        Returns:
            bool: True on success, False otherwise
        """
        if self.connection and self.connection.is_connected():
            self.connection.close()
            return True
        return False

    def select(self, table, columns='*', where=None):
        """
        Executes a SELECT query.

        Args:
            table (str): The name of the table
            columns (str, optional): The columns to select. Defaults to '*'.
            where (str, optional): The WHERE clause. Defaults to None.

        Returns:
            list: The result rows as a list of dictionaries, empty list if query fails
        """
        query = f"SELECT {columns} FROM {table}"
        if where:
            query += f" WHERE {where}"
        try:
            cursor = self.connection.cursor(dictionary=True)
            cursor.execute(query)
            return cursor.fetchall()
        except Error as e:
            print("Error:", e)
            return []

    def insert(self, table, values, columns=None):
        """
        Inserts a new record into a table.

        Args:
            table (str): The name of the table
            values (tuple): The data to insert
            columns (str, optional): The columns for insert. Defaults to None.

        Returns:
            bool: True if insert was successful, False otherwise
        """
        if columns:
            query = f"INSERT INTO {table} ({columns}) VALUES ({', '.join(['%s'] * len(values))})"
        else:
            query = f"INSERT INTO {table} VALUES ({', '.join(['%s'] * len(values))})"
        try:
            cursor = self.connection.cursor()
            cursor.execute(query, values)
            self.connection.commit()
            return True
        except Error as e:
            print("Error:", e)
            return False

    def update(self, table, set_data, where):
        """
        Updates records in a table.

        Args:
            table (str): The name of the table
            set_data (str): The data to update
            where (str): The WHERE clause

        Returns:
            bool: True if update was successful, False otherwise
        """
        query = f"UPDATE {table} SET {set_data} WHERE {where}"
        try:
            cursor = self.connection.cursor()
            cursor.execute(query)
            self.connection.commit()
            return True
        except Error as e:
            print("Error:", e)
            return False

    def delete(self, table, where):
        """
        Deletes records from a table.

        Args:
            table (str): The name of the table
            where (str): The WHERE clause

        Returns:
            bool: True if delete was successful, False otherwise
        """
        query = f"DELETE FROM {table} WHERE {where}"
        try:
            cursor = self.connection.cursor()
            cursor.execute(query)
            self.connection.commit()
            return True
        except Error as e:
            print("Error:", e)
            return False

# Example usage
if __name__ == "__main__":
    db = Database()
    if db.connect():
        print("Connected to the database")
        rows = db.select("users", "name, email", "age > 21")
        print("Selected rows:", rows)
        db.disconnect()
    else:
        print("Failed to connect to the database")
