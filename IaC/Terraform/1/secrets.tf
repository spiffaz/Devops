resource "random_password" "database_password" {
  length           = 16
  special          = false
}