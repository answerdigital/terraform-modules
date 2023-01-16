#!/bin/bash
set -ex
# Ouput all log
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
sudo yum update -y && yum upgrade -y
sudo amazon-linux-extras install docker -y
sudo service docker start && chkconfig docker on
sudo usermod -a -G docker ec2-user
#sudo curl -L https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
#sudo chmod +x /usr/local/bin/docker-compose
sudo docker pull ghcr.io/bethcryer/answerking-cs-beth:refs-heads-develop
sudo docker run --name akapi --restart=unless-stopped -d -p 80:80/tcp ghcr.io/bethcryer/answerking-cs-beth:refs-heads-develop