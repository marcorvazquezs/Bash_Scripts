#!/usr/bin/env bash
#The following documentation outlines the steps used to perform an external port scan against a list of servers and email the results
#By Marco Vazquez

#HOW TO RUN
#These should be set to run via cron at 6 AM PST (1300 UTC) every Tuesday and Friday
#
#To run manually:
#sudo sh /var/nmap_scans/port_scan_ext.sh

#PREREQUISITES
#The user running the port scan needs to have sudo/administrative access on the executing system
#The host running the port scan must have "nmap" installed locally
#The file "server-fqdns.txt" which contains the list of servers to be scanned needs to be in /var/nmap_scans (eg. /var/nmap_scans/server-fqdns.txt)
#The executing system must be configured to send email via Postfix + SendGrid to ensure delivery

#Set variable for filename
scan_file=$(date +%m-%d-%Y_%H:%M)_external_scan

#Run nmap from untrusted IP with TCP half-open check, UDP, No Ping, export to XML and input IP's from .txt file
nmap -sS -sU -Pn --dns-servers 8.8.8.8 -oX /var/nmap_scans/$scan_file.xml -iL /var/nmap_scans/server-fqdns.txt

#Uncomment this for quick test of script with only 1 IP 
#nmap 155.138.244.132 --stylesheet /var/nmap_scans/nmap-bootstrap.xsl -oX /var/nmap_scans/$scan_file.xml
#nmap 155.138.244.132 -sS -sU -Pn -oX /var/nmap_scans/$scan_file.xml

#Use yandiff to compare baseline vs observed
yandiff -f xml -of /var/nmap_scans/ext_nmap_diff_$(date +%Y-%m-%d).xml -op o -s /var/nmap_scans/yandiff.xsl -b /var/nmap_scans/nmap_baseline.xml -o /var/nmap_scans/$scan_file.xml

#Now we need to parse the .XML into .HTML formatting using the default nmap .XLS
xsltproc /var/nmap_scans/$scan_file.xml -o /var/nmap_scans/$scan_file.html

xsltproc /var/nmap_scans/ext_nmap_diff_$(date +%Y-%m-%d).xml -o /var/nmap_scans/ext_nmap_diff_$(date +%Y-%m-%d).html

#A file will be created in /var/nmap_scans called, "$(date +%m-%d-%Y_%M:%M)_external_scan.html"

#Email the results
#Note echo may be in /usr/bin/echo depending on the OS
#echo "Attached are external nmap scans from is-01 on $(date +%m-%d-%Y)." | mail -s "External Port Scans $(date +%Y-%m-%d)" -A /var/nmap_scans/$scan_file.html bob@email.com
echo -e "Hey,\n\nAttached are your external nmap scans from $HOSTNAME on $(date +%m-%d-%Y).\n\nDon't try to reply as this is being sent directly from the server and there's no route back to it." | /usr/bin/mail -s "External Port Scans from $HOSTNAME on $(date +%Y-%m-%d)" -A /var/nmap_scans/ext_nmap_diff_$(date +%Y-%m-%d).html bob@email.com 


#Pause for 10 seconds to let the email send
sleep 10s

#Clean up (delete) the XML amd HTML files
rm -f /var/nmap_scans/$scan_file.xml
rm -f /var/nmap_scans/$scan_file.html
rm -f /var/nmap_scans/ext_nmap_diff_$(date +%Y-%m-%d).xml
rm -f /var/nmap_scans/ext_nmap_diff_$(date +%Y-%m-%d).html

/bin/echo "Port Scans Successful: $(date)" >> /var/nmap_scans/port_scan.log
