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
![Uploading image.png…]()

3) Navigate to the directory where the key is located. Paste into your terminal, command prompt window or connect using your preferred SSH client. 

4) Create a new user using the user add command. The name of the user we would be creating is devopsuser. We would also be setting the password to devopsuser.
   useradd devopsuser
   passwd devopsuser
   
EC2 does not out of the box allow logins via SSH as a user so we would need to make some changes by modifying the SSH config file.
   
5) Navigate to the /etc/ssh directory.
   cd /etc/ssh
   
6) Open the sshd_config file. Search for PasswordAuthentication and change the option to yes.

7) Restart the sshd service.
   service sshd restart
   
8) Attempt to login using the created credentials.
