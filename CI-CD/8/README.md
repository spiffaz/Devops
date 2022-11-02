We would be continuing from the previous.

1)   Add the plugin ``` Publish over ssh ``` to Jenkins.
2)   Copy the playbook to the ``` opt/playbooks ``` directory.
3)   On the Ansible server, navigate to the Ansible host folder and add a category for ``` web-servers ```. Put the Tomcat server ipaddress in the category.

     The idea is to have Jenkins drop the Jar file from the build in a directory on the Ansible server. When this is done, we want Jenkins to run the playbook to complete the deployment.

4)   Next we configure. Navigate to the system configuration page. We would be giving the Jenkins server access to execute playbooks on the remote Ansible server.
5)   We would be using passwords via SSH for the publish over ssh plugin. Put in the server name, the private ip, the ansadmin user name and the password. To put in the password, select the advanced option and check the box for password based authentication.
6)   Test the configuration, then apply.
7)   Modify the Jenkins job from #6. Under post build actions, delete the deploy to container plugin.
8)   Add a post build step. Select ``` send file or execute commands over ssh ```.
9)   Select the target server.
10)  The built file usually drops in the ``` webapps/target ``` directory. Set the target to be ``` webapps/target/*.war ```.
11)  Set the remote directory to ``` //opt/playbooks ```. This is where the file would be copied to on the Ansible server.
12)  Add a new post build step of the same type. Under exec command, put in the command below to execute the Ansible playbook. We are seperating this because it is best practice to separate every action.
```
ansible-playbook /opt/playbooks/copyfile.yml
```

13)  Apply and save.
14)  Execute the uild job.
15)  On the Web server, navigate to the directory and confirm the last modified date. This should be the same as the time on the Jenkins log.
