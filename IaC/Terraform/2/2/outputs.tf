output "client_lb_dns" {
    value = aws_lb.client_lb.dns_name
    description = "Display dns name of client lb"
}