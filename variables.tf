variable "credentials" {
  #description = "${file("CREDENTIALS_FILE.json")}"
  description = "CREDENTIALS_JSON_PATH"

  #default = "${file("$CREDENTIALS_JSON_PATH")}"
  default = "/Users/vzhovnir/Diplom/Terraform/key.json"
}

variable "project" {
  description = "Project ID"
  default     = "thesis-and-course"
}

variable "region" {
  description = "Region"
  default     = "us-central1"
}

variable "zone" {
  description = "Zone"
  default     = "us-central1-a"
}

variable private_key_path {
  description = "Path to the private key used for ssh access"
  default     = "/Users/vzhovnir/Diplom/Terraform/ssh"
}

variable "moodleuserdb" {
  description = "name user for db"
  default = "webmoodle"
}

variable "mail" {
  description = "Password for Admin moodle"
  default = "vladikzhovnir@gmail.com"
}

variable "backup_enabled" {
  description = "Specify whether backups should be enabled for the SQLServer instance."
  type        = bool
  default     = false
}

variable "binary_log_enabled" {
  description = "Specify whether binary logs should be enabled for the SQLServer instance. Value of 'true' requires 'var.backup_enabled' to be 'true'."
  type        = bool
  default     = false
}

variable "pit_recovery_enabled" {
  description = "Specify whether Point-In-Time recoevry should be enabled for the SQLServer instance. It uses the \"binary log\" feature of CloudSQL. Value of 'true' requires 'var.binary_log_enabled' to be 'true'."
  type        = bool
  default     = false
}