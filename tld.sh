#!/bin/bash

#!/bin/bash
###CORES###
C_DISABLED="\033[0m"
C_RED="\033[1;31m"
C_GREEN="\033[0;32m"
C_YELLOW="\033[0;33m"
C_CYAN="\033[0;36m"
RESET="\e[0m"
### ${C_RED} ${C_DISABLED} ${C_GREEN} ${C_YELLOW} ${C_CYAN} ${RESET}

#1)Verifica load
#-----------------------

clear
cpuuse=$(cat /proc/loadavg | awk '{print $1}')

if [ "$cpuuse" > 80 ]; then

        #SUBJECT="ATTENTION: CPU Load Is High on $(hostname) at $(date)"

        echo -e "${C_RED}CPU Current Usage is: $cpuuse%${RESET}"
        echo
        echo
        echo -e "${C_GREEN}+------------------------------------------------------------------+${RESET}"
        echo -e "                   ${C_GREEN}Top CPU Process Using top command${RESET}"
        echo -e "${C_GREEN}+------------------------------------------------------------------+${RESET}"

        echo "$(top -bn1 | head -20)"
fi

echo
echo -e "${C_GREEN}+------------------------------------------------------------------+${RESET}"
echo -e "                   ${C_GREEN}Top CPU Process Using ps command${RESET}"
echo -e "${C_GREEN}+------------------------------------------------------------------+${RESET}"
echo
echo -e "$(ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10)"
echo
echo -e "${C_GREEN}+------------------------------------------------------------------+${RESET}"

#2)Status dos serviços
#-----------------------
echo
echo
echo -e "${C_GREEN}//NGINX status//${RESET}"
echo -e "${C_GREEN}+------------------------------------------------------------------+${RESET}"
echo
systemctl status nginx.service | grep -i "Active:"

echo
echo -e "${C_GREEN}//Asterisk status//${RESET}"
echo -e "${C_GREEN}+------------------------------------------------------------------+${RESET}"
echo
service asterisk status | grep -i "Active:"

echo
echo -e "${C_GREEN}//Motion  status//${RESET}"
echo -e "${C_GREEN}+------------------------------------------------------------------+${RESET}"
echo
service motion status | grep -i "Active:"
echo
echo

echo
echo -e "${C_GREEN}//PHP-FPM  status//${RESET}"
echo -e "${C_GREEN}+------------------------------------------------------------------+${RESET}"
echo
service php7.4-fpm status | grep -i "Active:"
echo
echo

#3)Verifica espaço
#-----------------------

echo -e "${C_GREEN}++------------------------Total/Usado/Livre--------------------------------------+${RESET}"
echo
echo "       "
                df -h
echo

echo -e "${C_GREEN}++---------------------------------------------------------------------------------+${RESET}"

echo
echo
echo -e "${C_GREEN}++-------Os 10 maiores arquivos em /var/log e /var/log/xcally---------------------------------+${RESET}"
echo
                                du -ah /var/log/ | sort -n -r | head -n 10
                                echo
                                du -ah /var/log/xcally | sort -n -r | head -n 10
echo
echo -e "${C_GREEN}++--------------------------------------------------------------------+${RESET}"
echo

#4)Verifica fila de e-mails

#        mailqueue=$(exim -bpc)

#if      [  "$mailqueue" -gt 1000 ];
#        then
#                ec -d 7 root
#        else
#        echo "Número de e-mails na fila: $mailqueue"
#fi

#echo
#echo

#5)WHM

#echo -e "${C_GREEN}//Login WHM//${RESET}"

#whmlogin

#echo
echo
read -p "Pressione qualquer tecla para continuar... " -n1 -s
clear

#)Propagação de DNS, NS, SOA, RegistroBR

#echo -e "${C_GREEN}++-------Propagação de DNS, NS, SOA, RegistroBR, Blacklists------------------------------+${RESET}"
#echo
#       echo -e ${C_YELLOW}Qual o domínio?${RESET}:
#       echo
#       read dom
#echo
#       echo -e "       Propagação de DNS (A): https://www.whatsmydns.net/#A/${dom}"
#       echo -e "       Nameservers: https://www.whatsmydns.net/#NS/${dom}"
#       echo -e "       Registro SOA: https://www.whatsmydns.net/#SOA/${dom}"
#       echo -e "       RegistroBR: https://hetrixtools.com/blacklist-check/${dom}"
#       echo -e "       Checksite: checksites -d ${dom}"
#echo
#echo -e "${C_GREEN}Verificar blacklists${RESET}"
#
#       ip1=$(hostname -I | cut -d" " -f1)
#       ip2=$(hostname -I | cut -d" " -f2)
#echo
#       echo -e "       https://hetrixtools.com/blacklist-check/${ip1}"
#       echo -e "       https://hetrixtools.com/blacklist-check/${ip2}"
#echo
#echo -e "${C_GREEN}++--------------------------------------------------------------------+${RESET}"

