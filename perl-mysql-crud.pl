package GGlink::Database;

use strict;
use warnings;
use DBI;

# Class Database
# Provides functionalities for database interactions.
# 
# @author Mokter Hossain
# @email mo@gglink.uk
# @website www.gglink.uk
# @github https://github.com/moktermd08
# @linkedin https://www.linkedin.com/in/mr-mokter/
# @twitter https://twitter.com/moGGLink
#
package Database;

# Constructor for Database class
sub new {
    my ($class) = @_;
    my $self = {
        host     => "localhost",
        user     => "user",
        password => "password",
        database => "database",
        connection => undef
    };
    return bless $self, $class;
}

# Establishes a database connection.
# @return 1 on successful connection, 0 on failure
sub connect {
    my ($self) = @_;
    $self->{connection} = DBI->connect("DBI:mysql:database=$self->{database};host=$self->{host}", $self->{user}, $self->{password})
        or die "Failed to connect to the database: " . DBI->errstr;
    return 1;
}

# Closes the database connection.
# @return 1 on success, 0 on failure
sub disconnect {
    my ($self) = @_;
    if ($self->{connection}) {
        $self->{connection}->disconnect();
        return 1;
    }
    return 0;
}

# Sanitize user input.
# @param data The user input data.
# @return The sanitized data.
sub sanitizeInput {
    my ($self, $data) = @_;
    $data = $self->{connection}->quote($data); # This both quotes and escapes the input
    return $data;
}

# Sanitize output.
# @param data The data to be sent to the client.
# @return The sanitized data.
sub sanitizeOutput {
    my ($self, $data) = @_;
    $data =~ s/&/&amp;/g;
    $data =~ s/</&lt;/g;
    $data =~ s/>/&gt;/g;
    $data =~ s/"/&quot;/g;
    $data =~ s/'/&#039;/g;
    return $data;
}

# Class MySQLDatabase
# A concrete implementation of the Database abstract class for MySQL databases.
package MySQLDatabase;
use base 'Database';

# Here you can implement the abstract methods defined in the Database class,
# as well as any additional methods specific to MySQLDatabase.

1; # Returns true to indicate the module loaded successfully
