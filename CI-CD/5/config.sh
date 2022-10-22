#!/bin/bash

#Not to be run as script. ONly to guide in following the README.md

sudo useradd devopsuser -G wheel 
cd /etc/ssh
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' sshd_config 

psswd devopsuser #set password and unlock account

sudo yum install java-1.8* -y
sudo yum install wget git -y #Install wget
#export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.161-0.b14.e17_4.x86_64
#edit /etc/profile 

cd /opt
sudo wget https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.83/bin/apache-tomcat-8.5.83.tar.gz
tar -xvzf /opt/apache-tomcat-8.5.83.tar.gz

#ps -ef | grep tomcat   #check if running

chmod +x startup.sh #make executable
chmod +x shutdown.sh

pwd
/opt/apache-tomcat-8.5.83/bin

ln -s /opt/apache-tomcat-8.5.83/bin/startup.sh /bin/tomcatup
ln -s /opt/apache-tomcat-8.5.83/bin/shutdown.sh /bin/tomcatdown


sudo sed -i 's/8080/8090/g' server.xml

find / -name context.xml






