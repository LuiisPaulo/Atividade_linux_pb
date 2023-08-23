Autor: Luis Paulo Lopes Gonçalves

* Requisitos:
  - Conhecimento básico em AWS.
  - Conhecimento básico de Docker.
  - Conhecimento básico em Linux.


* Objetivo: 
  - Criar uma arquitetura no sistema da AWS, onde deve-se subir dois servidores rodando um container com uma aplicação Wordpress em cada um deles, ambos os containers devem fazer conexão com o banco de dados dísponivel pelo AWS por meio do serviço Amazon RDS, as instâncias devem estar na mesma VPC, onde o controle de tráfego de acesso do cliente com a aplicação seja intermediada por um ELB, além de aplicar escalabilidade nas aplicações.


* Passo 1 - Criar um VPC (Virtual Private Cloud):
  -
    - Criando uma VPC, sub-redes e outros recusos de VPC, via console da AWS:
    - (Observação) A seguir segue o passo a passo para criamos uma VPC que iremos utilizar para o projeto, algumas configurações adicionais não serão necessárias para o mesmo, portanto deixe tais configurações no formato padrão.
        1. Abra o console da AWS e pesquise pelo serviço de Amazon VPC.
        2. No painel de VPC, selecione a opção Criar VPC (Create VPC).
        3. Em recursos a serem criados (Resources to create), selecione a opção de VPC e mais (VPC and more).
        4. Pode manter selecionada a opção de gerar tags de nome de forma automática para os recursos da VPC, ou pode desmarca a opção para definir as tags de nome que deseja para seus recursos da VPC.
        5. No Bloco de CIDR IPv4, defina uma faixa de endereço IPv4 para VPC.
        6. (Opcional) Também pode definir um Bloco CIDR IPv6, que é oferecido pela Amazon.
        7. Em opções de Locação, selecione a opção Default.
        8. Na sessão de Número de zonas de disponibilidade (AZs) deixe a criação automática que a própria AWS fornece, caso contrário você pode criar as suas sub-redes expandindo em personalizar AZs.
        9. Na configuração das sub-redes, deixe de forma automática, onde a própria AWS escolhe. Caso contrário pode configurar os valores para números de sub-redes pública e privadas, também pode selecionar os intervalos de endereços IP para as sub-redes, expandindo na sessão personalizar blocos CIDR de sub-redes.
        11. Na sessão de visualização, consegue-se visualizar as relação entre o serviço de VPC e seus recursos.
        12. Após concluir a configuração, basta selecionar Criar VPC.
        
* Passo 2 - Criar uma instância EC2 (Amazon Elastic Compute Cloud):
  -
  
* Passo  - Configuração do Grupo de Segurança (Security Group):
    -
  - No passo anterior, criamos juntamente com a instância um grupo de segurança, entretando precisamos configura-lô para que possamos utilizarmos em nossa arquitetura.
      1. Vá no painel do serviço de EC2.
      2. Após abrir o painel de serviços de EC2, selecione a sessão de Grupo de Segurança (Security Group).
      3. Após abrir a sessão, selecione o grupo de segurança que será utilizado.
      4. Clique em Ações (Action).
      5. Em ações, clique em Editar regras de entrada.
      6. E adicione as seguintes regras:
   
      ![Screenshot 2023-08-23 130058](https://github.com/LuiisPaulo/Atividade_linux_pb/assets/138496370/eb01b86a-04e7-4dd1-9d81-07c2ac8f12ab)

      7. Após adicionar as novas regras, clique em salvar.
  

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

* Passo  - Criando um Grupo de Destino:
    -

* Passo  - Criando e Configurando um ELB (Elastic Load Balance):
    -

* Passo  - Criando e Configurando um Auto Scalling Group:
    - 
