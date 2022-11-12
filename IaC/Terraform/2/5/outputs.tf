output "client_lb_dns" {
  value       = aws_lb.client_lb.dns_name
  description = "Display dns name of client lb"
}

output "consul_bootstrap_token" {
  description = "The Consul Bootstrap token.  Do not share!"
  sensitive   = true
  value       = random_uuid.consul_bootstrap_token.result
}

output "consul_server_endpoint" {
  description = "The ALB endpoint for the Consul Servers."
  value       = aws_lb.consul_server_lb.dns_name
}