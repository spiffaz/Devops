Simple pipeline

1)   Login to the Jenkins application.
2)   Create new job
3)   Name the job and select Maven project as the project type
4)   Select git as the source of our code. I used this repository - ``` https://github.com/ValaxyTech/hello-world.git ``` for this demo.
5)   Put in ``` clean install package ``` in the goals in the build section.
6)   Apply settings and save.
7)   Build the project. If the build is successful, our CI (Continuous Integration) is fine.
8)   Login to the Jenkins dashboard and install the ``` deploy to containers ``` plugin.
9)   Navigate to the credentials page under manage jenkins. System -> Global credentials (unrestricted) -> add credentials.
![image](https://user-images.githubusercontent.com/35563797/197378084-84575bbc-35be-47a3-ba18-d7001371344f.png)

10)  On this page, put in credentials to access our web server (Tomcat server).
Note: Any external system that jenkins would be accessing, the credentials should be setup here.
![image](https://user-images.githubusercontent.com/35563797/197378237-1cb34f12-f3c1-45fb-bff8-fcd67ff67cb8.png)

11)  Navigate to our previously created pipeline (the maven project) and select configure.
12)  In the post build actions, select ``` Deploy war/ear to a container ```
13)  Put in the relative path ``` **.*.war ``` to access the default path.
14)  Click on add to container and select the container type.
![image](https://user-images.githubusercontent.com/35563797/197378664-32628574-a0b5-4325-b875-8ba7c900898b.png)

15)  Select the credentials to use to connect and put in the url of the tomcat instance.
![image](https://user-images.githubusercontent.com/35563797/197380992-f3a337b6-2a27-4281-932c-d85d0642885e.png)

16)  Apply and save the configuration.
17)  To confirm this was successful, we can simply navigate to the web server url and add a ``` /webapp ``` and we would see it was successfully deployed.
![image](https://user-images.githubusercontent.com/35563797/197383433-abc99810-8742-498b-868f-9dc079430e90.png)

18)  To see the file on the web server, navigate to the ``` webapps ``` directory inside of the tomcat folder. RUn the command ``` ls -ltr ``` and see the date where the webapp site was created and confirm it matches with your build complete time on Jenkins.
19)  We can enable CD (continuous deployment) by modifying the build triggers in Jenkins. Navigate to the project, select configure, select the ``` Poll SCM ``` build trigger and schedule. Put in ``` */2 * * * * ```. This would check the repo for changes every 2 minutes.
20)  Change something in the repository then monitor the jenkins dashboard for when the new build is triggered.

