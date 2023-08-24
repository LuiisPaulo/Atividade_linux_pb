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
  - Criado uma instância EC2 (Amazon Elastic Compute Cloud).
      1.  Abra o console da AWS, e pesquise pelo serviço Amazon EC2.
      2.  No painel de EC2, clique em iniciar instância,
      3.  Defina o nome e as tags para instância.
      4.  Em Imagens e Aplicações, selecione o sistema operacional Linux, e a AMI (Amazon Machine Images) selecione Amazon Linux 2023, ou Amazon Linux 2, ambas estão marcadas como free tier.
      5.  Em tipo de instância, selecione o tipo t2.micro que está inclusa no plano free tier na AWS.
      6.  Em par de chaves, crie o par de chaves, para conseguir realizar a conexão da instância via console, ssh ou Putty.
      7.  Na sessão de configurações de rede, crie um novo grupo de segurança.
      8.  Mantenha a seleção padrão para outras configurações da instância.
      9.  (Opcional) Em configurações avançadas, vá em user data:
      - (Observação) Para realização da instalação e configuração do Docker e do Docker-Compose via script, vá para o passo e depois volte para prosseguir com os próximos passos.
      10. Clique em criar instância.  
        
* Passo 3 - Configuração do Grupo de Segurança (Security Group):
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
  

* Passo 4 - Criando um Elastic IP, para configuração da instância EC2 (Amazon Elastic Compute Cloud):
    - 

    - Crie um Elastic IP, para conseguir acessar a instância.

        1. Vá no painel de serviço EC2.
        2. Vá na sessão de IPs Elásticos (Elastic IP).
        3. Clique no botão Alocar endereço de IP elástico.
        4. Deixe as opções já selecionadas pela AWS.
        5. (Opcional) Adicone as tags para o serviço.
        6. Clique em alocar.

    - Anexando o IP elástico na instância EC2.

        1. Selecione o endereço de IP que foi criado.
        2. Clique em ações (action).
        3. Clique em Associar endereço de IP elástico.
        4. Deixe as configurações padrões fornecida pela a AWS, alterando somente a sessão de instância.
        5. Na sessão de instância, selecione a instância desejada.
        6. Clique em associar.
        7. Confira se o endereço de IP elástico foi associado corretamente na instância selecionada.
     
* Passo 5 - Instalando o Docker na instância EC2 (Amazon Elastic Compute Cloud):
  -
    - Para a realização da instalação do Docker, você precisa concetar-se a instância EC2, você pode realizar esse acesso via console da AWS, ou por meio da chave SSH, também pode acessar a instância via .ppk pelo Putty.
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
* Passo 6 - Instalando o Docker Compose na instância EC2 (Amazon Elastic Compute Cloud):
    - 
  - Após fazer a instalação do Docker na sua instância EC2, vamos instalar o nosso Docker Compose para criarmos nosso .yml (.yaml) que conterá nossa imagem personalizada do Wordpress:
      
      1. Instalando o Docker Compose:

              sudo yum update -y
              sudo curl -L https://github.com/docker/compose/releases/download/v2.5.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose

      2. Dando permissões pro Docker Compose:

              sudo chmod +x /usr/local/bin/docker-compose

