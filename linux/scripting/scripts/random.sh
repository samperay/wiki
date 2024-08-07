# Generate random numbers between 200-500

#!/bin/bash
MIN=200
MAX=500
let "scope = $MAX - $MIN" #300
if [ "$scope" -le "0" ]; then
  echo "Error- MAX less than MIN"
fi

for i in {1..10}; do
  let result="$RANDOM % $scope + $MIN"
  echo "Random Number between Min/Max: $result"
done