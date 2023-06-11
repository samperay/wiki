#!/bin/bash

# One of the way to display help menu

function help() {
   echo "Syntax: ./script <arg> [-h|-v]"
   echo 
   echo "options:"
   echo "-h  Print this Help."
   echo "-v  Print software version and exit."
   echo
}

while getopts ":hv" option
do
  case ${option} in 
    "h") help ;;
    "v") echo 12.10.10 ;;
    "*") echo "Error: Invalid Option" || exit 
  esac
done


test $# -ne 1 && help
