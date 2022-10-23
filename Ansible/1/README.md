We would be converting a shell script that installs Apache Tomcat into an ansible playbook.

The shell script is called install Tomcat.sh

Every yaml file begins with ``` --- ```.
We would begin with a name for our playbook. We would also indicate the hosts we want the playbook to apply to. We should also specify ``` become: true ``` because we want our script to run with sudo priviledges.
```
---
name: install tomcat server
hosts: all
become: true
```

1)  ``` sudo yum install java -y ```
To install java we would use the ansible.builtin.yum module. This can be used to install aplications. Documentation can be found here - https://docs.ansible.com/ansible/latest/collections/ansible/builtin/yum_module.html

```
tasks:
- name: install java
  yum:
    name: java
    state: latest
```

2) Donwloading the Tomcat package
``` 
sudo yum install wget git -y 
cd /opt
sudo wget https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.83/bin/apache-tomcat-8.5.83.tar.gz
```
To download we would be using the ansible package ``` ansible.builtin.get_url ```. This can be used to download files and also specify what directory the file should be downloaded to. See the official documentation here - https://docs.ansible.com/ansible/latest/collections/ansible/builtin/get_url_module.html

```
- name: download tomcat
  ansible.builtin.get_url:
    url: https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.83/bin/apache-tomcat-8.5.83.tar.gz
    dest: /usr/local
```

3) ``` tar -xvzf /opt/apache-tomcat-8.5.83.tar.gz ```
To unzip the package, we would use the ansible module ``` ansible.builtin.unarchive ```. This module allows us to unzip a file and specify the directory where we want the file to unzip in.
Note: By default, the initial file specified is on the ansible server. We would have to specify if we want the file to be from the remote host. Therefore, we add a configuration to let us know that we are executing this on the remote host.
```
- name: extract package
  ansible.builtin.unarchive:
    src: /usr/local/apache-tomcat-8.5.83.tar.gz
    dest: /opt
    remote_src: yes
```

4) Final step is to start the service. To do this we would be using the ``` ansible.builtin.shell ``` module which allows us to run shell scripts.
``` 
cd /opt/apache-tomcat-8.5.83/bin
./startup.sh
```

Our yaml equivalent would look like this:
```
- name: start tomcat service
  shell: /opt/apache-tomcat-8.5.83/bin/startup.sh 
```

The complete playbook is saved with the name Install_Tomcat.yml
