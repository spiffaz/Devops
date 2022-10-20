Installation of Maven and Git

We would be using the server provisioned for the last lesson as our base. A few commands were added to the ``` config.sh ``` file to install dependencies. The file can be updated and the ``` terraform apply ``` command can be run. Or you can login to the Jenkins server and manually run the commands.
If you ran terraform apply, follow through the steps and validate that all the steps below were applied automatically.

1)   Creaate a directory called ``` maven ``` in the ``` /opt ``` directory.
```
sudo mkdir /opt/maven/
```

2)   Navigate to the directory
```
cd /opt/maven/
```

3)   Download the binary files using the command below. (The url might change, see a link to the maven documentation here - https://maven.apache.org/download.cgi)
```
sudo wget https://dlcdn.apache.org/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz
```

4)   Unzip the file
```
sudo tar -xvzf apache-maven-3.8.6-bin.tar.gz
```

5)   Navigate into the folder. In my case the folder is named ```apache-maven-3.8.6```.
```
cd apache-maven-3.8.6
```

6)   Get the current working directory, this would be used on out Jenkins configuration.
![image](https://user-images.githubusercontent.com/35563797/196863573-819a51f0-b75e-42be-8f0f-0a5399e31ac3.png)
``` /opt/maven/apache-maven-3.8.6 ```

7)   Install git
```
sudo yum install git -y
```

8)   Login to the Jenkins application.

9)   Navigate to ``` manage jenkins ```. 

10)  Select ``` manage plugins ```.

11)  Select ``` install plugins ```.

12)  Search for the ``` maven integration ``` plugin. Then click on install without restart.
![image](https://user-images.githubusercontent.com/35563797/196864684-1b71a86a-cd96-403f-b975-f5b40b5c036a.png)
![image](https://user-images.githubusercontent.com/35563797/196864820-f13c6e34-ff33-4704-80fa-c15093d9d245.png)

13)  Search for the ``` github plugin ``` then install without restart.

14)  Navigate to the ``` Global tool configuration ``` admin menu.

15)  Select the option to add maven. Put in maven as the name and the earlier path gotten from the sorver as the maven home path.
![image](https://user-images.githubusercontent.com/35563797/196865380-ea9eb77f-b71f-4bdb-b660-dcf15f2e1398.png)

15)  Click on apply to apply the configuration.

16)  For the git configuration in the global tool configuration configuration, at this point we do not need to make any changes, so we would be sticking with the default values.

To test our installation we would be creating a new item to build a simple hello world java program.

17)  Navigate to the dashboard and select new item.

18)  Put in an application name, select Maven project then ok.
![image](https://user-images.githubusercontent.com/35563797/196866270-421c0e2f-1a78-445d-9a5b-6405eb0ffe07.png)

19)  Put in the source of your code. In this case we are using Github. So select the Git option. If your repository is private you would need to provide authentication details.
     I would be using source code from this repository - https://github.com/arsr319/maven-hello-world.git
![image](https://user-images.githubusercontent.com/35563797/196867236-d6865fef-17b4-4a97-b0d3-c211bcae9761.png)

20)  Under the goals section of the build stage, type in ``` install package ```.
![image](https://user-images.githubusercontent.com/35563797/196867440-0dcf6a6a-382c-48eb-921c-326ba2cbb430.png)

21)  Scroll to the bottom, then apply and save. (After we successfully test, you can go back and play around with other settings)

22)  Run the build. It might take a while because this is our first build and dependencies would have to be installed.

Once complete, lookout for the response in the log.





