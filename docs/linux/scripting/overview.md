# Bash Overview

## redirecting streams

file descriptor - A unique identifier that the operating system assigns to a file when it is opened. 
0 - stdin 
1 - stdout 
2 - stderr

we have two conditions that are there to redirect streams

1. `>` shell thinks you are redirecting output to `stdout` which is to a file by default(also written as `>&`).
2. `&>` output + stderr both are redirected to the `file descriptor` and to a location. 

**example**

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

## pipes

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

### pipefail

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

## arrays

```bash
# bash shell > 5.3-release

declare -a servers
servers=("server1" "coding" "structure tets")

new_servers=("${servers[@]:0:1}" "server1.5" ${servers[@]:1}]})
echo "${new_servers[@]}" # server1 server1.5 coding structure tets]}

unset servers[1]
echo "${servers[@]}" # server1 structure tets

declare -a array=("One" "Two" "Three")
array+=("Four" "Five" "Six")
echo "${array[@]}" # One Two Three Four Five Six

declare -a numbers=(5 1 3 2 4)
printf "%s\n" "${numbers[@]}" | sort # 1 2 3 4 5

# write an example of associative array key-value pair
# instead of using index, we can use string as index
declare -A fruits
fruits=([apple]='red' [banana]='yellow' [cherry]='red')
echo "${fruits[apple]}" # red

# add new key-value pair
fruits["green"]="pear"
echo "${fruits[green]}" # pear

# modify value
fruits["red"]="new apple" 
echo "${fruits[@]}"

# delete key-value pair
unset fruits[banana]
echo "${fruits[@]}" # red new apple pear

# loop through key-value pair
for key in "${!fruits[@]}"; do
    echo "$key: ${fruits[$key]}"
done
```

## variable expansion

```bash
echo "Hello ${name1:-unkown}" # name is not defined so it will print unkown which is default value

name="John Doe"
echo "Hello ${name:=unkown}" # assign default values


echo "Hello, ${name:0:4}" # extract substring from 0 to 4

# string replacement
echo "${path/Downloads/Documents}" # replace Downloads with Documents

# string length
echo "Length: ${#path}" # print length of the string
```

## parameter expansion

'#' matching `prefix`
'%' matching `suffix`

```bash
# extract last part of the path
path="/home/user/Downloads"
echo "Path: ${path##*/}" # extract last part of the path

greeting="Hello World"
echo "${greeting#H}" # matches from left to right
#ello World

echo "${greeting%d}" # matches from right to left
#Hello Worl

my_text_file="/home/my_username/text_file.txt"
my_python_file="/usr/bin/app.py"

echo "${my_text_file##*/}" # remove the last part of the path

echo "${my_python_file##*/}" # remove the last part of the path

echo "${my_python_file%.*}" # remove the last part of the path
```

## examples

## bash unit testing

```bash
#!/bin/bash 

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

## Good practices

**Bash reserved exit codes**

```
0  success
1  general error
2  misuse of shell builtins
126 cannot execute
128  cannot execute
130  script terminated by ctrl-c
127  command not found
```

`set -e`  exits on error
`set -u` exits when a unset variable is used
`set -o pipefail` catches errors in piped commands

### set -e

**Incorrect bash script**

```bash
# safe.sh
#!/usr/bin/env bash

ehco "hello"
exit 0

./safe.sh
echo $? #0 returns success code which is wrong
```

**Correct Bash script**

```bash
# safe.sh
#!/usr/bin/env bash

set -e

ehco "hello"
exit 0

./safe.sh
echo $? #126
```

### set -u

**Incorrect bash script**

```bash
# safe1.sh

name="Sunil"
# last_name="Kumar"

echo "My Full name is ${name} ${last_name}..!!"
exit 0 

./safe1.sh
echo $? # 0 Incorrect as last_name is not executed
```

**Corrected bash version**

```bash
set -u
echo "My Full name is ${name} ${last_name}..!!"
exit 0 

./safe1.sh
echo $? # 1 
```

### set -o pipefail

```bash
# pipefail.sh

cat non-existent-file.txt | sort | uniq 
exit 0

./pipefail.sh
cat non-existent-file.txt | sort | uniq 
cat: non-existent-file.txt: no such file or directory
echo $? 
0
```

In below script, if the `cat` has been failed, it should not execute the `echo` command.. but it does.
so to fix it use `set -o pipefail`

```bash
# pipefail.sh

cat non-existent-file.txt | sort | uniq && echo "this line should not be executed";
exit 0

./pipefail.sh
cat non-existent-file.txt | sort | uniq 
cat: non-existent-file.txt: no such file or directory
"this line should not be executed";
echo $? 
0
```

you won't get an `echo` statement if it fails when we set `set -o pipefail` but we still have an issue with the exit code.

```bash
# pipefail.sh
set -o pipefail

cat non-existent-file.txt | sort | uniq && echo "this line should not be executed";
exit 0

./pipefail.sh
cat non-existent-file.txt | sort | uniq 
cat: non-existent-file.txt: no such file or directory
echo $? 
0
```

```bash
# pipefail.sh
set -e
set -u
set -o pipefail

readonly PIPE_ERROR=156

# terminate function technique
terminate()
{
  local -r msg="${1}"
  local -r code="${2:-160}"
  echo "${msg}" >&2
  exit "${code}"
}

