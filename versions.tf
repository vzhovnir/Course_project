terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    null = {
      source = "hashicorp/null"
    }
     mysql = {
      source = "terraform-providers/mysql"
    }
  }
  required_version = ">= 0.13"
}
