#!/bin/bash 

WARNING=90
CRITICAL=95

df -H | egrep -v '^/dev/loop|tmpfs|udev|Filesystem' | awk '{ print $5 " " $1}'| while read line;
do
  echo $output
  usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
  partition=$(echo $output | awk '{ print $2 }' )

  if [ $usep -ge $WARNING ]; then 
    echo "WARNING: Running out of space \"$partition - $usep\""
  elif [ $usep -ge $CRITICAL ]; then 
    echo "CRITICAL: Require Immediate attention on \"$partition - $usep\""
    mail -s "Alert:Critical: Disk running out of space" <youremailid>
  fi
done