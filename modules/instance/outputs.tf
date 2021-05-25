output "web_external_ip" {
  value = "${google_compute_instance.web.network_interface.0.access_config.0.nat_ip}"
}

output "web_internal_ip" {
  value = "${google_compute_instance.web.network_interface.0.network_ip}"
}