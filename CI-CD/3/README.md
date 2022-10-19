Install Jenkins on Linux EC2 Instance

Prerequisites:

i)    Terraform

ii)   Configured AWS CLI

iii)  The last lesson (#3)

Steps

1)   Review the ``` config.sh ``` file. Steps were gotten from the Jenkins installation documentation.
2)   Run the ``` terraform apply ``` command.
3)   Connect to the EC2 instance and navigate to the /var/lib/jenkins/secrets/initialAdminPassword file.
``` vi /var/lib/jenkins/secrets/initialAdminPassword ```

     Copy the content of the file. That is the admin password.
4)   Pick the public ipv4 address from the console output, append ":8080" to it and open in your web browser.
![image](https://user-images.githubusercontent.com/35563797/196590808-80883cef-dedc-4203-985e-f3f52d13db0b.png)

5)

6)

7)   Navigate to Admin. Select the configuure option. Edit the password.
![image](https://user-images.githubusercontent.com/35563797/196583883-de0e40e4-137e-4ac8-ace6-30bc1329012d.png)
![image](https://user-images.githubusercontent.com/35563797/196584016-00832945-e686-4900-a1e9-794d11fc0659.png)

8)   After saving, you would be taken back to the home page. Sign in with the new credentials.
![image](https://user-images.githubusercontent.com/35563797/196584254-8730d28f-31d2-441d-ac1d-b5c21d044a05.png)

9)   On the dashboard, navigate to "Manage Jenkins". Select "Global Tool Congifuration"
![image](https://user-images.githubusercontent.com/35563797/196584553-de3fb926-f135-457a-87b0-5d1c035aad39.png)

10)  Select the option to add JDK. Run this command to find Java paths ``` find / -name javac ```. I installed more than 1 version of Java. But ideally the path should be ``` /usr/lib/jvm/java-11-openjdk-11.0.16.1.1-1.el8_6.x86_64 ```.
![image](https://user-images.githubusercontent.com/35563797/196585288-c13a4a20-d627-4865-b792-e62995a66124.png)
![image](https://user-images.githubusercontent.com/35563797/196584860-0a8ad0cd-b719-4910-ab22-06e46552474b.png)

11)  Click on apply at the bottom of the page to save.


Optional - running a test job

1)   From the dashboard, create a new item and put in an item name. In my case I chose "Hello World". Select the option for freestyle project. Click ok.
![image](https://user-images.githubusercontent.com/35563797/196585849-1f9bf3d8-f202-4201-b84c-454e76b19ed0.png)

2)   Put in a description.
![image](https://user-images.githubusercontent.com/35563797/196586360-6d587900-0f42-4028-9f72-15e62ae75af3.png)

3)   In the build steps command, select "Execute shell command". (We chose this option because our base image is Linux, if you are running on Windows, select "Execute Windows batch command")
![image](https://user-images.githubusercontent.com/35563797/196586524-74c87fbc-7aef-41d7-8308-e10e2dc3e0eb.png)

4)   Put in the command to be run. Then, apply and save.
![image](https://user-images.githubusercontent.com/35563797/196586939-fb2af4b5-5fdf-412c-a2b4-ad43316e1018.png)

5)   Navigate to the dashboard and build the project.
![image](https://user-images.githubusercontent.com/35563797/196587167-6dd93854-b47f-4d86-ac2e-c2d1c917819f.png)

6)   The run was successful. (Notice the status change and green icon). To see the result of the build, click on console output.
![image](https://user-images.githubusercontent.com/35563797/196587374-23f1fa93-178a-4c71-ad77-90ed7875a4bc.png)
![image](https://user-images.githubusercontent.com/35563797/196587576-1adf0b0b-b3b2-4c5e-b32c-95dc46414bc0.png)



