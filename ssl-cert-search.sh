#!/bin/bash

echo ""

## Uses find command to search for cert bundle 

for X in $(find / -type f -name '*.pem' -o -name '*.crt' | grep 'cert_name'); do 
    if [ -s ${X} ]
    then 
        echo "### These are the certificate bundles found in ${HOSTNAME}"
        echo "*********************************************************************"
        echo "${X}"
        echo | openssl x509 -enddate -noout -in $X 
        echo ""
        echo | stat $X 
        echo ""
        echo ""
    fi 
done 

