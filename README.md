Projeto_Linux_PB



Visão geral do projeto:
Essa documentação promove o passo a passo de uma criação de uma instância EC2 na Amazon AWS, configurar um IP elástico e anexar a sua instância, liberar as portas de comunicação da instância, criar um EFS (Amazon Elastic File System) para utilizarmos como um NFS, configurar um servidor Apache e criar um shellscript que irá monitorar a disponibilidade do servidor, se está online ou off-line, além de automatizarmos o script para ser executado a cada cinco minutos.

Objetivo do projeto:


1. Criando uma instância EC2:
   
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


2. Associação do IP Elástico:

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


3. Configurando portas de comunicação no Security Group:

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

  a.	Entre no console da AWS.
  
  b.	Pesquise pelo serviço EFS, e selecione.
  
  c.	No painel do EFS, vá em criar um sistema de arquivos.
  
  d.	Defina um nome (opcional) – no caso utilizado foi NFS.
  
  e.	E escolha a VPC que será utilizada, selecionando a mesma VPC que esteja sendo utilizado criada na instância anterior.
  
  f.	Por fim clique em criar.
  
  g.	Espere o efs criar e selecione o mesmo.
  
  h.	No painel do efs criado, vamos em rede.
  
  i.	Já na sessão de rede, vamos clicar em gerenciar.
  
  j.	Em gerenciar, vamos alterar o grupo de segurança, para o nosso grupo de segurança criado anteriormente.
  
  k.	Após isso clicaremos em salvar.

   - Para continuarmos com o processo de criação precisaremos acessar a instância, podemos fazer esse acesso via console, virtual machine ou pelo putty. 
    1.	No caso utilizaremos o putty.
      a.	Para conectarmos a instância via putty, precisaremos transforma o par de chave criado de .perm para .ppk.
      b.	Vamos acessar o puTTYgen para transformarmos nossa chave de acesso ssh.
      c.	Após fazermos a alteração, iremos baixar nossa nova chave de acesso .ppk para acessarmos nossa instância via puTTY.
      d.	Após a criação da chave, vamos executar o puTTY.
      e.	Dentro do aplicativo, vamos ir na sessão de SSH.
      f.	Abrindo a sessão de SSH, vamos entrar na sessão de Auth.
      g.	Abrindo a sessão de Auth, vamos em credentials.
      h.	Na sessão de credentials, em Public-key authentication, vamos pesquisar o diretório onde salvamos a chave .ppk e vamos selecionar.
      i.	Após colocarmos a nossa chave de acesso, ainda no puTTY vamos na sessão Session e iremos colocar o Host Name (ou IP) da nossa instância.
      j.	Após colocarmos a informação da nossa instância, clique em open.
      k.	Após clicar em open irá abrir a conexão do puTTY com a instância, porém para acessarmos a instância temos que fazer o login.
      l.	Para realizar o login basta saber o user do sistema operacional utilizado (no caso ec2-user).
      m.	Após fazer o login a conexão da instância via puTTY estará concluída.

m.	Para terminarmos de configurar o EFS, agora com a instância sendo acessada com o puTTY, no painel de EFS clique em anexar.
n.	Após clicar em anexar vai aparecer uma sequência de comandos para montarmos nosso nfs.
o.	Em opções de montar selecione a opção de Montar via DNS.
p.	Após isso replique os comandos no terminal Linux da sua instância.
q.	Como exemplo os comandos utilizados no sistema:
sudo mkdir 

