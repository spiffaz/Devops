Dynamic inventory

1)   Download ec2.py from - ``` https://github.com/vshn/ansible-dynamic-inventory-ec2/blob/master/ec2.py ```. Copy to the ansible server. ec2.py is a python script that communicates with AWS and pulls resource information.
2)   Download ec2.ini from - ``` https://github.com/willthames/ansible-ec2-example/blob/master/ec2.ini ```. Copy to the ansible server. ec2.ini retrieves different resource information.
3)   Create an IAM user from AWS, export secret key id and secret key. If ansible server is running in AWS, a role can be created instead.
4)   Assign the role ``` ec2 fiull access ```
5)   Attach the created role to the ansible server from the ec2 dashboard. 
![image](https://user-images.githubusercontent.com/35563797/197411501-5568489e-b8c2-4e94-9dee-43680fb88f62.png)

Note: If a user was created instead of a role, access keys would need to be exported.

6)   Change the permissions for ec2.py
```
chmod 755 ec2.py
```

7)   Test the script
```
./ec2.py --list
```
* comment out elasticcache from ec2.ini