* Passo 7 - Criar um EFS (Amazon Elastic File System):
    - 

    - Criando um EFS (Amazon Elastic File System), para utilizar como NFS do projeto:

      1. Abra o console da AWS, e pesquise o serviço EFS.
      2. Selecione a opção de Criar um sistema de arquivos.
      3. Defina um nome.
      4. Escolha a VPC que será utilizada.
      5. (Opcional) Antes de criar o EFS, pode clicar no botão customizar para alterar as própriedades padrões que a AWS fornece.
      6. Clique em Criar.

    - Após a criação do EFS, vamos configura-lô:

      1. No paínel principal do serviço de EFS, selecione o EFS criado.
      2. Selecione a sessão de rede.
      3. Clique em Editar.
      4. Altera o grupo de segurança padrão, para o grupo de segurança que foi criado.
      5. Clique em salvar.

    - Depois de criar e configurar o EFS (Amazon Elastic File System), iremos anexar ele na(s) instância(s) EC2 criadas.
    - Para prosseguirmos com a configuração, será necessário se conectar a instância via console AWS, chave SSH, ou por meio do Putty.
    - Após conectar a instância(s) EC2, realize as seguintes etapas:

      1. Crie um diretório.

              sudo yum update -y
              mkdir efs

      2. No painel do serviço EFS (Amazon Elastic File System) dentro da console da AWS, acesse o EFS criado e clique em Anexar.
      3. Após clicar em Anexar, abrirá uma janela pop-up com os comandos que devem ser utilizado para criamos o ponto de montagem do nosso EFS.
      4. Marque a opção de Montar via DNS, e siga as instruções.
      5. Exemplo:

   ![Screenshot 2023-08-22 175517](https://github.com/LuiisPaulo/Atividade_linux_pb/assets/138496370/e2eac060-e435-4a38-b71b-f860b8ea1dff)

    - Podemos conferir se o ponto de montagem deve sucesso por meio do comando:
 
          df -h

    - Saída esperada:
     

* Passo 8 - Criar um RDS (Amazon Relational Database Service):
    -
   - Criando um Amazon RDS (Amazon Relational Database Service) para utilizarmos com a aplicação do wordpress.
        
        
        1. No console da AWS, pesquise o serviço Amazon RDS (Amazon Relational Database Service).
        2. Selecione Criar Banco de Dados.
        3. Em método de criação, selecione a opção padrão.
        4. Em tipo de mecanismo, escolha o MySQL.
        5. Em versão, deixe a padrão.
        6. Na sessão de identificação do banco de dados, dê um nome para identificação do seu banco de dados.
      7. Na sessão de configurações de credencias.
      8. Dê o nome do usuário master do banco de dados.
      9. Dê a senha de usuário master do banco de dados.
      10. Confirme a senha do usuário master.
      11. Na sessão de classe da instância DB, deixei a instância padrão, db.t3.micro. Caso contrário selecione a instância manualmente.
      12. Na sessão de conxeão, selecione a VPC criada para o projeto.
      13. Na sessão de grupos de sub-net, deixe a opção selecionada que vem por padrão. Caso contrário você pode configurar de forma manual.
      14. Em Acesso Público, marque a opção de não.
      15. Em Grupos de Securança (Security Group), selecione o grupo de segurança criado anteriormente.
      16. Na sessão de Zonas de Disponíbilidade, deixe a opção selecionada por padrão.
      17. Em porta do Banco de Dados, deixe a porta criada por padrão pela AWS.
      18. Na sessão de autentificação do Banco de Dados, marque a opção de autentificação por senha.
      19. Na sessão de configurações adicionais, altere o nome do banco de dados.
      20. Nas outras opções da sessão deixe os parâmetros gerados de forma automática pela AWS.
      21. Clique em Criar Banco de Dados.
 

* Passo 9 - Criar um Docker Compose:
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
                   WORDPRESS_DB_HOST: #AWS RDS Endpoint
                   WORDPRESS_DB_USER: #user BD RDS
                   WORDPRESS_DB_PASSWORD: #password BD RDS
                   WORDPRESS_DB_NAME: #name DB RDS
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

* Passo 10 - (Opcional) Instalação do Docker, Docker Compose e suas respectivas configurações via script no user_data (dados do usuário):
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
 

* Passo 11 - Criando um Grupo de Destino:
    -
    - Criando um Grupo de Destino:

      1. Abra o console da AWS, e pesquise pelo serviço de Amazon EC2.
      2. O painel de navegação, selecione a sessão de Grupos de Destino.
      3. Clique em Criar grupo de destino.
      4. Na sessão de configurações básicas:
         1. Selecione a opção de instância.
         2. Dê um nome para o grupo de destino.
         3. Em protocolo, selecione o prótocolo HTTP, na porta 80.
         4. Em VPC, selecione a VPC que será utilizada no ambiente.
         5. Em versão do protocolo, selecione a opção HTTP1.
         6. Na sessão de Health checks, mantenha a configuração padrão que é fornecido pela AWS.
         7. (Opcional) Adicione tags ao seu serviço.
         8. Clique em criar grupo de destino.
      5. Após criar o grupo de destino, anexe a(s) instância(s) criadas.
    
* Passo 12 - Criando e Configurando um ELB (Elastic Load Balance):
    -
    - Criando um ELB (Elastic Load Balance), e alocando o grupo de destino ao mesmo.
      1. Abra a console da AWS, e pesquise pelo serviço de Amazon EC2.
      2. No painel de navegação, selecione a sessão de Load Balance.
      3. Clique em Criar Load Balance.
      4. Em tipos de Load Balance, selecione o Application Load Balance.
      5. Em configurações básicas:
        1. Em nome do Load Balance, escreva um nome para o seu serviço.
        2. Na sessão de Scheme, marque a opção de internet-facing.
        3. Na sessão de tipos de IP, selecione a opção de IPv4.
      6. Na sessão de rede:
        1. Em VPC, selecione a VPC que será utilizada no ambiente.
        2. Em mapeamento, selecione a(s) Zona(s) que deseja utilizar.
        3. Em subnets, deixe o padrão fornecido pela AWS. Caso ao contrário pode alterar de forma manual.
        4. Na sessão de Grupo de Segurança (Security Group), selecione o grupo de segurança (Security Group) que foi criado e configurado para o ambiente.
      7. Na sessão de Listeners e Routing:
        1. Em protocolo selecione HTTP.
        2. Em portas selecione a 80.
        3. Em ações, selecione o Grupo de Destino que foi criado anteriormente.
      8. (Opcional) Adicione tags ao seu serviço.
      9. Clique em criar Load Balance.

          
* Passo 13 - Criando uma AMI da instância:
    - 
    -  Criando uma imagem da nossa instância.
    -   
        1. Abra o console da AWS.
        2. Pesquise o serviço de Amazon EC2.
        3. Dentro do painel do serviço, entre na sessão de instância.
        4. Dentro da sessão de instância, selecione a instância criada para o ambiente.
        5. Clique em ações.
        6. Vá até a sessão de imagens e modelos.
        7. Selecione a opção de criar imagem.
        8. Você será redirecionado para o painel de criação de uma imagem (AMI).
        9. Ensira um nome para imagem.
        10. (Opcional) Defina uma descrição para imagem.
        11. Na sessão de Não reinicializar, deixe a opção desmarcada.
        12. Em volumes de instância, deixe padrão. Caso contrário, pode configurar de maneira manual.
        13. (Opcional) Adicione tags a sua imagem (AMI).
        14. Clique em Criar imagem.  
        
* Passo 14 - Criando um Modelo de Execução:
    -
    - Criando um modelo de execução.
    - 
        1. Abra o console da Amazon AWS.
        2. Pesquise o serviço de Amazon EC2.
        3. Defina um nome para o modelo de execução.
        4. Defina uma descrição para versão do modelo de execução.
        5. Na sessão de Orientação sobre Auto Scaling, habilite a opção.
        6. Na sessão de tags do modelo, adicione tags para seu serviço.
        7. Na sessão de Conteúdo do modelo de execução, selecione a opção Minhas AMIs.
        8. Marque a opção de minha propriedade.
        9. Após selecionar a opção de Minhas AMIs, selecione a AMI que foi criada anteriormente.
        10. Em Tipos de instância, escolha t2.micro, que faz parte do plano free tier da Amazon AWS.
        11. Em Par de chaves, selecione o par de chaves criado quando configuramos a instância.
        12. Em configuração de rede:
        13. Em sub-rede selecione as sub-redes relacionadas com a VPC do ambiente.
        14. Em grupos de segurança, selecione a opção selecionar grupo de segurança existente.
        15. Após marca essa opção, escolha o grupo de segurança criado e configurado anteriormente.
        16. Na sessão de armazenamento, deixe o padrão fornecido pela AWS. Caso contrário, pode configurar de maneira manual.
        17. Em tags de recurso, defina tags para seu serviço.
        18. Em Detalhes avançados, altere os dados do usuário, colando o user_data do passo 10, as demais configurações deixe as configurações padrões.
        19. Em resumo, visualize se as configurações estão corretas.
        20. Clique em criar modelo de execução.

* Passo 15 - Criando e Configurando um Auto Scaling Group:
    - 
    -
        1. Abra o console da Amazon AWS.
        2. Abra o painel de serviço de Amazon EC2.
        3. No painel de serviço do Amazon EC2, vá até a sessão de Grupos de Auto Scalling.
        4. Clique em Criar grupo de Auto Scaling.
        5. Defina um nome do grupo de Auto Scaling.
        6. Na sessão de Modelo de execução, selecione o modelo de execução criado anteriormente.
        7. Clique em próximo.
        8. Em Rede:
           1. Selecione a VPC que está sendo utilizada no ambiente.
           2. Na sessão de Zonas de disponibilidade e sub-rede, selecione as sub-redes criadas e configuradas junto da VPC que será utilizada.
        9. Em Requisitos de tipo de tipo de instância, verifique se as configurações estão corretas. Como: o modelo de execução, versão, descrição e qual será o tipo de instância (no caso t2.micro).
        10. Clique em próximo.
        11. Em Balanceamento de carga, selecione a opção de Anexar a um balanceador de carga existente.
        12. Após marca a opção, selecione Escolha entre seus grupos de destino de balanceador de carga.
        13. Na sessão de Grupos de destino de balanceador de carga existente, selecione o Load Balancer criado anteriormente.
        14. Em Opção de integração do VPC Lattice, selecione a opção Serviço VPC Lattice não disponível.
        15. Na sessão de verificação de integridade, altere a sessão de Período de tolerância da verificação de integridade, informando a quantidade de tempo desejada.
        16. Em configurações adicionais, deixe as opções desmarcadas.
        17. Clique em próximo.
        18. Na sessão de tamanho do grupo, defina as capacidades:
            1. Defina a capacidade desejada (como: 1 ou mais).
            2. Defina a capacidade mínima (como: 1 ou mais).
            3. Defina a capacidade máxima.
        19. Em Políticas de escalabilidade, selecione a opção de Nenhum.
        20. Na sessão de proteção contra redução de escala de instância na horizontal, deixe a opção desabilitada.
        21. Clique em próximo.
        22. (Opcional) Adicionar notificações do Auto Scaling.
        23. Clique em próximo.
        24. (Opcional) Na sessão de etiquetas, adicione etiquetas pro serviço de Auto Scaling.
        25. Clique em próximo.
        26. Na sessão de Análise, verifique as configurações do Auto Scaling.
        27. Clique em Criar grupo de Auto Scaling.
