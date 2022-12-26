# Terraform in CICD
## This is a VERY rough draft

Jenkins

Stages - check in, init, validate, plan, approve, apply

Considerations
Plugins
Workspaces
Remote state
Output control
Deployment pattern - manual review or automated
error handling - console or remote

TF-IN-AUTOMATION = TRUE (Any value is true)
TF_LOG (ENABLE CONSOLE LOGGING)
TF_LOG_PATH (ADD DATE)
TF_INPUT = FALSE (CANCELS AT ANY USER INPUT)
--TF_VAR_NAME (ENV VARIABLES)

If Jenkins not installed, use docker

# Create a Jenkins container
```
docker pull jenkins/jenkins:lts
docker run -p 8080:8080 -p 50000:50000 -d -v jenkins_home:/var/jenkins_home --name jenkins jenkins/jenkins:lts
docker logs jenkins
```

#Copy the admin password
http://127.0.0.1:8080

![image](https://user-images.githubusercontent.com/35563797/209581432-23c73944-6510-4158-af7e-bfa84db032df.png)

Walk through the prompts:
# Install suggested plugins
# Create a user
# Manage jenkins
# Manage plugins
# Search for Terraform in Available and install without restart
![image](https://user-images.githubusercontent.com/35563797/209576173-024dbeae-0e70-444d-9482-b6e20b9fb712.png)

# Back to Manage jenkins
# Navigate to Global Tool Configuration and select Terraform. Put in a name. We would be installing automatically, put in a version suitable for your OS.
![image](https://user-images.githubusercontent.com/35563797/209576413-59983a4d-dc91-4396-ab15-9013cdff1fd2.png)


# Add Terraform
# Name: terraform 
# Install automatically
# Version - latest for linux (amd64)
# Click Save


Navigate to manage credentials, global, add credentials.
put in your aws credentials, type secret text
# Create a credential of type secret text with ID aws_access_key and the access key as the secret
# Create a credential of type secret text with ID aws_secret_access_key and the access secret as the secret

Different credentials for workloads? Create different jenkins credentials and reference in Jenkinsfile

![image](https://user-images.githubusercontent.com/35563797/209576617-21952411-9c29-41bb-b184-ca75d8f093ad.png)
![image](https://user-images.githubusercontent.com/35563797/209576751-0375156e-8743-4f1b-a50c-43336c54bb0d.png)

# Create a new item
# Name: TerraformNetworking
# Type pipeline

Navigate to Advanced project options and select Pipeline script from scm
![image](https://user-images.githubusercontent.com/35563797/209579209-d3bd5118-3982-49fe-9259-e531e3805c1e.png)
![image](https://user-images.githubusercontent.com/35563797/209579314-efc88fe6-eb30-4c29-a348-95769efb20bc.png)

![image](https://user-images.githubusercontent.com/35563797/209579339-a7c4608c-e339-456c-a770-dbbfca1d9608.png)


# Select poll SCM
# Definition: Pipeline script from SCM
# SCM: Git
# Repo URL: YOUR_REPO_URL or https://github.com/ned1313/Deep-Dive-Terraform.git
# Script path: m8/applications/Jenkinsfile
# Uncheck lightweight checkout


