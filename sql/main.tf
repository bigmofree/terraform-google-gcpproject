# Creating SQL Database instance
resource "google_sql_database_instance" "sqlinstance" {
  name               = "db-instance"
  database_version   = "MYSQL_5_7"
  deletion_protection = false
  tier               = "db-f1-micro"  # or any other appropriate tier
}

# Creating DB user
resource "google_sql_user" "users" {
  name     = "oleksii"
  instance = google_sql_database_instance.sqlinstance.name
}

# Specifying DB
resource "google_sql_database" "sqldatabase" {
  name     = "wordpress"
  instance = google_sql_database_instance.sqlinstance.name
}
