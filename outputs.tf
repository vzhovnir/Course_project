output "db_external_ip" {
  value = module.database.database_url
}

output "web_external_ip" {
  value = module.vm-instance-moodle.web_external_ip
}

# output "web_internal_ip" {
#   value = "${google_compute_instance.web.network_interface.0.network_ip}"
# }

