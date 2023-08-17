require 'mysql2'

module GGlink
  module Database

    # Class Database
    #
    # Provides functionalities for database interactions.
    #
    # Author: Mokter Hossain
    # Email: mo@gglink.uk
    # Website: www.gglink.uk
    # GitHub: https://github.com/moktermd08
    # LinkedIn: https://www.linkedin.com/in/mr-mokter/
    # Twitter: https://twitter.com/moGGLink
    #
    class Database
      attr_accessor :connection

      def initialize
        @host = 'localhost'
        @user = 'user'
        @password = 'password'
        @database = 'database'
        @connection = nil
      end

      # Establishes a database connection.
      #
      # @return [Boolean] True on successful connection, False on failure
      # @raise [Exception] If connection to the database fails
      #
      def connect
        begin
          @connection = Mysql2::Client.new(
            host: @host,
            username: @user,
            password: @password,
            database: @database
          )
        rescue Mysql2::Error => e
          raise Exception.new("Failed to connect to the database: #{e.message}")
        end

        true
      end

      # Closes the database connection.
      #
      # @return [Boolean] True on success, False on failure
      #
      def disconnect
        @connection.close if @connection
        !@connection
      end

      # Sanitize user input.
      #
      # @param [String] data The user input data.
      # @return [String] The sanitized data.
      #
      def sanitize_input(data)
        data = data.strip
        data = data.gsub('\\', '\\\\')
        data = CGI.escapeHTML(data)
        data = @connection.escape(data)
        data
      end

      # Sanitize output.
      #
      # @param [String] data The data to be sent to the client.
      # @return [String] The sanitized data.
      #
      def sanitize_output(data)
        CGI.escapeHTML(data)
      end
    end

    # Class MySQLDatabase
    #
    # A concrete implementation of the Database abstract class for MySQL databases.
    #
    class MySQLDatabase < Database
      # Here you can implement methods specific to MySQLDatabase.
      # It inherits all methods from the Database class.
    end

  end
end

# Example usage:
db = GGlink::Database::MySQLDatabase.new
db.connect
puts db.sanitize_input("user' OR '1'='1")
db.disconnect
