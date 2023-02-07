using UnityEngine;
using System.Data;
using Mono.Data.Sqlite;
using System;

namespace Demos
{
    public class SQLiteDemo : MonoBehaviour
    {
        string dbName = "Assets/Scripts/SQLite/TestDB.db";
        string ConnectionString => $"Data Source={dbName}";

        private void Start()
        {
            // 创建Table
            CreateDB();

            // 添加数据
            AddPerson(1, "Hello", "World");

            // 查询数据
            QueryAllPerson();
        }

        private void CreateDB()
        {
            using (var connection = new SqliteConnection(ConnectionString))
            {
                connection.Open();

                using (var command = connection.CreateCommand())
                {
                    command.CommandText = "CREATE TABLE Person (Id INTEGER NOT NULL UNIQUE, FirstName TEXT NOT NULL, SecondName TEXT NOT NULL,PRIMARY KEY(Id AUTOINCREMENT));";
                    command.ExecuteNonQuery();
                }

                connection.Close();
            }
        }

        private void AddPerson(int id, string firstName, string secondName)
        {
            using (var connection = new SqliteConnection(ConnectionString))
            {
                connection.Open();

                using (var command = connection.CreateCommand())
                {
                    command.CommandText = $"INSERT INTO Person (Id, FirstName, SecondName) VALUES (null, '{firstName}', '{secondName}');";
                    command.ExecuteNonQuery();
                }

                connection.Close();
            }
        }

        private void QueryAllPerson()
        {
            using (var connection = new SqliteConnection(ConnectionString))
            {
                connection.Open();

                using (var command = connection.CreateCommand())
                {
                    command.CommandText = "SELECT * FROM Person";
                    using (IDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            Log.Debug($"{reader["Id"]}: {reader["FirstName"]}-{reader["SecondName"]}");
                        }
                        reader.Close();
                    }
                }

                connection.Close();
            }
        }
    }
}
