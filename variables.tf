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

variable "machine_type" {
  description = "The machine type to create"
  default     = "g1-small"
}

variable "disk_image" {
  description = "centos-7"
  default     = "centos-7-v20190729"
}

variable "network" {
  description = "The name or self_link of the network to attach this interface to. Either network or subnetwork must be provided."
  default     = "moodle-vpc"
}

variable "subnetwork" {
  description = "The name or self_link of the subnetwork to attach this interface to. The subnetwork must exist in the same region this instance will be created in. Either network or subnetwork must be provided."
  default     = "moodle-subnet"
}

variable "subnetwork_project" {
  description = "The project in which the subnetwork belongs. If the subnetwork is a self_link, this field is ignored in favor of the project defined in the subnetwork self_link. If the subnetwork is a name and this field is not provided, the provider project is used."
  default     = ""
}

variable "network_ip" {
  description = "The private IP address to assign to the instance. If empty, the address will be automatically assigned."
  default     = ""
}

variable "nat_ip" {
    description = "The IP address that will be 1:1 mapped to the instance's network ip. If not given, one will be generated."
    default     = ""
}
variable "public_key_path" {
  description = "public key for user Vlad"
  default     = "/Users/vzhovnir/Diplom/Terraform/ssh.pub"
}

variable private_key_path {
  description = "Path to the private key used for ssh access"
  default     = "/Users/vzhovnir/Diplom/Terraform/ssh"
}

variable "rootdbpass" {
  description = "Password for root db"
  default = "securepassword"
}

variable "moodleuserdb" {
  description = "name user for db"
  default = "webmoodle"
}

variable "moodlepassword_db" {
  description = "Password for user db"
  default = "yoursecurepasword"
}

