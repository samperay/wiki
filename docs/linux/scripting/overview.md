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