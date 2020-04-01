#!/bin/bash
tome=$(free -m | grep -i mem | awk '{print $2}')
htps=$(ps -aylC httpd |grep "httpd" |awk '{print $8'} |sort -n |tail -n 1)
mysme=$(ps aux | grep 'mysql' | awk '{print $6}' |sort -n |tail -n 1)
rafa=1024
nmysme=$(expr $mysme / $rafa)
nhtps=$(expr $htps / $rafa)
echo -e "\nTotal Memory = $tome"
echo -e "Largest httpd Process = $nhtps"
echo -e "Mysql Memory = $nmysme"
maxc=`expr $tome - $nmysme`
maxcl=`expr $maxc / $nhtps`
echo -e "\nSo, The MaxClients = $maxcl"
echo -e "(we can use nearest round of value from $maxcl)"
