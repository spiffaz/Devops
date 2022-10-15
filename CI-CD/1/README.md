Manually setting up an AWS EC2 instance

In this tutorial, we would be provisioning a Linux server on AWS.
To follow this, you would need to setup an AWS account. You can sign up for the free tier and follow the steps below.

1) Log into the AWS console, search for and select EC2.
![image](https://user-images.githubusercontent.com/35563797/195977241-3bc8bc94-4a06-4e7d-81c8-3621356092af.png)

2) Click on Launch Instance.
![image](https://user-images.githubusercontent.com/35563797/195977289-7b26363f-d422-40a1-a1a2-e4606a937a1d.png)

3) Put in Web Server as the name of the server. (Because we are creating a Web Server).
![image](https://user-images.githubusercontent.com/35563797/195977346-affec6bb-de8a-4219-9d6b-9de7b94bc592.png)

4) Select Red Hat Linux AMI (Amazon Machine Image) as our Base Image.
![image](https://user-images.githubusercontent.com/35563797/195977894-b2ce6267-0e4e-4285-89b0-067db70fd308.png)

5) Ideally we should select an instance type, but we would select the default (t2.micro) which is Free Tier eligible. We would also need to create a key pair.
   Select the create new key pair option.
   
   ![image](https://user-images.githubusercontent.com/35563797/195978133-9939be24-9e44-459e-8993-335118180200.png)

6) Put in a Key pair name. We would be using this for the entire project. Select the key type and create the key.
![image](https://user-images.githubusercontent.com/35563797/195978625-21e017dd-e678-4e69-86c3-1dc80e17d085.png)

7) We would keep the default network settings and create a Security group with the defaults. Also select the defaults for storage.
   The free tier allows up to 30gb of free storage. The instance would take 10 gb of memory.
   
8) Launch instance.


Optional: Creating a user to enable login via SSH (Login without a keypair)

1) Navigate to the EC2 Dashboard. Select the checkbox beside the newly created server. Click on connect from the top right.

2) Click on the SSH option and copy the example command.
![image](https://user-images.githubusercontent.com/35563797/195987253-d1f91169-92b2-4b52-ac67-8b570658c700.png)

3) Navigate to the directory where the key is located. Paste into your terminal, command prompt window or connect using your preferred SSH client. 

   ![image](https://user-images.githubusercontent.com/35563797/195987297-a87b5501-a675-481f-ac8d-e465bf49c6c4.png)


4) Create a new user using the user add command. The name of the user we would be creating is devopsuser. We would also be setting the password to devopsuser.
Note: We use sudo because the default user (ec2-user) is not an amdinistrator. (If you are new to Linux, sudo is the same as right clicking and selecting run as admin in Windows)
   sudo useradd devopsuser
   sudo passwd devopsuser
![image](https://user-images.githubusercontent.com/35563797/195987477-05827155-31e5-4dee-9a95-c433022bbe33.png)
![image](https://user-images.githubusercontent.com/35563797/195987523-66f8f6cd-4dae-4a85-b9b0-78afe23d7b0a.png)
   
EC2 does not out of the box allow logins via SSH as a user so we would need to make some changes by modifying the SSH config file.

5) Switch to the root user. 
Note: The '#' sign indicates that the current user is a root user. '$' is a regular user.
   sudo su
![image](https://user-images.githubusercontent.com/35563797/195987774-7e592a9a-5561-45ee-bd0a-a74fb1f6c206.png)

6) Navigate to the /etc/ssh directory.
   cd /etc/ssh
![image](https://user-images.githubusercontent.com/35563797/195987871-04afb73a-59f3-4cd8-831e-d4544ec30b7f.png)
   
7) Open the sshd_config file. Search for PasswordAuthentication and change the option to yes.
![image](https://user-images.githubusercontent.com/35563797/195988083-80dd212d-ed4a-4425-a376-746f44725a5c.png)

8) Restart the sshd service.
   service sshd restart
   
   ![image](https://user-images.githubusercontent.com/35563797/195988157-1daefe2c-9fbc-4de4-8295-70d73e86a063.png)
   
9) Go back to the AWS EC2 dashboard and pick the public ipv4 address of the Web Server.
![image](https://user-images.githubusercontent.com/35563797/195988383-ea8d4af7-ea9c-4ae6-abfc-fc7c2a76ac1e.png)

10) Attempt to login with the new credentials with your favorite ssh client.
![image](https://user-images.githubusercontent.com/35563797/195988495-1ea992e1-e969-4cb0-b6be-e80adff5cf31.png)


