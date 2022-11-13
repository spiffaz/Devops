#!/bin/bash
sudo su
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
echo ' <html><body><h1> Check out my page for AWS 3 Tier Architecture </h1></body></html> ' >> /var/www/html/index.html