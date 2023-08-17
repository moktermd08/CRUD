using System;
using System.Data;
using MySql.Data.MySqlClient;

namespace YourNamespace
{
    /// <summary>
    /// Represents a Database connection and provides CRUD operations.
    /// 
    /// Author: Mokter Hossain
    /// Email: mo@gglink.uk
    /// Website: www.gglink.uk
    /// Github: https://github.com/moktermd08
    /// Linkedin: https://www.linkedin.com/in/mr-mokter/
    /// Twitter: https://twitter.com/moGGLink
    /// </summary>
    public class Database : IDisposable
    {
        private readonly string _connectionString;
        private MySqlConnection _connection;

        /// <summary>
        /// Initializes a new instance of the Database class with connection parameters.
        /// </summary>
        /// <param name="host">Database host</param>
        /// <param name="user">Database user</param>
        /// <param name="password">Database password</param>
        /// <param name="database">Database name</param>
        public Database(string host = "localhost", string user = "user", string password = "password", string database = "database")
        {
            _connectionString = $"Server={host};Database={database};User ID={user};Password={password};";
        }

        /// <summary>
        /// Opens a connection to the database.
        /// </summary>
        /// <returns>True if the connection is successful; otherwise, False.</returns>
        public bool Connect()
        {
            _connection = new MySqlConnection(_connectionString);
            try
            {
                _connection.Open();
                return true;
            }
            catch (MySqlException ex)
            {
                Console.WriteLine("MySQL Connection Error: " + ex.Message);
                return false;
            }
        }

        /// <summary>
        /// Closes the connection to the database.
        /// </summary>
        public void Disconnect()
        {
            if (_connection != null && _connection.State == ConnectionState.Open)
            {
                _connection.Close();
            }
        }

        /// <summary>
        /// Executes a SELECT query and returns the result as a DataTable.
        /// </summary>
        /// <param name="query">The SQL query string</param>
        /// <returns>A DataTable containing the result set</returns>
        public DataTable Select(string query)
        {
            using (var command = new MySqlCommand(query, _connection))
            {
                using (var adapter = new MySqlDataAdapter(command))
                {
                    var result = new DataTable();
                    adapter.Fill(result);
                    return result;
                }
            }
        }

        /// <summary>
        /// Inserts a new record into a table.
        /// </summary>
        /// <param name="table">The name of the table</param>
        /// <param name="columns">The columns for the insert</param>
        /// <param name="values">The values for the insert</param>
        /// <returns>True if the insert was successful; otherwise, False.</returns>
        public bool Insert(string table, string columns, string values)
        {
            var query = $"INSERT INTO {table} ({columns}) VALUES ({values})";
            return ExecuteNonQuery(query);
        }

        /// <summary>
        /// Updates records in a table.
        /// </summary>
        /// <param name="table">The name of the table</param>
        /// <param name="setClause">The SET clause for the update</param>
        /// <param name="whereClause">The WHERE clause for the update</param>
        /// <returns>True if the update was successful; otherwise, False.</returns>
        public bool Update(string table, string setClause, string whereClause)
        {
            var query = $"UPDATE {table} SET {setClause} WHERE {whereClause}";
            return ExecuteNonQuery(query);
        }

        /// <summary>
        /// Deletes records from a table.
        /// </summary>
        /// <param name="table">The name of the table</param>
        /// <param name="whereClause">The WHERE clause for the delete</param>
        /// <returns>True if the delete was successful; otherwise, False.</returns>
        public bool Delete(string table, string whereClause)
        {
            var query = $"DELETE FROM {table} WHERE {whereClause}";
            return ExecuteNonQuery(query);
        }

        /// <summary>
        /// Executes an SQL query that does not return a result set.
        /// </summary>
        /// <param name="query">The SQL query string</param>
        /// <returns>True if the query was executed successfully; otherwise, False.</returns>
        private bool ExecuteNonQuery(string query)
        {
            using (var command = new MySqlCommand(query, _connection))
            {
                try
                {
                    command.ExecuteNonQuery();
                    return true;
                }
                catch (MySqlException ex)
                {
                    Console.WriteLine("MySQL Query Error: " + ex.Message);
                    return false;
                }
            }
        }

        /// <summary>
        /// Implements the IDisposable interface to allow for using statement support and manual resource management.
        /// </summary>
        public void Dispose()
        {
            Disconnect();
        }
    }
}
