#---------------------------------------------------
# Special script to checking UPS control connected to QNAP NAS #via usb plug-in  UPS Cyber POWER device
#
# Statement:
# add to the crontab this line  */10 * * * * * /etc/init.d/upsT.sh
# Paste two files and change chmod
# upsT chmod r-xr-xr-x
# upst1.txt 0777
# to cronotab reset use command
# crontab /etc/config/crontab
# /etc/init.d/crond.sh restart
#----------------------------------------------------------


#!/usr/bin/env bash
#!/bin/bash
#! /bin/sh
HOME=/root
LOGNAME=root
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
LANG=en_US.UTF-8
SHELL=/bin/sh
PWD=/root
#unbind from hid-generic
usbid=\"\"
upsim=\"\"

# Current time
now=$(date +"%T")
echo "Current time : $now"
sleep 3s;
echo  "test"
# save file

#sudo  tailf /var/log/nc.log  > /etc/init.d/upsT1.txt
sudo  cat /var/log/nc.log  > /etc/init.d/upsT1.txt


sleep 3s;

#lsof | grep /etc/init.d/upsT.sh


i= field=()
exec 3< /etc/init.d/upsT1.txt
while read 0<&3 line; do
 # echo "GOT: ${line}"
   
if [[ $line == *"category=UPS"* ]]; then 
   echo "TO: ${line}"
field+=("$line")
 fi




done
exec 3<&-
# save into array
echo Data: ${field[@]}
# the last line in array
echo ${field[$(expr ${#field[@]} - 1)]}

# read the last array
for row in "${field[@]}";do                                                      
  row_array=(${row})
# the last column plugged /unplugged                                                            
  first=${row_array[13]}                                                         
  echo ${first} 
# save into array row
fieldrow+=(${row})
                                       
done 
echo "ROW"
 echo ${fieldrow[$(expr ${#fieldrow[@]} - 1)]}
# check the last row 
tLast=${fieldrow[$(expr ${#fieldrow[@]} - 1)]}
echo "$tLast"
# get length of an array
tLen=${#fieldrow[@]}
echo "$tLen"

# bind usb
if [[ $tLast == *"unplugged."* ]]; then 
   echo "TO: $tLast"
sudo sh -c "echo '1-2' > /sys/bus/usb/drivers/usb/unbind";
sudo sh -c "echo '1-2' > /sys/bus/usb/drivers/usb/bind"
 fi

 echo "STOP"

# use for loop read all nameservers
#for (( i=0; i<${tLen}; i++ ));
#do
  #echo ${NAMESERVERS[$i]}



#done


# need to at the crontab */10 * * * * /etc/init.d/upsT.sh
# to reset crontab
#crontab /etc/config/crontab
#/etc/init.d/crond.sh restart
# upsT chmod r-xr-xr-x
# upst1.txt 0777
#After paste it need to change permission 777
# Dokonaj blad 127 to brak konwersji linii do UNIX. w edycja  Notpadd++ / konwersjia linii 