cat non-existent-file.txt | sort || { terminate "error in piped command" "${PIPE_ERROR}" }

exit 0

./pipefail.sh
cat non-existent-file.txt | sort | uniq 
cat: non-existent-file.txt: no such file or directory
echo $? 
156
```

## no-op command

dry run command in bash. its a shell-built in command which has no behaviour programmed.

```bash
#!/use/bin/env bash

if [[ "$1" = "start" ]]; then
  : #no-op command
else
  echo "invalid string"
fi
```

## logging

```bash
#!/usr/bin/env bash
log() {
  echo $(date -u +"%Y-%m-%d%T%H:%M:%SZ") "${@}"
}

log "hello world"
```
## awk 

- domain specific language for streamling text operations.
- expect input as standard behaviour
- input can be passwd by keyboard, pipes or files
- ' '(quotes) used in awk is to prevent the shell/terminal expansion. 


```bash
# awk expects input as the standard behaviour.
awk -F":" '{print $1}' /etc/passwd 
awk -F":" '{print $1}' < /etc/passwd 
cat /etc/passwd | awk '{print $1}'
```

### built-in variables

- NR: total number of records (lines) processed so far across all input files
- NF: represents the number of fields (columns) in the current record (line)
- FILENAME: represents the name of the current file being processed.

Program block = `BEGIN`
Action block = `{print $1}`

```bash

file1.txt

apple
banana
cherry

awk '{ print NR, $0 }' file1.txt

# output 

1 apple
2 banana
3 cherry

NR=1 for first line
NR=2 for second line
```

```bash
file2.txt

apple banana cherry
grape mango

awk '{ print NF, $0 }' file2.txt

# output
3 apple banana cherry
2 grape mango

The first line has 3 fields, so NF=3.
The second line has 2 fields, so NF=2.
```

```bash
# file1.txt
apple
banana

#file2.txt
grape
mango


awk '{ print FILENAME, NR, $0 }' file1.txt file2.txt

file1.txt 1 apple
file1.txt 2 banana
file2.txt 3 grape
file2.txt 4 mango

FILENAME shows the file name being processed.
NR continues counting records across both files.
```

```bash
awk '{ print "File:", FILENAME, "Record:", NR, "Fields:", NF, "Line:", $0 }' file1.txt file2.txt

File: file1.txt Record: 1 Fields: 1 Line: apple
File: file1.txt Record: 2 Fields: 1 Line: banana
File: file2.txt Record: 3 Fields: 1 Line: grape
File: file2.txt Record: 4 Fields: 1 Line: mango
```

**Field seperator**

```bash
cat  /etc/passwd | awk -F ":" '{print $1 $7}'
```

-v declare a vraible before executing the action block or a program.

```bash
awk -v var="Hello world" 'BEGIN { print var }' 
Hello world

awk -F ":" -v user="Users homedirectory: " '{print user, $1}' /etc/passwd 

# output

Users homedirectory:  _notification_proxy
Users homedirectory:  _avphidbridge
Users homedirectory:  _biome
Users homedirectory:  _backgroundassets
Users homedirectory:  _mobilegestalthelper
Users homedirectory:  _audiomxd
Users homedirectory:  _terminusd
```

```bash
# uid>100
awk -F":" -v user="username:" -v uid="100" '$3>=uid {print user,$1, $3}' /etc/passwd

# 100>uid<300
awk -F":" -v user="username:" -v uid="100" -v uidlow="300" '$3>=uid && $3<=uidlow {print user,$1, $3}' /etc/passwd
```

### using awk-file

you can use an awk program, but shell expansions like globbing, command substituitions, and 
command like utilities are not available. 

```bash
# hello.awk

#!/usr/bin/env awk -f 
BEGIN {
  print "hello"
}
bash-3.2$ 

./hello.awk
hello
```

```bash
#!/usr/bin/env bash

awk -v hello="Hello" 'BEGIN { 
    print hello
  }'

```

## sed

`sed` takes the input parameter and would process the unprocessed text and the processed text to the stdout.
it will take input from the keyboard, file, or the pipes. i.e similar to awk

```bash
sed 'p' # waits for the input from the keyboard
t
t # unprocessed text
t # processed text i.e output
```



In order to supress automatic printing use `-n`

```bash
sed -n '2p' filename.txt # print the second line supressing the automatic printing
```

delete(-d)

```bash
sed -n '2d' filename.txt # delete the 2nd line and print to standard output
sed -n '2,5d' filename.txt # delete from 2nd line to 5th line and print to standard output
```

in-place (-i) 

```bash
sed -i '2,5d' filename.txt # write to the filename.txt instead of the stdout
```

search

search always ends with '/<text>/' follwed by 'p' print. 

```bash
sed -n '/broot/p' /etc/passwd

#\b word boundary followed by string pattern.
sed -n '/\broot\b/p' /etc/passwd # good practice to use '\b'

# -e indicated its an sed script for multiple options MANDATORY
sed -n -e '/\broot\b/p' -e '/\bsunil\b/p' /etc/passwd 

# delete the root and write into the file
sed -n -i -e '/\broot\b/d' -e '/\bsunil\b/p' /tmp/passwd
```