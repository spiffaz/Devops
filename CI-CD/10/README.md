1)   Create an account in dockerhub.
     ![image](https://user-images.githubusercontent.com/35563797/199482355-f3d23243-3215-4f08-8e7a-c655a1e34d13.png)
2)   Install Docker and login to docker hub on the ansible server.
3)   Create a new item in Jenkins. We would be creating a Maven project.
4)   Put in the repository url and branch to build in source code management.
5)   Put in ``` clean install package ``` in the goals and options of the build section.
6)   In the post build steps, select "Send files or execute commands over SSH". 
     ```
     Source files : webapp/target/*.war
     Remove prefix : webapp/target
     Remote directory : //opt//docker
     ```
     
7)   Select "Send files or execute commands over SSH" again.
     ```
     Source files : Dockerfile
     Remote directory : //opt//docker
     Exec Command:
       cd /opt/docker
       docker build -t dockerans_demo .
       docker tag dockerans_demo spiffaz/dockerans_demo
       docker push spiffaz/dockerans_demo
       docker rmi dockerans_demo spiffaz/dockerans_demo
     ```
     
8)   Run the build.
9)   Login to Docker and confirm that the the image was pushed.

Troubleshooting guide:

If you are not able to run Docker commands without sudo, restart the server for the addition to the Docker group to take effect.

If you get a pemission error while running the job, check and confirm the ownership of the folder. This can be done by running ``` ls -ltr ```.
The ownership can be changed using ``` sudo chown -R owner:group DirectoryName/ ```

10)  Navigate to the path of your playbooks ``` /home/ansadmin/playbooks ``` and create a file called ``` create_docker_container.yml ```.
```
  ---
  - hosts: docker_hosts
    become: true
    tasks:
     - name: stop previous version docker
       shell: docker stop dockerans_demo
     - name: remove stopped container
       shell: docker rm -f dockerans_demo	  
     - name: remove docker images
       shell: docker image rm -f spiffaz/dockerans_demo    
     - name: create docker image
       shell: docker run -d --name dockerans_demo -p 8090:8080 spiffaz/dockerans_demo
```

11)  Add a new post build step to the Jenkins job.  
12)  ```
     Exec Command:
       cd /home/ansadmin/playbooks
         ansible-playbook create_docker_container.yml
     ```
     
13)  Run and check the docker host if the changes were made.
Troubleshooting guide - 
Modify the file in the directory ``` /etc/sudoers.d ``` to allow ansadmin run sudo commands without putting in a password on the remote machines.
 
Run only the last command in the playbook at the first attempt.
 
14) To ensure that we would be able to roll back to a previous version in the case there is an issue with the buld we will be adding versioning. Looking at the Dockerhub dashboards, there is only 1 build which is always he latest after every run.
![image](https://user-images.githubusercontent.com/35563797/199669446-25648b58-65a4-4058-97ad-108720170325.png)

15)  Modify the "Send files or execute commands over SSH" with the Dockerfile to the below:
```
cd /opt/docker
docker build -t $JOB_NAME:v1.$BUILD_ID .
docker tag $JOB_NAME:v1.$BUILD_ID spiffaz/$JOB_NAME:v1.$BUILD_ID
docker tag $JOB_NAME:v1.$BUILD_ID spiffaz/$JOB_NAME:latest
docker push spiffaz/$JOB_NAME:v1.$BUILD_ID
docker push spiffaz/$JOB_NAME:latest
docker rmi $JOB_NAME:v1.$BUILD_ID spiffaz/$JOB_NAME:v1.$BUILD_ID
spiffaz/$JOB_NAME:latest
```
 
16)  We then proceed to change the image name from the playbook. The image name would be changed from (in my case) spiffaz/dockerans_demo to spiffaz/docker_project-4:latest with "docker_project-4" being the Jenkins job name.
![image](https://user-images.githubusercontent.com/35563797/199670538-d66daebd-6a4b-49cb-9ec1-dcbc9a72b4d9.png)

17)  Runt he build again and confirm there are multiple versions on Dockerhub.
 
 
 
 
 
 
 
 
 
