#import <Foundation/Foundation.h>
#import <sqlite3.h>

// Database interface
@interface GGDatabase : NSObject {
    sqlite3 *database;
}

- (BOOL)connectWithDatabaseName:(NSString *)dbName;
- (BOOL)disconnect;
- (NSArray *)selectFromTable:(NSString *)table columns:(NSString *)columns where:(NSString *)whereClause;
- (BOOL)insertIntoTable:(NSString *)table columns:(NSString *)columns values:(NSString *)values;
- (BOOL)updateTable:(NSString *)table set:(NSString *)setClause where:(NSString *)whereClause;
- (BOOL)deleteFromTable:(NSString *)table where:(NSString *)whereClause;

@end

@implementation GGDatabase

- (BOOL)connectWithDatabaseName:(NSString *)dbName {
    NSString *dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:dbName];
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"Database connection failed.");
        return NO;
    }
    return YES;
}

- (BOOL)disconnect {
    if (sqlite3_close(database) != SQLITE_OK) {
        NSLog(@"Database disconnection failed.");
        return NO;
    }
    return YES;
}

- (NSArray *)selectFromTable:(NSString *)table columns:(NSString *)columns where:(NSString *)whereClause {
    NSString *queryStr = [NSString stringWithFormat:@"SELECT %@ FROM %@", columns, table];
    if (whereClause) {
        queryStr = [queryStr stringByAppendingFormat:@" WHERE %@", whereClause];
    }
    sqlite3_stmt *statement;
    NSMutableArray *results = [NSMutableArray array];
    if (sqlite3_prepare_v2(database, [queryStr UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableDictionary *row = [NSMutableDictionary dictionary];
            for (int i=0; i<sqlite3_column_count(statement); i++) {
                char *columnName = (char *)sqlite3_column_name(statement, i);
                char *columnText = (char *)sqlite3_column_text(statement, i);
                [row setObject:[NSString stringWithUTF8String:columnText]
                        forKey:[NSString stringWithUTF8String:columnName]];
            }
            [results addObject:row];
        }
        sqlite3_finalize(statement);
    }
    return results;
}

- (BOOL)insertIntoTable:(NSString *)table columns:(NSString *)columns values:(NSString *)values {
    NSString *queryStr = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)", table, columns, values];
    char *error;
    if (sqlite3_exec(database, [queryStr UTF8String], NULL, NULL, &error) != SQLITE_OK) {
        NSLog(@"Insert error: %s", error);
        return NO;
    }
    return YES;
}

- (BOOL)updateTable:(NSString *)table set:(NSString *)setClause where:(NSString *)whereClause {
    NSString *queryStr = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@", table, setClause, whereClause];
    char *error;
    if (sqlite3_exec(database, [queryStr UTF8String], NULL, NULL, &error) != SQLITE_OK) {
        NSLog(@"Update error: %s", error);
        return NO;
    }
    return YES;
}

- (BOOL)deleteFromTable:(NSString *)table where:(NSString *)whereClause {
    NSString *queryStr = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@", table, whereClause];
    char *error;
    if (sqlite3_exec(database, [queryStr UTF8String], NULL, NULL, &error) != SQLITE_OK) {
        NSLog(@"Delete error: %s", error);
        return NO;
    }
    return YES;
}

@end

int main(int argc, char * argv[]) {
    @autoreleasepool {
        GGDatabase *db = [[GGDatabase alloc] init];
        if ([db connectWithDatabaseName:@"testDB.sqlite"]) {
            NSLog(@"Connected to the database.");

            // Example usage
            [db insertIntoTable:@"users" columns:@"username, email, password" values:@"'john_doe', 'john.doe@example.com', 'password123'"];
            NSLog(@"Insert: New user added.");
            
            NSArray *results = [db selectFromTable:@"users" columns:@"id, username, email" where:nil];
            for (NSDictionary *row in results) {
                NSLog(@"ID: %@ | Username: %@ | Email: %@", [row objectForKey:@"id"], [row objectForKey:@"username"], [row objectForKey:@"email"]);
            }
            
            [db updateTable:@"users" set:@"email='new.email@example.com'" where:@"id=1"];
            NSLog(@"Update: Email of user with ID 1 updated.");
            
            [db deleteFromTable:@"users" where:@"id=1"];
            NSLog(@"Delete: User with ID 1 deleted.");
            
            [db disconnect];
            NSLog(@"Disconnected from the database.");
        }
    }
    return 0;
}
