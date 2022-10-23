Installing Tomcat on Web server

We would be building on the steps from #2 (Provisioning a web server) and would be going a step further by installing applications.

1)   Run terraform apply from the directory to provision the server.
2)   Login to the server and switch to the root user ``` sudo su ```. RUn the config.sh script.
3)   Create a password for the ``` devopsuser ``` user by running the command ``` passwd devopsuser ```. Put in a password for the user. Restart the sshd service.
```
sudo service sshd restart
```

![image](https://user-images.githubusercontent.com/35563797/197331940-2a3fa787-2215-4206-a3f5-19a6cab17348.png)

4)   Login with either the default ec2_user with key or devopsuser with the created password.
5)   Install Java
```
sudo yum install java-1.8* -y
```

6)   Get Apache Tomcat 8 link from tomcat website https://tomcat.apache.org/download-80.cgi
7)   Install wget
```
sudo yum install wget git -y 
```

8)   Change directory to /opt
9)   Download the file using wget ``` sudo wget https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.83/bin/apache-tomcat-8.5.83.tar.gz ```
10)  Unzip the file ``` tar -xvzf /opt/apache-tomcat-8.5.83.tar.gz ```
11)  Navigate to the bin forlder in the directory and notice the shell scripts for starting and stopping Tomcat. Instead of coming to this dirctory to start/stop Tomact, we will create soft link to the scripts.
12)  We want to make statup.sh and shutdown.sh executable by all users, so run the scripts below.
```
chmod +x startup.sh 
chmod +x shutdown.sh
```

13)  Get the current working directory. Get the bin directory from your home path. Run the scripts below to create a softlink from the workingdirectory to your bin path and give the shortcut a name.
```
pwd
echo $HOME
ln -s /opt/apache-tomcat-8.5.83/bin/startup.sh /bin/tomcatup
ln -s /opt/apache-tomcat-8.5.83/bin/shutdown.sh /bin/tomcatdown
```

14)  Run the command ``` tomcatup``` to start Tomcat.
15)  Use the command ``` ps -ef | grep tomcat ``` to confirm that tomcat is running.
16)  By default, Tomcat runs on 8080. But we would be changing this to 8090. If you ran the terraform commands from #2, you would have to add an additional configuration on the security group to allow traffic through the port, then run terraform apply. If you are running this manually, you can go to the AWS console and make the changes to the security group.
17)  Navigate 1 directory back to the tomcat folder. Then open the ``` conf ``` folder and edit the ``` server.xml ``` file.
18)  Change all occurences of 8080 to 8090. The script below can be used to modify all. Then restat Tomcat.
```
sudo sed -i 's/8080/8090/g' server.xml
tomcatdown
tomcatup
```

19)  Navigate to the Tomcat url on your browser. Attempt opening Tomcat manager. By default the Tomcat manager can not be accessed outside the host system. We would be changing that.
20)  Run the command to find the instances of the context.xml file under a webapps directory. ``` find / -name context.xml ```
21)  Edit all the files that show up. Comment out the below
![image](https://user-images.githubusercontent.com/35563797/197335386-4d0de6c4-7517-494c-ae81-67d28aa5e1d6.png)

22)  Restart tomcat.
23)  Create a new user by editing the ``` tomcat-users.xml ``` file in the conf directory.
24)  Insert the text below to add users. Read through the file as a guide and modify accordingly.
```
 <role rolename="manager-gui"/>
 <role rolename="manager-script"/>
 <role rolename="manager-jmx"/>
 <role rolename="manager-status"/>
 <user username="admin" password="admin" roles="manager-gui, manager-script, manager-jmx, manager-status"/>
 <user username="deployer" password="deployer" roles="manager-script"/>
 <user username="tomcat" password="s3cret" roles="manager-gui"/>
```

25)  Restart Tomcat, then attempt to login to the gui with any account with the manager-gui role.
