#!/bin/bash

search_ips=(

)


echo "*********************************************************************"
echo "Matching Firewall rules in $HOSTNAME"
echo "*********************************************************************"

for i in "${search_ips[@]}"; do 
    iptables -S | grep $i 
done 

echo ""

for i in "${search_ips[@]}"; do 
    ufw status numbered | grep $i 
done 
echo ""
