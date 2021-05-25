output "database_url" {
  description = ""
  value       = google_sql_database_instance.instance.ip_address.0.ip_address
}
output "database_user" {
  description = ""
  value       = mysql_user.moodle.user
}
output "database_password" {
  description = ""
  value       = random_password.password.result
}
output "root_password" {
  description = ""
  value       = google_sql_user.root.password
}

output "moodle_password" {
  description = ""
  value       = random_password.moodle.result
}