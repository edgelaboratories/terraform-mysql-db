output "database" {
  value = mysql_database.this.name
}

output "user" {
  value = local.user
}
