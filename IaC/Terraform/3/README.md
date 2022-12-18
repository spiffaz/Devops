# Import resources into Terraform

Prerequisites:
1) AWS account
2) AWS CLI (must be logged in)
3) Terraform CLI
4) Create a new terraform workspace and name it accordingly as this would be used for the environment tag in this guide.

   ``` terraform workspace new Production ```

## Terraform import syntax
Terraform allows you to import resources created outside Terraform. 

Importing resources only imports the state. The configuration has to be manually writen. This helps Terraform to identify and map the resource to be imported.

The syntax to import a resource into Terraform is - ``` terraform import [options] ADDRESS ID ```.

PS - You are alowed to use Terraform options in the import syntax. A use case for this is including a variable file in the import process.

The "ADDRESS" is the Terraform resource identifier. For example, a resource of type "aws_autoscaling_group" and name "app_server" would have an address of aws_autoscaling_group.app_server.

The "ID" specified is the id of the resource from the provider. For example, the id of the aws subnet below is subnet-0a751182e85ba7d82.

![image](https://user-images.githubusercontent.com/35563797/208299290-7caffb62-edc5-4646-a5d2-071f89e8149a.png)

It is also important to note that resources can also be imported into a module. To import a resource into a module, the address should have the prefix "module.". For example ``` "module.vpc.aws_route_table.private[2]" ```.

We would be using AWS for this demo. Lets begin importing resources into Terraform!

## Importing resources
1)   Download the Terraform configuration files in the repository and run ``` terraform apply ```.    
     This would create 2 private subnets and 2 public subnets using version 2 of the "terraform-aws-modules/vpc/aws" module.
2)   Run the create.sh script in the repository to create new resources. If you are using a Windows machine or have difficulties running the scripts, manually create the resources using the AWS console. For this demo we are creating the resources below:

     i)    1 private subnet
     
     ii)   1 private route table
     
     iii)  1 public subnet
     
     iv)   Associate the bublic subnet to the public route table
     
     v)    Associate the created provate subnet to the created provate route table
     
     Quick troubleshooting guide - If you get an access denied error, check the permissions on the file. This can be checked with the ``` ls -lrt ``` command. If there are no execute permissions on the file, the permissions can be changed with the command ``` chmod +rwx create.sh ```.
3)   Update the terraform.tfvars file and increase the subnet count to 3. This would increase the number of resources to be created.
4)   Add the CIDR ``` "10.0.12.0/24" ``` to the private subnet list in the same file.
5)   Add the CIDR ``` "10.0.2.0/24" ``` to the public subnet list.
6)   Run the ``` terraform plan ``` command to generate terraform resource identifiers for the new resources to be imported.
7)   Pick the resource id for all resources that are to be added. (A sample id is highlighted in blue below)
     ![image](https://user-images.githubusercontent.com/35563797/208300292-25abc71a-50d4-4825-901c-fcb817cae3e1.png)
8)   If you ran the script earlier, the ids of the resources would have been displayed as part of the results. However, the id of all the created resources can be gotten from the aws console.
9)   Review the created resources on the AWS console. Notice that there are no names or tags.
10)  Prepare the import commands with the previously shared syntax and run on the CLI. In my case, see the import statements below.
     ```
     terraform import --var-file="terraform.tfvars" "module.vpc.aws_route_table.private[2]" rtb-0859595ac01737891
     terraform import --var-file="terraform.tfvars" "module.vpc.aws_route_table_association.private[2]"  subnet-0906cd35f0a01fa1a/rtb-0859595ac01737891
     terraform import --var-file="terraform.tfvars" "module.vpc.aws_subnet.private[2]" subnet-0906cd35f0a01fa1a
     terraform import --var-file="terraform.tfvars" "module.vpc.aws_route_table_association.public[2]" subnet-08c0f6010a20ba81d/rtb-0cfa3841fc73caebd
     terraform import --var-file="terraform.tfvars" "module.vpc.aws_subnet.public[2]" subnet-08c0f6010a20ba81d
     ```
11)  You should get a successful response like the below for every resource imported.
     ![image](https://user-images.githubusercontent.com/35563797/208300616-57d4c2b6-c61a-4993-804c-badcde53de4a.png)
12)  After importing all the resources successfully. Run the ``` terraform apply ``` command. This would apply our configuration to the newly imported resources. Because the resources already exist, we should see that the resources are to be changed (no creation or destruction). 
13)  Review the resources on the AWS console. Look out for the updated names and tags.

Thank you for following this mini tutorial on how to import resources into Terraform!