while : ; do
echo
echo -e "${C_YELLOW}O que deseja fazer?${RESET}"
echo
        echo -e "  1) Visualizar número de agentes no xCally"
        echo -e "  2) Reload na config do NGINX"
        echo -e "  3) Reiniciar NGINX"
        echo -e "  4) Reiniciar Asterisk"
        echo -e "  5) Reiniciar Motion"
        echo -e "  6) Reiniciar PHP-FPM"
        #echo -e "7) Trocar IP de saída do EXIM"
        #echo -e "8) Rodar HIGHLOAD"
        #echo -e "9) Instalar scan e rodar"
        #echo -e "10) Remover FPM"
        #echo -e "11) Reset Root"
        echo -e "  7) Número de requisições (netstat)"
        #echo -e "13) NGINX error log"
        #echo -e "14) Forçar SSL"
        #echo -e "15) Pesquisa GeoIP"
        echo -e
        echo -e "${C_YELLOW}Digite a opção desejada: ${RESET}"

read continue0
case $continue0 in

1)
        echo -e "${C_GREEN}Visualizar número de agentes no xCally${RESET}"
        clear
        curl -X GET http://localhost:3335
        ;;

2)
        echo -e "${C_YELLOW}Recarregando NGINX...${RESET}"
        systemctl reload nginx.service
        ;;

3)
        echo -e "${C_GREEN}Reiniciando NGINX...${RESET}"
        systemctl restart nginx.service
        ;;

4)
        echo -e "${C_GREEN}Reiniciando Asterisk...${RESET}"
        systemctl restart asterisk.service
        ;;

5)
        echo -e "${C_GREEN}Reiniciando Motion...${RESET}"
        systemctl restart motion.service
        ;;

6)
        echo -e "${C_GREEN}Reiniciando PHP-FPM${RESET}"
        systemctl restart php7.4-fpm.service
        ;;

#7)
#        echo -e "${C_GREEN}Trocar IP de saída do EXIM${RESET}"
#        bash <(curl -sk https://git.hostgator.com.br/chel/hgscripts/raw/master/patolino.sh)
#        ;;

8)
        echo -e "${C_GREEN}Rodar HIGHLOAD${RESET}"
        highload() { DAY=$(date -d "$1" +%m/%d) ; perl /root/sys-snap.pl ${DAY} | awk '!/proc_rstate/{ if ( $2 > 100 ) { print $1"\t\033[1;91m"$2"\033[0m" } else if ( $2 > 75 ) { print $1"\t\033[0;31m"$2"\033[0m" } else if ( $2 > 50 ) { print $1"\t\033[0;93m"$2"\033[0m" } else if ( $2 > 10 ) { print $1"\t\033[0;33m"$2"\033[0m" } else if ( $2 > 1 ) { print $1"\t"$2 } }' ; } ; highload today
                ;;


9)
        echo -e "${C_GREEN}Instalar scan e rodar${RESET}"
        wget -q -O /root/bin/scan http://hgfix.net/paste/view/raw/df3c7e8e; chmod 100 /root/bin/scan
        screen -d -m
;;

10)
        echo -e "${C_GREEN}Remover FPM${RESET}"
        find /var/cpanel/userdata/ -iname "*fpm*" -exec mv {}{,-bkp} \;
        /scripts/rebuildhttpdconf
        systemctl reload httpd
;;

11)
echo
        echo -e "${C_GREEN}Reset ROOT${RESET}"
        passwd=$(openssl rand -base64 8)
        echo "Usuário: root"
        echo "Senha: ${passwd}"
;;

7)
echo
        echo -e "${C_GREEN}Número de requisições por IP (netstat)${RESET}"
        clear
        netstat -n |cut -c 45- |cut -f 1 -d ':'| sort|uniq -c |sort -nr | head
;;

13)
echo
        echo -e "${C_GREEN}NGINX error log${RESET}"
        /var/log/nginx/error_log
;;

14)
echo
        echo -e "${C_GREEN}Forçar SSL${RESET}"
        /usr/local/cpanel/bin/autossl_check_cpstore_queue --force
;;

15)
echo
        echo -e "${C_GREEN}Pesquisar GeoIP${RESET}"
        echo Qual o IP?:
        read GeoIP
        echo -e "       https://www.geodatatool.com/pt/?ip=${GeoIP}"
;;

16)
        echo -e "${C_GREEN}Forçar SSL${RESET}"
        /usr/local/cpanel/bin/autossl_check_cpstore_queue --force
;;

        esac
        echo -e
        echo -e
done
