Setting up ansible on EC2

1)   Setup a new EC2 instance using Terraform.
2)   Update the instance. ``` yum update ```
3)   Add extra packages for enterprise linux.
```
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
```

4)   Install Ansible using the command below.
```
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
```

5)   Check that Ansible was installed by running - ``` ansible --version ```.
6)   Create a new user for ansible and grant admin access. 
```
useradd ansadmin -G wheel
passwd ansadmin
```

7)   Enable ssh password login to server.
```
cd /etc/ssh
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' sshd_config
```

8)   Restart the sshd service for changes to take effect immediately.
```
sudo service sshd restart
```

9)   Create the user on any node to be managed by ansible.
10)  Run the command ``` visudo ``` to manage who can use sudo without a password.
11)  Add this to the bottom of the file
```
ansadmin       ALL=(ALL)       NOPASSWD: ALL
```

12)  Repeat the same on any node(s) to be managed by ansible.
13)  Login to the ansible control server as the ansadmin user.
14)  Generate a jey by running ``` ssh-keygen ```
15)  Leave the values empty and continue through the process.
16)  Navigate to the directory and copy the internal ip address of any nodes to be managed by ansible (this can be gotten from the ec2 dashboard)
```
ls -la
cd .ssh
ssh-copy-id 172.31.83.77
```

17)  We can now attempt to login to the server via ssh without a password by simply entering the ssh and the destination internal ip address.

Recap: To login via ssh without a password, we had to:
i)    Create common users
ii)   Adding the users to the sudo group
iii)  Enabling password login
iv)   Generating and copying the user keys

18)  To run playbooks on the remote servers, we need to add the remote servers to our host file. Add the hosts at the bottom of the list following the guidelines in the document.
```
sudo vi /etc/ansible/host
```
19)  Run the command below to test that all our hosts are reachable.
```
ansible all -m ping
```

20)  To validate further, we would create a file called index.html in the ansadmin home directory, put in some content and copy it to one of our hosts. THe command below would copy the file from the source path to the destination path on all hosts.

Note: "all" can be replaced with a specific ip address of a host server.
```
ansible all -m copy -a "src=/home/ansadmin/hello.html dest=/home/ansadmin"
```
21)  Login to the web server and confirm the file has been copied.
22)  We can also install applications accross all hosts using the command below. In this case we would be installing an apache web server.
```
 ansible all -m yum -a "name=httpd state=latest" --become"
```



