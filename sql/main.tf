
# Creating SQL Database instance
resource "google_sql_database_instance" "sqlinstance" {
  name               = "db-instance"
  database_version   = "MYSQL_5_7"
  deletion_protection = false
  region             = "us-central1"  
  settings {
    tier = "db-f1-micro"  
  }
}

# Creating DB user
resource "google_sql_user" "user" {
  name     = "oleksii"
  instance = google_sql_database_instance.sqlinstance.name
}

# Specifying DB
resource "google_sql_database" "sqldatabase" {
  name     = "wordpress"
  instance = google_sql_database_instance.sqlinstance.name
}
