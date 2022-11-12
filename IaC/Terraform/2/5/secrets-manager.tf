# consul gossip key
resource "aws_secretsmanager_secret" "consul_gossip_key" {
  name_prefix = "${var.default_tags.project}-gossip-key-"
}

resource "aws_secretsmanager_secret_version" "consul_gossip_key" {
  secret_id     = aws_secretsmanager_secret.consul_gossip_key.id
  secret_string = random_id.consul_gossip_key.b64_std # reference the value stored
}

# consul bootstrap token
resource "aws_secretsmanager_secret" "consul_bootstrap_token" {
  name_prefix = "${var.default_tags.project}-bootstrap-token-"
}

resource "aws_secretsmanager_secret_version" "consul_bootstrap_token" {
  secret_id     = aws_secretsmanager_secret.consul_bootstrap_token.id
  secret_string = random_uuid.consul_bootstrap_token.id # reference the value stored
}

# consul server root ca certificate
resource "aws_secretsmanager_secret" "consul_server_root_ca_cert" {
  name_prefix = "${var.default_tags.project}-root-ca-cert-"
}

resource "aws_secretsmanager_secret_version" "consul_server_root_ca_cert" {
  secret_id     = aws_secretsmanager_secret.consul_server_root_ca_cert.id
  secret_string = tls_self_signed_cert.ca_cert.cert_pem
}