CI-CD with Git, Jenkins and Docker

1)   Setup a new server, preferable AWS Linux because it is easy to setup (as the Docker host) or install Docker on the current web server Web-Server. (Preferable use Ansible or write a shell script as we want all steps to be reproduceable.)
2)   Allow inbound traffic on port 8090 as we would be exposing this port for access to the Docker container.
3)   Create a new user for Docker management and add it to the Docker group.
```
useradd dockeradmin
passwd dockeradmin
usermod -aG docker dockeradmin
```

3)   Create a ``` Dockerfile ``` in the ``` opt/docker ``` directory.
4)   Paste in the content below and save.
```
mkdir /opt/docker

# Base image 
From tomcat:8-jre8 

# copy file to the container 
COPY ./webapp.war /usr/local/tomcat/webapps
```

5)  Enable password authentication.
6)  Run the command below to give ownership of the /opt/docker directory to dockeradmin. ``` chown -H dockeradmin>dockeradmin /opt/docker ```
7)  Create new Maven job on Jenkins.
8)  Put in the source repo url under source code management.
9)  For the goals of Build root POM, type in ``` clean install package ```.
10)  In the post build steps, select ``` send files or execute commands over SSH ```.
    Put in ``` webapp/target/*.war ``` as the source file.
    ``` webapp/target ``` in remove prefix. (We do not want the additional 2 directories created)
    ``` //opt//docker ``` as the remote directory.
    
    Put in the below in exec commands
    ```
    docker stop docker_demo;
    docker rm -f docker_demo;
    docker image rm -f docker_demo;
    cd /opt/docker;
    docker build -t docker_demo .
    ```

10)  Select send files or execute commands again in the build steps and execute the command below on the docker host.
```
docker run -d --name valaxy_demo -p 8090:8080 docker_demo
```

11)  Run the build, monitor the progress and validate that you are able to view the webpage on your dockerhostip:8090/webapp.
12)  Also confirm that you can see the image and container by running ``` docker ps ``` and ``` docker images ``` on the docker host.
