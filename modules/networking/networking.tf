resource "google_compute_network" "vpc_network" {
    name                    = var.network
    auto_create_subnetworks = false
}


resource "google_compute_subnetwork" "vpc_subnetwork" {
  name          = var.subnetwork
  ip_cidr_range = var.ip_cidr_range
  region        = var.region
  network       = google_compute_network.vpc_network.id
}


resource "google_compute_firewall" "allow-http" {
  name        = "web-firewalls"
  network     = var.network

  allow {
    protocol = "tcp"
    ports    = ["80", "443","3306"]
  }

  allow {
    protocol = "icmp"
  }
  depends_on = [google_compute_subnetwork.vpc_subnetwork]
}


resource "google_compute_firewall" "allow-ssh" {
  name    = "ssh-firewalls"
  network = var.network
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  allow {
    protocol = "icmp"
  }
  depends_on = [google_compute_subnetwork.vpc_subnetwork]
}


resource "google_compute_firewall" "internal_rule" {
  name    = "internal-rule"
  network = google_compute_network.vpc_network.id
  source_ranges  = ["10.15.0.0/28"] 


  allow {
    protocol     = "all"
  }

  depends_on = [google_compute_subnetwork.vpc_subnetwork]
}







 

