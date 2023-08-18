Imports System.Data.SqlClient

Namespace GGlink.Database

    Public Class Database

        Private host As String = "localhost"
        Private user As String = "user"
        Private password As String = "password"
        Private database As String = "database"
        Private connection As SqlConnection = Nothing

        Private Sub New(host As String, user As String, password As String, database As String)
            Me.host = host
            Me.user = user
            Me.password = password
            Me.database = database
            Me.Connect()
        End Sub

        Public Function Connect() As Boolean
            Dim connectionString As String = $"Server={host};Database={database};User Id={user};Password={password};"
            connection = New SqlConnection(connectionString)
            connection.Open()

            If connection.State <> ConnectionState.Open Then
                Throw New Exception("Failed to connect to the database.")
            End If

            Return True
        End Function

        Public Function Disconnect() As Boolean
            If connection IsNot Nothing AndAlso connection.State = ConnectionState.Open Then
                connection.Close()
                Return True
            End If
            Return False
        End Function

        ' ... Other database operation methods like Query, Select, Insert, etc.

    End Class

    Public Class DatabaseFactory

        Public Shared Function Create() As Database
            Return New Database("localhost", "user", "password", "database")
        End Function

    End Class

End Namespace

' Example use:
Module Main

    Sub Main()
        Try
            Dim db As GGlink.Database.Database = GGlink.Database.DatabaseFactory.Create()

            ' ... Perform database operations

        Catch ex As Exception
            Console.WriteLine("An error occurred: " & ex.Message)
        Finally
            db.Disconnect()
            Console.WriteLine("Disconnected from the database.")
        End Try

    End Sub

End Module
