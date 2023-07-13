Author: Luis Paulo Lopes Gonçalves

- Projeto_Linux_PB


- Visão geral do projeto:

Essa documentação promove o passo a passo de uma criação de uma instância EC2 na Amazon AWS, configurar um IP elástico e anexar a sua instância, liberar as portas de comunicação da instância, criar um EFS (Amazon Elastic File System) para utilizarmos como um NFS, configurar um servidor Apache e criar um shellscript que irá monitorar a disponibilidade do servidor, se está online ou off-line, além de automatizarmos o script para ser executado a cada cinco minutos.


- Requisitos:

  - Conta na AWS.
  - Conhecimentos básicos em Linux.




1. Criando um instância:


     a. Faça o login no console da AWS.
   
     b. Vá até o serviço de EC2
     
     c. Clique em executar as instâncias
     
     d. Em nome e etiquetas, defina um nome para a instância
     
     e. Em imagem de máquina da Amazon, selecione a versão Amazon Linux 2, onde essa 
     AMI se qualifica com nível gratuito.
     
     f. Em tipo de instância, é possível selecionar qual será a configuração da instância. 
     Escolha a instância t2.micro, essa instância se qualifica no nível gratuito, mesmo que em regiões onde tal instância não tenha em determinada região, é possível utilizar a instância t3.micro que também está qualificada no nível gratuito.
     
     g. Crie um par de chaves.
     
     h. Em configurações de rede deixe como patrão.
     
     i. Em configurações de armazenamento, altere seu tamanho para 16 GB.
     
     j. As restantes configurações, deixe no formato padrão.
     
     k. Após realizar as configurações, verifique em review se está tudo correto com sua instância.
     
     l. Após visualizar as informações da instância e estiver tudo correto, clique em executar a instância.
     
     m. Após executar a instância espere ela ser inicializada e continue a configuração do ambiente.



2. Criando e Associando um IP Elástico:


     a.	Entre no painel EC2.
   
     b.	Navegue até a sessão de IP Elástico.
     
     c.	Clique em alocar um endereço IP.
     
     d.	Defina a região desejada.
     
     e.	Adicione uma tag (opcional).
     
     f.	E clique em alocar.
     
     g.	Após criar o IP, selecione o IP criado e vá em ações.
     
     h.	Em ações clique em associar IP.
     
     i.	No painel de associar o IP, selecione a opção de instância.
     
     j.	Após selecionar a opções de instância, em instâncias selecione a instância desejada.
     
     k.	Adicione o Endereço IP privado.
     
     l.	Em reassociação (opcional) você pode associar estando a opção marcada ou não.
     
     m.	Após realizar as configurações clique em associar.
     
     n.	Após associar o IP elástico na instância desejada.
     
     o.	Vá em instâncias e verifique se o mesmo foi alocado a sua instância.




3. Configurando portas de comunicaçõs do Security Group:

   
   
     a.	Entre no painel doo serviço de EC2.
   
     b.	Dentro do serviço, vá até a sessão de Grupos de Segurança (Security Group).
     
     c.	No painel, selecione o Security Group (Grupo de Segurança) da sua instância.
     
     d.	Após selecionar o Security Group, vá em Regras de Entrada.
     
     e.	Em regras de entrada, vá em editar regras de entrada.
     
     f.	Crie as seguintes portas:
       
       i.	Tipo: TCP Personalizado – Protocolo: TCP - Porta: 22 - Origem: 0.0.0.0/0 – Descrição: (Opcional).
       
       ii.	Tipo: TCP Personalizado – Protocolo: TCP - Porta: 111- Origem: 0.0.0.0/0 – Descrição: (Opcional).
       
       iii.	Tipo: TCP Personalizado – Protocolo: TCP - Porta: 80 - Origem: 0.0.0.0/0 – Descrição: (Opcional).
       
       iv.	Tipo: TCP Personalizado – Protocolo: TCP - Porta: 2049 - Origem: 0.0.0.0/0 – Descrição: (Opcional).
       
       v.	Tipo: TCP Personalizado – Protocolo: TCP - Porta: 443 - Origem: 0.0.0.0/0 – Descrição: (Opcional).
       
       vi.	Tipo: UDP Personalizado – Protocolo: UDP - Porta: 111 - Origem: 0.0.0.0/0 – Descrição: (Opcional).
       
       vii.	Tipo: UDP Personalizado – Protocolo: UDP - Porta: 2049 - Origem: 0.0.0.0/0 – Descrição: (Opcional).
     
     g.	Em seguida salve as regras adicionadas.
  


4. Criando e configurando um Amazon EFS (Amazon Elastic File System) – (NFS):

   .Passo 1 - Criando um EFS via console da AWS:

      a. Entre na console da AWS.

      b. Pesquise pelo serviço EFS e selecione-o.

      c. Clique em criar um sistema de arquivos.

      d. Defina um nome para o EFS (na atividade foi utilizado o nome de NFS)

      e. Após definir o nome, escolha a vpc que está sendo utilizada na instância.

      f. Clique em criar.

      g. Após criar, espero o serviço inicializar e clique no EFS que acabou de criar.

      h. Após abrir o painel do EFS criado, vá em rede para alterarmos o grupo de segurança.

      i. Em rede, clique em gerenciar.

      j. Após abrir as configurações de rede, mude o grupo de segurança para o grupo de segurnça criado e clique em salvar.

      k. Após altera o grupo de segurança vá em anexar e prossiga no passo 2.



   .Passo 2 - Configurando o nfs dentro do terminal Linux:

      - Para anexarmos o nosso EFS na nossa instância precisamos acessar o terminal Linux, para fazermos tal acesso, podemos nos conectar com a instância via console, puTTY ou pela máquina virtual.
  
        a. Após conectar a sua instância, vamos realizar os seguintes comandos descritos no painel pop-up quando clicamos em anexar.

        b. Primeiro vamos deixar selecionada a opção de montar via DNS.

        c. Para melhor organização, vamos criar um diretório geral, para posteriormentes criamos os seguintes subdiretórios:

              sudo mkdir atividade

        d. Vamos entra no diretório criado:

              cd atividade

        e. Vamos criar um diretório para o nosso nfs, com o nome de efs:

              sudo mount -t efs -o tls fs-09d20bc17911404dd:/ efs

        f. Vamos agora criar o nosso NFS:

              sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-09d20bc17911404dd.efs.us-east-1.amazonaws.com:/ efs


       
