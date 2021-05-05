// Configure the Google Cloud provider

provider "google" {
  credentials = var.credentials
  project     = var.project
  region      = var.region
}

resource "google_compute_subnetwork" "vpc_subnetwork" {
  name          = var.subnetwork
  ip_cidr_range = "10.15.0.0/28"
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_network" "vpc_network" {
    name                    = var.network
    auto_create_subnetworks = false
}

resource "google_compute_firewall" "allow-http" {
  name        = "web-firewalls"
  network     = var.network
  target_tags = ["web"]

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  allow {
    protocol = "icmp"
  }
  depends_on = [google_compute_subnetwork.vpc_subnetwork]
}


resource "google_compute_firewall" "allow-ssh" {
  name    = "ssh-firewalls"
  network = var.network

  #target_tags = google_compute_instance.web.tags
  target_tags = ["web", "db"]

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

resource "google_compute_instance" "db" {
  name         = "db-test"
  machine_type = var.machine_type
  zone         = var.zone
  tags         = ["db"]

  # definition of the boot disk - the initial image 
  boot_disk {
    initialize_params {
      image = var.disk_image
    }
  }

  network_interface {
    network            = var.network
    subnetwork         = var.subnetwork
    network_ip         = var.network_ip
    
    access_config {
            nat_ip = var.nat_ip
    }
  }
 
 metadata = {
    ssh-keys = "vlad:${file(var.public_key_path)}"
  }
 depends_on = [google_compute_subnetwork.vpc_subnetwork]
}


resource "google_compute_instance" "web" {
  depends_on = [google_compute_subnetwork.vpc_subnetwork]
  name         = "web-test"
  machine_type = var.machine_type
  zone         = var.zone
  tags         = ["web"]

  # definition of the boot disk - the initial image 
  boot_disk {
    initialize_params {
      image = var.disk_image
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
    ssh-keys = "vlad:${file(var.public_key_path)}"
  }
 
}

resource "null_resource" "db_prov" {
  
  depends_on = [google_compute_instance.db]

# connection for the work of service providers after installing and configuring the OS
  connection {
    host        = "${google_compute_instance.db.network_interface.0.access_config.0.nat_ip}"
    type        = "ssh"
    user        = "vlad"
    agent       = false
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "file" {
    source      = "./files/deployDb.sh"
    destination = "/tmp/deployDb.sh"   
 } 
  
  provisioner "remote-exec" {

    inline = [
      "sudo chmod +x /tmp/deployDb.sh",
      "sudo /bin/bash /tmp/deployDb.sh ${google_compute_instance.web.network_interface.0.network_ip} ${var.rootdbpass} ${var.moodleuserdb} ${var.moodlepassword_db}"
    ]
  }
}

resource "null_resource" "web_prov" {
 
  depends_on = [null_resource.db_prov]

# connection for the work of service providers after installing and configuring the OS
  connection {
    host        = "${google_compute_instance.web.network_interface.0.access_config.0.nat_ip}"
    type        = "ssh"
    user        = "vlad"
    agent       = false
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "file" {
    source      = "./files/deployWeb.sh"
    destination = "/tmp/deployWeb.sh"   
 } 

  provisioner "remote-exec" {
  
    inline = [
      "sudo chmod +x /tmp/deployWeb.sh",
      "sudo /bin/bash /tmp/deployWeb.sh ${google_compute_instance.web.network_interface.0.access_config.0.nat_ip} ${google_compute_instance.db.network_interface.0.network_ip} ${var.rootdbpass} ${var.moodleuserdb} ${var.moodlepassword_db}"
    ]
  }
}

