resource "aws_secretsmanager_secret" "database_password" {
  name_prefix = "${var.default_tags.project}-database-password-"
}

resource "aws_secretsmanager_secret_version" "database_password" {
  secret_id     = aws_secretsmanager_secret.database_password.id
  secret_string = random_password.database_password.result
}