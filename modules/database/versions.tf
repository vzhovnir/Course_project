terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    mysql = {
      source = "terraform-providers/mysql"
    }
    random = {
      source = "hashicorp/random"
    }
  }
  required_version = ">= 0.13"
}
