variable "db_name" {
  type    = string
  default = "moodle"
}
variable "db_version" {
  type    = string
  default = "MYSQL_5_7"
}
variable "db_region" {
  type    = string
  default = "us-central1"
}
variable "db_instance_type" {
  type    = string
  default = "db-n1-standard-1"
}
variable "db_username" {
  type    = string
  default = "webmoodle"
}

variable "db_user_host" {
  type = string
}

variable "backup_configuration" {
  description = "The database backup configuration."
  type = object({
    binary_log_enabled             = bool
    enabled                        = bool
    point_in_time_recovery_enabled = bool
    start_time                     = string
  })
  default = {
    binary_log_enabled             = null
    enabled                        = false
    point_in_time_recovery_enabled = null
    start_time                     = null
  }
}