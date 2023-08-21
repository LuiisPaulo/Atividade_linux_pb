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
      - Após fazer a instalação do Docker 
* Passo  - Criar um Docker Compose:
    -

* Passo  - (Opcional) Instalação do Docker, Docker Compose e suas respectivas configurações via script no user_data (dados do usuário):
    - 

* Passo  - Criar um EFS (Amazon Elastic File System):
    - 

* Passo  - Criar um RDS (Amazon Relational Database Service):
    - 

* Passo  - Criando e Configurando um ELB (Elastic Load Balance):
    -

* Passo  - Criando e Configurando um Auto Scalling Group:
    - 
