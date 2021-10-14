# terraform-mysql-db

This module offers default conventions when creating a new MySQL database.

In particular:

- It creates a database 👋
- Optionally, it creates a user named after the database when not specified.
- Optionally, it create two roles to obtain credentials via Vault:

    - `${vault_backend_path}/${DBNAME}-all-privileges` with `ALL PRIVILEGES` permissions.
    - `${vault_backend_path}/${DBNAME}-read-only` with `SELECT` permissions.

- When the intent is to use Vault, it's recommended to **NOT** provide the `plaintext_password`.


## Usage

```hcl
module "my_database" {
  source = "git@github.com:edgelaboratories/terraform-mysql-db?ref=v0.1.0"

  database = "my_database"

  # The database name is used
  #user = "my_database"

  # Optional user, especially when using Vault roles
  plaintext_password = "a very hard to guess password"

  # Default values are utf8mb4 and utf8mb4_unicode_ci
  default_character_set = "utf8"
  default_collation     = "utf8_unicode_ci"

  # Optional
  vault_backend_path       = "mysql/main"
  vault_db_connection_name = "main"
}
```
