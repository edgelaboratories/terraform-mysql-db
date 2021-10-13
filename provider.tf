terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
    }

    mysql = {
      source = "winebarrel/mysql"
    }

    vault = {
      source = "cyrilgdn/vault"
    }
  }
}
