#!/bin/bash
function fibonacci
{
  echo $1 + $2 | bc | tr -d '\\\n'
}
F0=0
F1=1
echo "0: $F0, "
echo "1: $F1, "
count=2
while :
do
  F2=`fibonacci $F0 $F1`
  echo "${count}: $F2,"
  ((count++))
  F0=$F1
  F1=$F2
  sleep 0.1
done
fibonacci $F0 $F1
