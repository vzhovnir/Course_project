resource "google_compute_instance" "web" {
  name         = var.instance_name
  machine_type = var.instance_machine_type
  zone         = var.zone

  # definition of the boot disk - the initial image 
  boot_disk {
    initialize_params {
      image = var.image_name
    }
  }

  network_interface {
    network            = var.network
    subnetwork         = var.subnetwork
    network_ip         = var.network_ip

    access_config {
            nat_ip  = var.nat_ip
    }
  }
  
  metadata = {
    ssh-keys = "${var.username}:${file(var.public_key_path)}"
  }
 
}