#!/bin/bash
sudo yum update -y
sudo yum install yum-utils -y
sudo yum install nfs-utils -y

# Instalando docker
sudo yum update -y
sudo yum install docker -y
sudo usermod -aG docker $USER


# Instalando docker-compose
curl -L https://github.com/docker/compose/releases/download/v2.5.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Ativando o serviço docker
sudo systemctl enable docker.service
sudo systemctl start docker.service