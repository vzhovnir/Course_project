
variable "instance_name" {
    description = "name machine"
}

variable "instance_machine_type" {
    description = "The machine type to create"
}

variable "zone" {
    description = "Zone"
}

variable "image_name" {
    description = "centos-7"
}

variable "network" {
  description = "The name or self_link of the network to attach this interface to. Either network or subnetwork must be provided."
}

variable "subnetwork" {
  description = "The name or self_link of the subnetwork to attach this interface to. The subnetwork must exist in the same region this instance will be created in. Either network or subnetwork must be provided."
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
  description = "public key for user "
  
}

variable "username" {
  description = "name user for vm "
}

