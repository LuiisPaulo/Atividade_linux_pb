Autor: Luis Paulo Lopes Gonçalves

* Requisitos:
  - Conhecimento básico em AWS.
  - Conhecimento básico de Docker.
  - Conhecimento básico em Linux.


* Objetivo: 
  - Criar uma arquitetura no sistema da AWS, onde deve-se subir dois servidores rodando um container com uma aplicação Wordpress em cada um deles, ambos os containers devem fazer conexão com o banco de dados dísponivel pelo AWS por meio do serviço Amazon RDS, as instâncias devem estar na mesma VPC, onde o controle de tráfego de acesso do cliente com a aplicação seja intermediada por um ELB, além de aplicar escalabilidade nas aplicações.


* Passo 1 - Criar um VPC (Virtual Private Cloud):
  -
* Passo 2 - Criar uma instância EC2 (Amazon Elastic Compute Cloud):
  -
  
* Passo  - Configuração do Grupo de Segurança (Security Group):
  -

* Passo  - Criando um Elastic IP, para configuração da instância EC2 (Amazon Elastic Compute Cloud):
  - 

* Passo  - Instalando o Docker na instância EC2 (Amazon Elastic Compute Cloud):
  -
    - Para a realização do Docker, você precisa concetar-se a instância EC2, você pode realizar esse acesso via console da AWS, ou por meio da chave de SSH, também pode acessar a instância via .ppk pelo Putty.
        - Após se conectar com a instância, realize a seguinte sequências de comandos para instalar e configurar o Docker em sua instância EC2.
     
      1. Instalando o Docker:

              sudo yum update -y
              sudo yum install docker -y

      2. Dando permissão ao Docker:

              sudo usermod -a -G docker ec2-user
          
      3. (Observação) caso tenha algum erro de permissão como //var/run/docker.sock, execute o seguinte comando:

              sudo chmod 666 /var/run/docker.sock

      4. Iniciando o serviço Docker:

              sudo systemctl enable docker.service
              sudo systemctl start docker.service

      5. Verifique se o serviço está ativo:

              sudo systemctl status docker.service

      6. (Opcional) Para testar o Docker, você pode fazer a execução de uma imagem:

              docker pull hello-world

        - Saída do comando: 
* Passo  - Instalando o Docker Compose na instância EC2 (Amazon Elastic Compute Cloud):
    - 
  - Após fazer a instalação do Docker na sua instância EC2, vamos instalar o nosso Docker Compose para criarmos nosso .yml (.yaml) que conterá nossa imagem personalizada do Wordpress:
      
      1. Instalando o Docker Compose?

              sudo yum update -y
              sudo curl -L https://github.com/docker/compose/releases/download/v2.5.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose

      2. Dando permissões pro Docker Compose:

              sudo chmod +x /usr/local/bin/docker-compose

* Passo  - Criar um Docker Compose:
    -
    - Para criarmos o nosso Docker Compose, iremos utilizar um editor de texto no terminal do Linux, no exemplo do Docker Compose, foi utilizado o nano.
    - O arquivo deve terminar com .yml ou .yaml.

      1. Criando um diretório novo para armazenarmos o nosso Docker Compose:

             sudo mkdir /nome/do/diretório
             cd /nome/do/diretório

      3. Criando o arquivo do Docker Compose:

             nano docker-compose.yml

      4. Criando o Docker Compose:

             version: '3.8'
             services:
               wordpress:
                 image: wordpress
                 restart: always
                 volumes:
                   - /efs/siteweb:/var/www/html
                 ports:
                   - "80:80"
                 environment:
                   TZ: America/Sao_Paulo
                   WORDPRESS_DB_HOST: AWS RDS Endpoint
                   WORDPRESS_DB_USER: user BD RDS
                   WORDPRESS_DB_PASSWORD: password BD RDS
                   WORDPRESS_DB_NAME: name DB RDS
                   WORDPRESS_TABLE_CONFIG: wp_

         5. Após salvar o Docker Compose criado, vamos executar nosso arquivo .yml/.yaml, dentro do próprio diretório do Docker Compose execute o comando:

                docker-compose up -d

          6. Depois de executar o comando, irá baixar a imagem e subir o serviço que configuramos no nosso Docker Compose.
          7. Verifique se o serviço está no ar pesquisando o ip da sua instância com :80 no final do endereço ip.
          8. Para visualizar o volume criado, execute os comandos abaixos:

                  cd /efs && ls /efs
          9. Entre no diretório que foi criado, como no docker compose o diretório que foi criado para armazena os volumes foi siteweb, portando vamos utilizar os comandos para entrar no diretório e visualizar seus arquivos:
        
                  cd siteweb/
                  ls 

* Passo  - (Opcional) Instalação do Docker, Docker Compose e suas respectivas configurações via script no user_data (dados do usuário):
    - Podemos automotizar o processo de instalação e configuração do Docker e do Docker Compose quando formos subir nossa instância EC2.
    - Para adicionarmos o script há instância, vá em detalhes avançados da instância e vá no tópico de user data, e vamos importar o script ou colar-ló.
 
          #!/bin/bash
          sudo yum update -y
          sudo yum install git -y
          sudo yum install yum-utils -y
          sudo yum install nfs-utils -y
          sudo yum install amazon-efs-utils -y

          # Instalando e Configurando o docker
          sudo yum update -y
          sudo yum install docker -y
          sudo usermod -a -G docker ec2-user

          # Instalando e Configurando o docker compose
          sudo yum update -y
          sudo curl -L https://github.com/docker/compose/releases/download/v2.5.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
          sudo chmod +x /usr/local/bin/docker-compose

          # Ativando o serviço docker
          sudo systemctl enable docker.sevice
          sudo systemctl start docker.service

    - (Observação) Caso a permissão do docker não funcione, execute o seguinte comando abaixo, com a instância já rodando e você estando conectada a ela:

          sudo chmod 666 /var/run/docker.sock

    - Após colar o script no user data, basta iniciar a instância.

* Passo  - Criar um EFS (Amazon Elastic File System):
    - 

* Passo  - Criar um RDS (Amazon Relational Database Service):
    - 

* Passo  - Criando e Configurando um ELB (Elastic Load Balance):
    -

* Passo  - Criando e Configurando um Auto Scalling Group:
    - 
