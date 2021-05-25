output "network" {
  description = ""
  value       = google_compute_network.vpc_network.name
}
output "subnet" {
  description = ""
 value        = google_compute_subnetwork.vpc_subnetwork.name
}