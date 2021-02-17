#!/bin/bash
echo -n "AUTOINDEX STATE (on/off):"
read VAR
if [[ $VAR == "on" ]]
then 
    sed -i "s/autoindex off/autoindex on/g" /etc/nginx/sites-available/default
    service nginx restart
    echo "autoindex on"
elif [[ $VAR == "off" ]]
then
    sed -i "s/autoindex on/autoindex off/g" /etc/nginx/sites-available/default
    service nginx restart
    echo "autoindex off"
else
    echo "Argument error"
fi