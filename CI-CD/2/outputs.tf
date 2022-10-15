output "Web_Server_ip_addr" {
  value = aws_instance.Web_Server.public_ip
}

output "public_dns" {
  value = aws_instance.Web_Server.public_dns
}
