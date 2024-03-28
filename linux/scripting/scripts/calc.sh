#!/bin/bash 

# Simple Basic Calculator 

# check for arguments 
if [ $# -ne 2 ]; then 
   echo "Usage: ./calculator.sh <arg1> <arg2>"
   exit 1
fi

# Sum 
# Function for summing two numbers

function summing() {
  result=`expr $1 + $2`
  echo "Sum:($1+$2)="$result
}

# Difference 
function difference(){
  result=`expr $1 - $2`
  echo "Difference:($1-$2)="$result
}

# Multiplication 
function multiplication(){
  result=`expr $1 \* $2`
  echo "Multiplication:($1*$2)="$result
}

# Division 
function division(){
  result=`expr $1 / $2`
  echo "Division:($1/$2)="$result
}

summing $1 $2 
difference $1 $2
multiplication $1 $2 
division $1 $2
