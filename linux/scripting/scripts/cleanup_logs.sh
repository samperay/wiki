#!/bin/bash

# cleanup the log file and retain only 50 lines in a file

LOG_DIR=/var/log
ROOT_UID=0
LINES=30
E_WRONGARGS=85
E_XCD=86
E_NONROOT=87

if [ "$UID" != "$ROOT_UID" ]
then
  echo "Must be root to run this script !"
  exit $E_NONROOT
fi


case "$1" in 
  "") lines=50;;
  *[0-9]*) echo "Usage: `basename $0` #lines_to_cleanup";
           exit $E_WRONGARGS;;
  *)      lines=$1;;
esac

cd /var/log || {
  echo "Cannot change to directory" >&2
  exit $E_XCD;
  }

tail -n $lines messages > mesg.temp
mv mesg.temp messages

echo "Log files cleaned up"
exit 0
