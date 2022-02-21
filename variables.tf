variable "database" {
  description = "The name of the database"
}

variable "user" {
  description = "Name of the main user. Defaults to the database name"
  default     = ""
}

variable "plaintext_password" {
  description = "Required to create the default user."
  type        = string
  sensitive   = true
  default     = null
}

variable "default_character_set" {
  default = "utf8mb4"
}

variable "default_collation" {
  default = "utf8mb4_unicode_ci"
}

variable "vault_backend_path" {
  type    = string
  default = null
}

variable "vault_db_connection_name" {
  type    = string
  default = null
}

variable "vault_role_default_ttl" {
  default = 3600
}

variable "vault_roles_extra_statements" {
  type = object({
    all-privileges = optional(list(string)),
    read-only      = optional(list(string)),
  })
}
