#!/bin/bash

cd /tmp/

# Create backup file 
tar -cavf $HOSTNAME-etc-home-cron-backup.tar.gz /etc /home /opt /data /srv /var/spool/cron/crontabs /root --exclude=

# Move file to /home/user 
mv $HOSTNAME-etc-home-cron-backup.tar.gz /home/