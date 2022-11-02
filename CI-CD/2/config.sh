  #!/bin/bash
  sudo useradd devopsuser -G wheel #Create a user and add to the wheel group. (The wheel group allows users use the sudo command, sudoers)
  cd /etc/ssh
  sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' sshd_config #This command searches for all occurences of string 'a' and replaces with 'b'
  service sshd restart
