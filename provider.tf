terraform {
  experiments = [module_variable_optional_attrs]

  required_providers {
    mysql = {
      source = "winebarrel/mysql"
    }

    vault = {
      source = "cyrilgdn/vault"
    }
  }
}
