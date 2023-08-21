#!/bin/bash
sudo yum update -y
sudo yum install git -y
sudo yum install yum-utils -y
sudo yum install nfs-utils -y

# Configurando o EFS
sudo yum update -y
sudo yum install -y amazon-efs-utils
sudo mkdir /efs
#colar o ponto de montagem que o serviço de EFS fornece

# Instalando docker
sudo yum update -y
sudo yum install docker -y
sudo usermod -a -G docker ec2-user


# Instalando docker-compose
sudo yum update -y
sudo curl -L https://github.com/docker/compose/releases/download/v2.5.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Ativando o serviço docker
sudo systemctl enable docker.service
sudo systemctl start docker.service