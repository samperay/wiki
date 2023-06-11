#!/bin/bash

exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>log.out 2>&1

log() {
# write the log
  local msg="$1"
  DATE=`date '+%b %e %H:%M:%S'`
  echo INFO: $DATE $msg
}


log "Hello World"
log "Alice && Bob wants to talk to each other in secure communication "
