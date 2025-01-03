# Interview Questions

[Bash cheat sheet](https://devhints.io/bash)

## list files in directory
```bash
for item in /etc/*
do
  if [ -f $item ]; then 
    echo ${item}
  fi
done
```

## sum of integers
```bash
set -x
a=$1
b=$2

function input_check(){
if [ "$#" -ne 2 ]; then 
    echo 1
else
    if [ "$#" -gt 2 ]; then 
        echo 1 
    else 
        echo 0
    fi
fi
}

check_args=$(input_check $*)
if [ $check_args -eq 1 ]; then 
    echo "Usage: `basename $0` [arg1, arg2]"
    exit 1
else 
    sum=`expr $a + $b`
    echo "Result=$sum"
fi
```

## traverse array using len

```bash
array=("1" "2")
echo ${#array[*]} // length of an array

# fetch elements in an array
echo ${array[0]}

# traverse an item in an array  
for item in ${array[@]}; do 
  echo $item 
done

# print the array index
for item in ${!array[*]}; do 
  echo $item 
done

# "${array[@]}" - returns each item as a separate word.
# "${array[*]}" - returns all items in a word.

# take each element in an array and print the results
len=${#array[@]}
for((i=0;i<len;i++>)); do 
  echo index:$i,item:${array[$i]}
done

# iterate over index
for ((i=0;i<$${#array[@]};i++)); do
  echo ${array[i]}
done
```

```
Fruits=('Apple' 'Banana' 'Orange')
echo "${Fruits[0]}"           # Element #0
echo "${Fruits[-1]}"          # Last element
echo "${Fruits[@]}"           # All elements, space-separated
echo "${#Fruits[@]}"          # Number of elements
echo "${#Fruits}"             # String length of the 1st element
echo "${#Fruits[3]}"          # String length of the Nth element
echo "${Fruits[@]:3:2}"       # Range (from position 3, length 2)
echo "${!Fruits[@]}"          # Keys of all elements, space-separated

Fruits=("${Fruits[@]}" "Watermelon")    # Push
Fruits+=('Watermelon')                  # Also Push
Fruits=( "${Fruits[@]/Ap*/}" )          # Remove by regex match
unset Fruits[2]                         # Remove one item
Fruits=("${Fruits[@]}")                 # Duplicate
Fruits=("${Fruits[@]}" "${Veggies[@]}") # Concatenate
lines=(`cat "logfile"`)                 # Read from file

for i in "${Fruits[@]}"; do
  echo "$i"
done
```

## traversing dicts

```
declare -A sounds
sounds[dog]="bark"
sounds[cow]="moo"
sounds[bird]="tweet"
sounds[wolf]="howl"

echo "${sounds[dog]}" # Dog's sound
echo "${sounds[@]}"   # All values
echo "${!sounds[@]}"  # All keys
echo "${#sounds[@]}"  # Number of elements
unset sounds[dog]     # Delete dog

# iterate over values

for val in "${sounds[@]}"; do
  echo "$val"
done

# iterate over keys

for key in "${!sounds[@]}"; do
  echo "$key"
done
```


## diff between $@ and $*

$* and $@ when unquoted are identical and expand into the arguments.

"$*" is a single word, comprising all the arguments to the shell, joined together with spaces. For example '1 2' 3 becomes "1 2 3".

"$@" is identical to the arguments received by the shell, the resulting list of words completely match what was given to the shell. For example '1 2' 3 becomes "1 2" "3"

In short, $@ when quoted ("$@") breaking up the arguments if there are spaces in them. But "$*" does not breaking the arguments. 

```bash
# ./specialvars.sh 1 2 "3 4"
without quotes $*: 1
without quotes $*: 2
without quotes $*: 3
without quotes $*: 4

without quotes $@: 1
without quotes $@: 2
without quotes $@: 3
without quotes $@: 4

with quotes "$*": 1 2 3 4

with quotes "$@": 1
with quotes "$@": 2
with quotes "$@": 3 4
```

## concat two str

```bash
a="Sunil"
b="Kumar"

echo $a $b
```

```bash
array=("Sunil" "kumar")

for i in ${array[@]}; do 
    strnew+="$i"
done 

echo $strnew
```

## function defn and args

```bash
vim ./script Sunil
function f1(){
  echo "Hello $1"
}

f1 $1

$./script Sunil
```

##  func return value

```bash
function f1(){
  echo "Hello $1"
}

retval=$(f1 $1)
echo $retval

$./script Sunil 
```

## file types

| Operator | Description                                                                                  | Example                   |
| -------- | -------------------------------------------------------------------------------------------- | ------------------------- |
| -b file  | checks if file is a block special file; if yes, then the condition becomes true.             | [ -b $file ] is false.    |
| -c file  | checks if file is a character special file; if yes, then the condition becomes true.         | [ -c $file ] is false.    |
| -d file  | checks if file is a directory; if yes, then the condition becomes true.                      | [ -d $file ] is not true. |
| -f file  | checks if file is an ordinary file as opposed to a directory or special file;                | [ -f $file ] is true.     |
| -g file  | checks if file has its set group ID (SGID) bit set; if yes, then the condition becomes true. | [ -g $file ] is false.    |
| -k file  | checks if file has its sticky bit set; if yes, then the condition becomes true.              | [ -k $file ] is false.    |
| -p file  | checks if file is a named pipe; if yes, then the condition becomes true.                     | [ -p $file ] is false.    |
| -t file  | checks if file descriptor is open and associated with a terminal                             | [ -t $file ] is false.    |
| -u file  | checks if file has its Set User ID (SUID) bit set                                            | [ -u $file ] is false.    |
| -r file  | checks if file is readable; if yes, then the condition becomes true.                         | [ -r $file ] is true.     |
| -w file  | checks if file is writable; if yes, then the condition becomes true.                         | [ -w $file ] is true.     |
| -x file  | checks if file is executable; if yes, then the condition becomes true.                       | [ -x $file ] is true.     |
| -s file  | checks if file has size greater than 0; if yes, then condition becomes true.                 | [ -s $file ] is true.     |
| -e file  | checks if file exists; is true even if file is a directory but exists.                       | [ -e $file ] is true.     |

```bash
test -f ${FILE} && echo "File Exists" - Method 1 
[ -f ${FILE} ] && echo "File Exists" - Method 2 
                  OR 
[[ -f ${FILE} ]] && echo "File Exists"
```

## print/sum of odd/even

```bash

# even
for i in {0..10..2}; do 
    echo "${i}"
done

# odd
for i in {1..10..2}; do 
    echo "${i}"
done
```

## reverse string

```bash
s="sunil"
for((i=${#s};i>=0;i--)); do 
    revstr=$revstr${s:$i:1}
done

# oneliners
echo ${s}| rev 
rev <<< ${s}
```

## for and while

```bash
for((i=1;i<=10;i++)); do 
  echo $i
done
```

```bash
i=0
while [ $i -le 10 ];  do 
    echo $i 
    ((i++))
done
```

## factorial

```bash
counter=5
factorial=1
while [ $counter -gt 0 ]; do
  factorial=$(($factorial * $counter))
  counter=$(($counter - 1))
done
echo "$factorial"
```

## odd and even

```bash
oddsum=0
for i in {1..5..2}
do
  oddsum=$((oddsum+i))
done

echo $oddsum
```

## reverse of num

```bash
n=123456
rem=0
revnum=0
while [ $n -gt 0 ]; do 
    rem=$(( $n % 10 ))
    revnum=$(( $revnum * 10 + $rem ))
    n=$(( $n / 10 ))
done
echo $revnum
```

## password strength

```bash
code goes here
```

## line count in file

```bash
file="$1"
let count=0
while read line; do 
    ((count++))
done <$file

echo "Count:" $count
```

## return lines from func

```bash
function count() {
local file="$1"
let count=0
while read line; do 
    ((count++))
done <"$file"

echo $count 
}

echo "Count:" $(count "$1")
```

## discard comments in file 

```bash
while read -r line
do
  [[ $line = \#* ]] && continue
  printf '%s\n' "$line"
done < ./passwd
```

## retain the last 50 lines in logfile 

```bash
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
```

## random num generator 200-500. 

```bash
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
```

## email disk alert. 

```bash
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
```

## fibonacci series

```bash
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
```

```bash
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
```

## del last line in multiple files
```bash
for file in sub/*
  do
    if [ -f $file ]
    then
      vi -c '$d' -c 'wq' "$file"
    fi
  done
```

## replace string multiple places in multiple files

```bash
for file in ./*
  do
    if [ -f $file ]
    then
      sed -i 's/2018/2019/g' "$file"
    fi
  done
```

## verify string not null

```bash
str1="Not Null"
str2=" "
str3=""
message="is not Null nor a space"

if [ ! -z "$str1" -a "$str1" != " " ]; then
  echo "str1 ${message}"
fi

if [ ! -z "$str2" -a "$str2" != " " ]; then
  echo "str2 ${message}"
fi

if [ ! -z "$str3" -a "$str3" != " " ]; then
  echo "str3 ${message}"
fi
```

## Read contents in a file line by line

```bash
for h in $(<hosts.txt)
do
  echo $h
done
```

## bash substitutions 

**${v} - Substitue the value of v.**
v1=1
echo "substitute value of v1 '\${v1}'"
echo "sub value for v1:"${v1}
echo "--"

**${v:-val} - if v is null or unset, val is substituuted**
echo ${v2:-2}
echo "Value not set for v2:" $v2
echo "--"

**${v:=val} - if v is null or unset, vs is set to val**
echo ${v3:=3}
echo "val is substituted:" $v3
echo "---"

**${v:+val} - if v is set, val is substituted. v is unchanged**
v4=1234
echo "val is substituted" ${v4:+44}
echo "val is unchanged" ${v4}
echo "---"

**${v:?val} - if v is null or unset, val is printed to std err**
v5=5
echo "no err printed as v5 is set" ${v5:?5555}
echo "value unchanged" ${v5}

echo "not setting value, yest printing results"
echo "print value undefined" ${v6:? "Value unable to find"}
echo "---"

## $* & $# example script

```bash
#!/bin/bash

for i in $*; do 
    echo "without quotes \$*: $i"
done

echo

for i in $@; do 
    echo "without quotes \$@: $i"
done

echo

for i in "$*"; do
    echo "with quotes "'"$*"'": $i"
done

echo

for i in "$@"; do
    echo "with quotes "'"$@"'": $i"
done

# ./specialvars.sh 1 2 "3 4"
# without quotes $*: 1
# without quotes $*: 2
# without quotes $*: 3
# without quotes $*: 4

# without quotes $@: 1
# without quotes $@: 2
# without quotes $@: 3
# without quotes $@: 4

# with quotes "$*": 1 2 3 4

# with quotes "$@": 1
# with quotes "$@": 2
# with quotes "$@": 3 4
```

## design help menu

```bash
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
```

```bash
[[ -z "$1" ]] && grep "^#:" $0 | sed -e 's/#://' && exit
[[ "$1" == '-h' ]] && grep "^#:" $0 | sed -e 's/#://' && exit
[[ "$1" == '-v' ]] && echo "12.10.10" || echo "Error: Invalid Option" && exit
```

## log

```bash
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
```

## design calculator

```bash
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
```

## bash unit testing

```bash
#!/bin/bash 

# tried to combine most of the regularly used concepts in the scripts, 
# can be improvised more as we practice regularly !!

help(){
  scriptname=`basename $0`
  echo "Syntax: ${scriptname} <filename>"
  exit 1
}

validateOnlyOneArgument(){
  if [ "$#" -ne 2 ]; then 
    echo "PASSED: Atleast one argument passed"
  fi
  
  return 0
}

validateFileOnly() {
  [ -f ${filename} ] && echo "PASSED: fileonly"
  [ -d ${filename} ] && echo "Failed: directory" && exit 1

  return 0
}

readUnCommentLinesInFile() {
  filename="$1"
  while read -r line; do 
    [[ "$line" = \#* ]] && continue 
    printf "%s\n" "$line"
  done<${filename}
}

cleanLogFiles() {
  local logfile="$1"
  local default_lines=50
  tail -n ${default_lines} ${logfile} > ${logfile}.tmp
  mv ${logfile}.tmp ${logfile}
  echo "Info: housekeeping on ${logfile} completed"
  
  return 0
}

whoExecutesThisScript() {
  [ "${UID}" -ge 500 ] && echo "Info: non-root users can execute this script"
}

countNumberOfLinesInFile() {
  local count=0
  local filename="$1"
  while read -r line; do 
    ((count++))
    echo $line <$filename
  done

  return $count
}

# main function
main() {
  filename="$1"
  logfilename="./app.log"
  whoExecutesThisScript
  linecountinfile=countNumberOfLinesInFile "$filename"
  echo "lines in file: $?"

  # Unit tests for the script, only when successful, then continue

  if validateOnlyOneArgument; then 
     validateFileOnly
     cleanLogFiles $logfilename
     readUnCommentLinesInFile $filename
  fi
}

[ "$#" -ne "1" ] && help 
main "$1" | tee -a app.log
```

## seq numbers 

**first method**

```bash
i=1
while [[ $i -le 3 ]]; do 
  echo $i
  i=$((i+1))
done
```

**second method**

```bash
seq 1 3 | while read i ; do 
  echo $i
done
```


**third method**

```bash
for i in $(seq 1 3); do 
    echo $i
done
```

## redirecting streams

file descriptor - A unique identifier that the operating system assigns to a file when it is opened. 
0 - stdin 
1 - stdout 
2 - stderr

we have two conditions that are there to redirect streams

1. `>` shell thinks you are redirecting output to `stdout` which is to a file by default(also written as `>&`).
2. `&>` output + stderr both are redirected to the `file descriptor` and to a location. 

**example:**

`ls -z 2>&1 > file1.txt` 

we are redirecting the `stderr`(i.e `2`) to the file descriptor i.e `&1` which is `stdout` which by defaults to `file1.txt`. so we are writing output and error in the same file. 

the above can also be changed to below syntax which is very common. `ls -z > file1.txt 2>&`
`ls -z > /dev/null 2>&1` these can be found in the scripts normally.. 

**custom redirections**

###  single line modifications
```
echo "Suni lkumar@gmail.com" > email_file.txt
cat email_file.txt 
Suni lkumar@gmail.com -> observer there is missing 4th letter.
exec 3<> email_file.txt # open the file with fd as 3
read -n 4 <&3 # read 4 words by inputing fd 3 i.e email_file/txt
echo -n "." >&3 # output 4th letter to the fd 3 i.e email_file/txt
exec 3>&- # close the fd 3

cat email_file.txt 
Suni.lkumar@gmail.com -> you can now see its updated
```

### multiline modifications

this is for `heredocs` where you can create/execte multiple commands for the executions. 

```bash
ssh root@servre1 <<EOF
mkdir ~/heredocs
echo "heredocs" > ~/heredocs/heredocs.txt
EOF
```

### pipes

- names pipes: stdout to a file

```bash
sort < abc.txt > sorted_text.txt
```

sort will take the input and redirect it to stdout.. so we would proivde the input to sort and later we will output stored in the normal text file.

- Anomymous pipes: pass output from one place to another place

command1 | command 2

```bash
cat filename.txt | grep -i "o" | sort
```

there is 1 issue with the pipe commands, if the command is invalid or failed, it would continue to process the next inputs. WE MUST AVOID THAT KIND..

```bash
MacBook-Pro:wiki sunilamperayani$ ls -z | echo "helllo"
helllo --> you are able to execute this command despite the first command got failed.
ls: invalid option -- z
usage: ls [-@ABCFGHILOPRSTUWabcdefghiklmnopqrstuvwxy1%,] [--color=when] [-D format] [file ...]
```

```bash
MacBook-Pro:wiki sunilamperayani$ sort somefile.xtxt  | uniq && echo "hello"
sort: No such file or directory
hello
MacBook-Pro:wiki sunilamperayani$ echo $?
0
MacBook-Pro:wiki sunilamperayani$ 
```

despite getting failed return code was successful.

**pipefail**

immediately stop the execution of the command when one of the command fails in the chain of command.

```bash
MacBook-Pro:wiki sunilamperayani$ set -o pipefail
MacBook-Pro:wiki sunilamperayani$ sort somefile.xtxt  | uniq && echo "hello"
sort: No such file or directory
MacBook-Pro:wiki sunilamperayani$ echo $?
2
MacBook-Pro:wiki sunilamperayani$ 
```

we can also use `exit` codes to infact exit the scripts..

```bash
# set-fail.sh 
#!/usr/bin/env bash
set -o pipefail
sort newfile.txt | uniq || exit 80
```

```bash
MacBook-Pro:wiki sunilamperayani$ ./set-fail.sh 
sort: No such file or directory
MacBook-Pro:wiki sunilamperayani$ echo $?
80
MacBook-Pro:wiki sunilamperayani$ 
```

```bash
# noclobber.sh
#!/usr/bin/env bash
set -o noclobber 
echo "line1" > file1.txt
echo "line2" > file1.txt

sort somefile.txt | uniq || exit 100
```

```bash
MacBook-Pro:wiki sunilamperayani$ ./noclobber.sh 
./noclobber.sh: line 3: file1.txt: cannot overwrite existing file
./noclobber.sh: line 4: file1.txt: cannot overwrite existing file
sort: No such file or directory
MacBook-Pro:wiki sunilamperayani$ 
```

```bash
# eval.sh
MacBook-Pro:wiki sunilamperayani$ cat eval.sh 
#!/usr/bin/env bash
cmd="ls -l"
eval $cmd
MacBook-Pro:wiki sunilamperayani$ 
```

