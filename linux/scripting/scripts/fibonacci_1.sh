#!/bin/bash

# why this code would provide us some wrong results ?

# return codes are really intended as status reports and not as long integers, so this method is of no use
# in the shell when dealing with values over 255. The recipe includes a basic sanity test to see if it has wrapped around;
# the numbers should always be getting bigger. 144 + 233 = 377, which is 1 0111 1001 in binary. Losing the ninth bit leaves
# it as 0111 1001, which is 121 in decimal. 121 is smaller than the previous number, 233, so the answer 121 is clearly wrong


fib() {
  return $(( $1 + $2 ))
}

F0=0
F1=1
echo "0: $F0"
echo "1: $F1"
for count in `seq 2 20`; do
 fib $F0 $F1
 F2=$?
 if [ "$F2" -lt "$F1" ]; then
  echo "$count: $F2 (WRONG!)"
 else
  echo "${count}: $F2"
 fi
 F0=$F1
 F1=$F2
 sleep 0.1
done

fib $F0 $F1
echo "${count}: $?"
