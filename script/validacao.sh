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
