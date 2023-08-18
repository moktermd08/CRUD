install.packages(c("DBI", "RMySQL"))
library(DBI)
library(RMySQL)

# Define the Database class
Database <- setRefClass("Database",
                        
    fields = list(
        host = "character",
        user = "character",
        password = "character",
        database = "character",
        connection = "ANY"
    ),
    
    methods = list(
        
        initialize = function(host="localhost", user="user", password="password", database="database") {
            .self$host <- host
            .self$user <- user
            .self$password <- password
            .self$database <- database
            .self$connect()
        },
        
        connect = function() {
            .self$connection <- dbConnect(RMySQL::MySQL(), host = .self$host, user = .self$user, password = .self$password, dbname = .self$database)
        },
        
        disconnect = function() {
            dbDisconnect(.self$connection)
        },
        
        query = function(sql) {
            result <- dbSendQuery(.self$connection, sql)
            return(result)
        },
        
        select = function(table, rows="*", where=NULL, order=NULL, limit=NULL) {
            sql <- paste0("SELECT ", rows, " FROM ", table)
            if (!is.null(where)) sql <- paste0(sql, " WHERE ", where)
            if (!is.null(order)) sql <- paste0(sql, " ORDER BY ", order)
            if (!is.null(limit)) sql <- paste0(sql, " LIMIT ", limit)
            return(.self$query(sql))
        },
        
        insert = function(table, values, columns=NULL) {
            col_string <- if (!is.null(columns)) paste0("(", paste(columns, collapse=", "), ")") else ""
            val_string <- paste0("('", paste(values, collapse="', '"), "')")
            sql <- paste0("INSERT INTO ", table, " ", col_string, " VALUES ", val_string)
            return(.self$query(sql))
        },
        
        update = function(table, set, where=NULL) {
            sql <- paste0("UPDATE ", table, " SET ", set)
            if (!is.null(where)) sql <- paste0(sql, " WHERE ", where)
            return(.self$query(sql))
        },
        
        delete = function(table, where) {
            sql <- paste0("DELETE FROM ", table, " WHERE ", where)
            return(.self$query(sql))
        }
    )
)

# Create Database instance
db <- Database$new()

# Use the Database instance for operations
tryCatch({
    # Insert
    db$insert("users", c("john_doe", "john.doe@example.com", "password123"), c("username", "email", "password"))
    print("Insert: New user added.")
    
    # Select
    result <- db$select("users")
    print("Select: List of all users:")
    print(fetch(result))
    
    # Update
    db$update("users", "email='new.email@example.com'", "id=1")
    print("Update: Email of user with ID 1 updated.")
    
    # Delete
    db$delete("users", "id=1")
    print("Delete: User with ID 1 deleted.")
    
}, error = function(e) {
    print(paste("An error occurred:", e))
}) 

# Disconnect
db$disconnect()