6. Criando e subindo um servidor Apache

      
   - Ainda no terminal Linux da instância, iremos criar, iniciar e configurar nosso Apache em conjunto com o EFS criado.
  
   a. Instalando o servidor Apache:

         sudo yum -y install httpd

   b. Iniciando o serviço:

         sudo service httpd start

   c. Testando se o servidor apache está funcionando:
      - Pesquise o endereço IP da instância no seu navegador web.

   d. Criando um ponto de montagem:
      
      - Criando um um subdiretório chamado efs-mount-point para utilizar como ponto de montagem de arquivos, no /var/www/html

              sudo mkdir /var/www/html/efs-mount-point

   e. Montando um sistema de arquivos Amazon EFS, substitua o file-system-id pelo ID da instância criada:

         sudo mount -t efs file-system-id:/ /var/www/html/efs-mount-point




8. Criando um script para monitoramento do nosso serviço apache:



   a. Entre no diretório já criado:

         cd atividade

   b. Vamos criar um subdiretório para armazenarmos o script:

         sudo mkdir script

   c. Entre no subdiretório do script:

         cd script

   d. Vamos criar o arquivo do script:

         validacao.sh

   - Nome do script opcional, no caso, o nome utilizado foi validação. Já que iremos validar por meio do script se o serviço está online ou offline


   e. Criando o script:

         #!/bin/bash

         if systemctl is-active httpd>/dev/null 2>&1;
         then
         status="Online"
         mensagem="Servidor está $status em $(date '+%d-%m-%Y %H:%M:%S')"
         echo "$mensagem" >> /home/ec2-user/atividade/efs/status_apache/status_log.txt
         else
         status="Offline"
         mensagem="Servidor Apache está $status em $(date '+%d-%m-%Y %H:%M:%S')"
         echo "$mensagem" >> /home/ec2-user/atividade/efs/status_apache/status_log.txt
         fi

   - O que o script está fazendo:
        
        * Na linha if systemctl is-active httpd>/dev/null 2>&1 , o script está verificando a condição do apache, se está online ou offline, a seguinte linha executa dessa forma:
        
        * A linha systemctl is-active httpd verifica o status do serviço "httpd".
        
        * A linha >/dev/null, o operador > redireciona a saída padrão para /dev/null que irá descarta qualquer informação irrelevante para o objetivo do script.
        
        * A linha >2&1, o número 2 indica o arquivo para saída padrão, já o operador >& está redirecionando o arquivo 2, 1 representa o arquivo de saída também.
       
        * O principal objetivo do if nesse shellscript é somente verificar se o serviço httpd está ativo ou inativo.
   
        * Caso o retorno da operação seja o servidor ativo ele entra na primeira condicional, que seria online, no caso ele armazenará o status do serviço como online e enviará uma mensagem com o status do serviço, a data e hora.
    
        * Caso o retorno seja o servidor inativo ele entra na segunda condicional, que seria offline, no caso ele armezanerá o status do serviço como offline e enviará uma mensagem com o status do serviço, a data e hora.
    
        * Por fim as mensagens tanto de online como offline serão enviadas para o diretório do nfs criado.


   f. Em seguida vamos tornar nosso comando executavel:

         sudo chmod +x validacao.sh

   g. Também vamos dar a permissões para que o script conseguir criar arquivos em um diretório: 

         sudo chmod u+rw /home/ec2-user/atividade/status_apache

   h. Após permitir leitura,gravação e execução do script, vamos executalo:

         ./validacao.sh

   i. Se não obtiver nenhum erro quando executar o script, vá para o diretório do seu nfs para verificar se há um arquivo de log gerado, após a execução do script, no caso:

         cd atividade
         cd efs
         cd status_apache
         ls
         cat status_log.txt




9. Executando o script de forma automatizada:



   - Vamos automatizar o script para que ele execute a cada cinco minutos de forma automâtica, não precisando executa-lo de forma manual.
  
   a. Criando um crontab:

         crontab -e

   b. Adicionando o tempo, e qual comando queremos executar:

         */5 * * * * /caminho/do/seu/script.sh

   - no caso do projeto:
  
         */5 * * * * /home/ec2-user/ativiade/script/validacao.sh

   c. Vamos visualizar se o comando está sendo executado de maneira correta, e a nova tarefa adicionada está funcionando:

           crontab -l


- Conclusão:
  
  A documentação demonstra um exemplo de um ambiente onde criasse uma instância EC2, configura um IP elástico para mesma, e habilita portas de comunicação no security group, no ambiente também é configurado um EFS para utilizarmos como o nfs do sistema, também é criado e inicializado um servidor apache, além de fazer um script que executa de forma automzatizada capaz de monitorar o servidor. Lembre-se de adpatar os comandos e os caminhos dos diretórios conforme seu ambiente.
