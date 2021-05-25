provider "mysql" {
  endpoint = local.mysql_connection
  username = google_sql_user.root.name
  password = google_sql_user.root.password
}

locals {
  mysql_connection = "${google_sql_database_instance.instance.ip_address.0.ip_address}:3306"
}

resource "google_sql_database_instance" "instance" {
  database_version = var.db_version
  region           = var.db_region
  deletion_protection = false
  settings {
    dynamic "backup_configuration" {
      for_each = var.backup_configuration.enabled ? [var.backup_configuration] : []
      content {
        binary_log_enabled             = lookup(backup_configuration.value, "binary_log_enabled", null)
        enabled                        = lookup(backup_configuration.value, "enabled", null)
        start_time                     = lookup(backup_configuration.value, "start_time", null)
        point_in_time_recovery_enabled = lookup(backup_configuration.value, "point_in_time_recovery_enabled", null)
      }
    }
    tier = var.db_instance_type
    ip_configuration {
      ipv4_enabled = true
      authorized_networks {
        name  = "default"
        value = "0.0.0.0/0"
      }
    }
  }
}

resource "random_password" "root" {
  length           = 8
  special          = true
  override_special = "_"
}

resource "google_sql_user" "root" {
  name     = "root"
  instance = google_sql_database_instance.instance.name
  password = random_password.root.result
}

resource "mysql_database" "moodle" {
  name = var.db_name
}

resource "random_password" "password" {
  length           = 8
  special          = true
  override_special = "_"
}

resource "mysql_user" "moodle" {
  user               = var.db_username
  host               = var.db_user_host
  plaintext_password = random_password.password.result
}

resource "mysql_grant" "moodle" {
  user       = mysql_user.moodle.user
  host       = mysql_user.moodle.host
  database   = mysql_database.moodle.name
  privileges = ["ALL"]
}

resource "random_password" "moodle" {
  length           = 8
  special          = true
  override_special = "_"
}
