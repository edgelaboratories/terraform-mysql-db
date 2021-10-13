locals {
  roles = var.vault_backend_path == null ? {} : {
    "all-privileges" = "ALL PRIVILEGES"
    "read-only"      = "SELECT"
  }
}

resource "vault_database_secret_backend_role" "this" {
  for_each = local.roles

  name    = "${var.database}-${each.key}"
  backend = var.vault_backend_path
  db_name = var.vault_db_connection_name

  creation_statements = [
    "CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';",
    "GRANT ${each.value} ON ${var.database}.* TO '{{name}}'@'%';",
  ]

  default_ttl = var.vault_role_default_ttl
}

data "vault_policy_document" "this" {
  for_each = local.roles

  rule {
    path         = "${var.vault_backend_path}/creds/${vault_database_secret_backend_role.this[each.key].name}"
    capabilities = ["read"]
  }
}

resource "vault_policy" "this" {
  for_each = local.roles

  name   = "${var.vault_backend_path}/${var.database}/${each.key}"
  policy = data.vault_policy_document.this[each.key].hcl
}
