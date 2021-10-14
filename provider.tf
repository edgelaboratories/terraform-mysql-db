terraform {
  required_providers {
    mysql = {
      source = "winebarrel/mysql"
    }

    vault = {
      source = "cyrilgdn/vault"
    }
  }
}
