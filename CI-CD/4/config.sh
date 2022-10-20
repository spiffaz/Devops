#!/bin/bash
sudo yum install wget git -y
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum upgrade -y
# Add required dependencies for the jenkins package
sudo yum install java-11-openjdk -y

# Install and start Jenkins
sudo yum install jenkins -y
sudo systemctl daemon-reload
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Install Maven
sudo mkdir /opt/maven/
cd /opt/maven/
sudo wget https://dlcdn.apache.org/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz
sudo tar -xvzf apache-maven-3.8.6-bin.tar.gz

# Install Git
sudo yum install git -y
