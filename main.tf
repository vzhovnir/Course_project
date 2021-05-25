// Configure the Google Cloud provider

provider "google" {
  credentials = var.credentials
  project     = var.project
  region      = var.region
}
// Configure the Google Cloud bucket
terraform {
  backend "gcs" {
    bucket      = "thesis-state"
    prefix      = "terraform/state"
    credentials = "/Users/vzhovnir/Diplom/Terraform/key.json"
  }
}

module "database" {
  source           = "./modules/database"
  db_name          = "moodle"
  db_version       = "MYSQL_5_7"
  db_region        = "us-central1"
  db_instance_type = "db-n1-standard-1"
  db_username      = "webmoodle"
  db_user_host             = module.vm-instance-moodle.web_external_ip
  # backup settings
  backup_configuration = {
    enabled                        = var.backup_enabled
    binary_log_enabled             = var.binary_log_enabled
    start_time                     = "00:05"
    point_in_time_recovery_enabled = var.pit_recovery_enabled
  }
}

module "secret-manager" {
  source            = "./modules/secret-manager"
  db_url            = module.database.database_url
  db_username       = module.database.database_user
  db_password       = module.database.database_password
  root_db_password  = module.database.root_password
  moodle-admin-pass = module.database.moodle_password
}
module "networking" {
  source           = "./modules/networking"
  subnetwork       = "moodle-subnet"
  ip_cidr_range    = "10.15.0.0/28"
  region           = "us-central1"
  network         = "moodle-vpc"
  zone             = "us-central1-a"
}

module "vm-instance-moodle" {
  source                  = "./modules/instance"
  instance_name           = "moodle"
  instance_machine_type   = "g1-small"
  zone                    = "us-central1-a"
  image_name              = "centos-7-v20190729"
  network                 = module.networking.network
  subnetwork              = module.networking.subnet
  username                = "vlad"
  public_key_path         = "/Users/vzhovnir/Diplom/Terraform/ssh.pub"
}

resource "null_resource" "web_prov" {
 # connection for the work of service providers after installing and configuring the OS
  connection {
    host        = "${module.vm-instance-moodle.web_external_ip}"
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
      "sudo /bin/bash /tmp/deployWeb.sh ${module.vm-instance-moodle.web_external_ip} ${module.database.database_url} ${module.database.root_password} ${var.moodleuserdb} ${module.database.database_password} ${module.database.moodle_password} ${var.mail}"
    ]
  }
}