# terraform-mysql-db

This module offers default conventions when creating a new MySQL database.

In particular:

- It creates a database 👋
- Optionally, it creates a user named after the database when not specified.
- Optionally, it creates two roles to obtain credentials via Vault:

  - `${vault_backend_path}/${DBNAME}-all-privileges` with `ALL PRIVILEGES` permissions.
  - `${vault_backend_path}/${DBNAME}-read-only` with `SELECT` permissions.

- When the intent is to use Vault, it's recommended to **NOT** provide the `plaintext_password`.

## Usage

```hcl
module "my_database" {
  source = "git@github.com:edgelaboratories/terraform-mysql-db?ref=v0.2.3"

  database = "my-database"

  # By default, the database name is used
  # user = "my-database"

  # Optional user password. Not required when using Vault roles
  plaintext_password = "a very hard to guess password"

  # Default values are utf8mb4 and utf8mb4_unicode_ci
  default_character_set = "utf8"
  default_collation     = "utf8_unicode_ci"

  # Optional
  vault_backend_path       = "mysql/my-cluster"
  vault_db_connection_name = "my-cluster"
  vault_role_default_ttl   = 3600
}
```

You can provide extra permissions for `all-privileges` or `read-only` roles with `vault_roles_extra_statements`:

```hcl
module "my_database" {
  source = "git@github.com:edgelaboratories/terraform-mysql-db?ref=v0.2.3"

  database = "my-database"

  # Optional
  vault_backend_path       = "mysql/my-cluster"
  vault_db_connection_name = "my-cluster"
  vault_role_default_ttl   = 3600

  vault_roles_extra_statements = {
    all-privileges = ["GRANT XA_RECOVER_ADMIN ON *.* TO '{{name}}'@'%';"]
    read-only      = []
  }
}
```
