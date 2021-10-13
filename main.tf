locals {
  user = coalesce(var.user, var.database)
}

resource "mysql_database" "this" {
  name = var.database

  default_character_set = var.default_character_set
  default_collation     = var.default_collation
}

resource "mysql_user" "this" {
  count = var.plaintext_password != null ? 0 : 1

  user               = var.user
  host               = "%"
  plaintext_password = var.plaintext_password
}

resource "mysql_grant" "this" {
  count = var.plaintext_password != null ? 0 : 1

  user     = mysql_user.this[count.index].user
  host     = "%"
  database = mysql_database.this.name

  privileges = ["ALL PRIVILEGES"]
}
