#!/bin/bash
set -ex
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
sudo yum update -y && yum upgrade -y
sudo amazon-linux-extras install docker -y
sudo service docker start && chkconfig docker on
sudo docker pull ${image_url}
sudo docker run --name akapi --restart=unless-stopped -d -p 80:80 -p 443:443 ${image_url}
