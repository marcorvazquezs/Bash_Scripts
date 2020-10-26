#!/bin/bash 

echo ""
echo "*********************************************************************"
echo " These are the keys in the host: ${HOSTNAME}"
echo "*********************************************************************"
echo ""

## Gets users from /etc/passwd and looks for ssh keys in /.ssh for each user 
echo "### These are the keys in the */.ssh/authorized_keys files"
echo "*********************************************************************"
for X in $(cut -f6 -d ':' /etc/passwd |sort |uniq); do 
    if [ -s ${X}/.ssh/authorized_keys ] || [ -s ${X}/.ssh/additional_keys ] || [ -s ${X}/.ssh/keen_keys ] ; then
        echo ""
        echo "# ${X}: "
        cat ${X}/.ssh/*additional_keys
        echo ""
    fi
done 

## Looks for ssh keys in /etc/ssh/authorized_keys 
echo "### These are the authorized keys in /etc/ssh/authorized_keys/*"
echo "*********************************************************************"
echo ""
for X in $(find / -type d -path '/etc/ssh/authorized_keys' -print0 | xargs -0 ls | sort); do 
    if [ -s /etc/ssh/authorized_keys/${X} ]
    then 
        echo "# ${X}"
        echo "---------"
        cat /etc/ssh/authorized_keys/${X} | sort | uniq
        echo ""
    fi 
done 

## Looks for files names authorized_keys in all /home directories 
echo "### These are the authorized keys in /home "
echo "*********************************************************************"
echo ""
for X in $(find / -type f -iname "authorized_keys" -print0 | xargs -0 ls | sort ); do
    if [ -s ${X} ]
    then 
        echo "# ${X}"
        echo "-----"
        cat ${X} | sort | uniq
        echo ""
    fi 
done 