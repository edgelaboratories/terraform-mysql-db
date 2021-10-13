output "database" {
  value = mysql_database.this.name
}

output "user" {
  value = mysql_user.this.*.name
}
