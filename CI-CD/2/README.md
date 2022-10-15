Provisioning a Web server using Terraform

The first lesson covered how to manually create an EC2 instance on AWS. In this lesson we would be automating the process using Terraform and the AWS CLI.

1)  To install Terraform on your choice OS, follow the instructions from the Terraform documentation here -> https://learn.hashicorp.com/tutorials/terraform/install-cli

2)  Install and configure the AWS CLI. Follow the AWS documentation. If you are using any AMI, the AWS CLI would be installed. Follow the steps from the point of configuring the CLI. Find the link to the documentation here -> https://docs.aws.amazon.com/cli/latest/userguide/getting-started-quickstart.html
Best practice is to create an iam user for terraform on AWS with only the required permissions. The credentials of the user should be used to setup the AWS CLI.

3)  Create a new directory and create a file called 'main.tf' in it. Terraform projects are initiated per directory. Terraform reads all the files with the .tf extension. Terraform is able to automatically detect the order in which it should create resources. However, note that in AWS there are some resources that the order needs to be defined explicitly. These resources state them in the documentation.

4)  In the main.tf file. Create a Terraform block. Under the Terraform block, we specify the providers we want to create resources in. A provider can be AWS, Azure, GCP, Kubernates, etc.
    We also have to provide the source of the provider. This could be a public source on the Terrafrom registry or a private source.
    It is best practice to specify the version of the provider and Terraform version to be used.

```
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.2.0"
}
```

5)   We can also specify provider specific details under the providers section. In this case we would be specifying the default region where all AWS resources would be created except explicitly stated in the resource configuration.

```
provider "aws" {
  region = "us-east-1"
}
```

Note: Terraform resources are defined with the "resource type" and a given "resource name". This is constant regardless of what provider is being used. Any configurable option that is not defined during resource creation is automatically set to the default value.

6)   We create a security group to attach the server we are creating to. In AWS security groups are virtual firewalls for EC2 instances that permit or refuse incoming and outgoing traffic. 
The resource type is aws_security_group and the given name is Web-Server-Security-Group. The name defined inside the resource is a tag that would be assigned to the AWS EC2 instance.

     We also need to configure rules for the security group. For this demo, we would allow all inbound traffic on port 22 and all outbound.
     
     
```
resource "aws_security_group" "Web-Server-Security-Group" {
  name = "Web-Security-Group"
}

resource "aws_security_group_rule" "allow_TLS_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.Web-Server-Security-Group.id

  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_all_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.Web-Server-Security-Group.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}     
```

7)   In this step we create an AWS instance and pass in user data to configure the creation of a new account, addition of the account to the sudoer group and enablig connecting with a password via ssh.

```
resource "aws_instance" "Web_Server" {
  ami           = "ami-06640050dc3f556bb"  
  instance_type = "t2.micro"
  security_groups = [aws_security_group.Web-Server-Security-Group.name] 
  key_name = "CICD" # We would be using the key pair created in the previous lesson to authenticate a connection to the server
  user_data = "${file("config.sh")}" # Aws
  
  tags = {
    Name = "Web Server"
  }
}
```

``` ami = "ami-06640050dc3f556bb" ``` Here we are provisioning an Amazon Red Hat Linux instance

``` security_groups = [aws_security_group.Web-Server-Security-Group.name] ``` Here we are adding the server to the earlier created security group

``` key_name = "CICD" ```  We are using the key pair created in the previous lesson to authenticate a connection to the server

``` user_data = "${file("config.sh")}" ``` AWS provides an option to run commands at the point of initializing servers. We are running a shell script in the same directory. The script is included in this directory of the repo.

8)   Create a file called outputs.tf to store all the values we want to see from the Terraform execution. Paste in the following code.

```
output "Web_Server_ip_addr" {
  value = aws_instance.Web_Server.public_ip
}

output "public_dns" {
  value       = aws_instance.Web_Server.public_dns
}
```

9)   Run the ``` terraform validate ``` command. This would validate that the terraform files in the directory are valid.

10)  Run the ``` terraform fmt ``` command to properly format the terraform files.

11)  Run the ``` terraform plan ``` command to see a step by step of what would be created.

12)  Run the ``` terraform apply ``` command then select true to apply the terraform configuration to AWS.

13)  Check the AWS EC2 dashboard to confirm the instance was created.

14)  On the AWC EC2 dashboard, validate that all the configurations from the terraform file are in place. Login to the instance and confirm the users were created and the user belongs to the sudoers group.

     To get a list of users on the instance, run this command.

```
cut -d: -f1 /etc/passwd
```

    To confirm the user belongs to the goup, run this command.

```
cut -d: -f1 /etc/group
```

15)  To review outputs, run the ``` terraform outputs ``` command.

16)  Run ``` terraform destroy ``` to delete all created resources.
