Using variables in ansible playbooks.

We would be modifying the playbook - Install_Tomcat.yml

1) Passing variables in the file.

```
---
name: install tomcat server
hosts: all
become: true
vars: 
  - tomcat_url: https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.83/bin/apache-tomcat-8.5.83.tar.gz
  - tomcat_package: apache-tomcat-8.5.83
  
tasks:
- name: install java
  ansible.builtin.yum:
    name: java
    state: latest

- name: download tomcat
  ansible.builtin.get_url:
    url: "{{ tomcal_url }}" # Because this variable starts the line, we have to put it in quotes
    dest: /usr/local

- name: extract package
  ansible.builtin.unarchive:
    src: /usr/local/{{ tomcat_package }}.tar.gz # This variable does ot start the line and does not have to be in quotes
    dest: /opt
    remote_src: yes

- name: start tomcat service
  shell: /opt/{{ apache-tomcat_8.5.83 }}/bin/startup.sh # It is best practive to have spaces before and after the variable name in quotes
```

2)   Defining variables outside the playbook.
Create a file and call it tomcat_vars. Put in the content below:
```
tomcat_url: https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.83/bin/apache-tomcat-8.5.83.tar.gz
tomcat_package: apache-tomcat-8.5.83
```

In the playbook, replace the ``` vars: ``` section with ``` vars_files: ``` and specify the variable file name.
```
---
name: install tomcat server
hosts: all
become: true
vars_file: 
  - tomcat_vars
```
