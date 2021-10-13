locals {
  # We can't grant ALL PRIVILEGES ON *.* on RDS
  # (only on a specific database e.g.: GRANT ALL PRIVILEGES ON forecast.*)
  # so this define the maximum privileges
  # we can grant for a user
  rds_all_privileges = [
    "ALTER",
    "ALTER ROUTINE",
    "CREATE",
    "CREATE ROUTINE",
    "CREATE TEMPORARY TABLES",
    "CREATE USER",
    "CREATE VIEW",
    "DELETE",
    "DROP",
    "EVENT",
    "EXECUTE",
    "INDEX",
    "INSERT",
    "LOCK TABLES",
    "PROCESS",
    "REFERENCES",
    "RELOAD",
    "SELECT",
    "SHOW DATABASES",
    "SHOW VIEW",
    "TRIGGER",
    "UPDATE",
  ]

  roles = var.vault_backend_path == null ? {} : {
    "${var.name}-all-privileges" = {
      grant  = join(", ", local.rds_all_privileges)
      policy = "all-privileges"
    }
    "${var.name}-read-only" = {
      grant  = "SELECT"
      policy = "all-privileges"
    }
  }
}

resource "vault_database_secret_backend_role" "this" {
  for_each = local.roles

  name    = each.key
  backend = var.vault_backend_path
  db_name = var.vault_db_connection_name

  creation_statements = [
    "CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';",
    "GRANT ${each.value.grant} ON ${var.database}.* TO '{{name}}'@'%';",
  ]

  default_ttl = 600
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

  name   = "${var.vault_backend_path}/${var.database}/${each.value.policy}"
  policy = data.vault_policy_document.this[each.key].hcl
}
