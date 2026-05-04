terraform {
  required_providers {
    mysql = {
      source = "petoju/mysql"
    }

    vault = {
      source = "hashicorp/vault"
    }
  }
}
