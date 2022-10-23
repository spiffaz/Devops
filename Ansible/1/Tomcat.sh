#!/bin/bash
sudo yum install java -y
sudo yum install wget git -y 
cd /opt
sudo wget https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.83/bin/apache-tomcat-8.5.83.tar.gz
tar -xvzf /opt/apache-tomcat-8.5.83.tar.gz
cd /opt/apache-tomcat-8.5.83/bin
./start.sh
