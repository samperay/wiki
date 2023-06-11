**<h1>Questions</h1>**

- [List only files in directory](#list-only-files-in-directory)
- [Print sum of two integers as agrs from CLI and print error if more provided](#print-sum-of-two-integers-as-agrs-from-cli-and-print-error-if-more-provided)
- [Print the lenght of array and how to access the elements](#print-the-lenght-of-array-and-how-to-access-the-elements)
- [How do you differentiate between at and star](#how-do-you-differentiate-between-at-and-star)
- [How to concatenate the two strings](#how-to-concatenate-the-two-strings)
- [How to define function and pass arguments to it](#how-to-define-function-and-pass-arguments-to-it)
- [How to return value to a function](#how-to-return-value-to-a-function)
- [Identify the type of file](#identify-the-type-of-file)
- [Print sum of odd/even numbers until number is 50](#print-sum-of-oddeven-numbers-until-number-is-50)
- [Given the string, can you reverse the string](#given-the-string-can-you-reverse-the-string)
- [Explain **for** and **while** loop to print numbers from 1 to 10](#explain-for-and-while-loop-to-print-numbers-from-1-to-10)
- [Print the factorial of the number](#print-the-factorial-of-the-number)
- [Print list of even/odd numbers for a given integer number by reading from input](#print-list-of-evenodd-numbers-for-a-given-integer-number-by-reading-from-input)
- [print reverse of the number](#print-reverse-of-the-number)
- [Print the sum of odd/even digits in a number](#print-the-sum-of-oddeven-digits-in-a-number)
- [Given the password as input from user, check for its strength](#given-the-password-as-input-from-user-check-for-its-strength)
- [Count the number of lines by providing a file as input](#count-the-number-of-lines-by-providing-a-file-as-input)
- [Write a function to count the lines from a file and return as an argument](#write-a-function-to-count-the-lines-from-a-file-and-return-as-an-argument)
- [Write a shell script that would discard the comments in a config file](#write-a-shell-script-that-would-discard-the-comments-in-a-config-file)
- [Write a script to retain the last 50 lines in a logfile](#write-a-script-to-retain-the-last-50-lines-in-a-logfile)
- [Generate random number from 200-500.](#generate-random-number-from-200-500)
- [Email the disk alert if it exceeds the threshold.](#email-the-disk-alert-if-it-exceeds-the-threshold)
- [Fibonacci series](#fibonacci-series)
- [delete last line in multiple files](#delete-last-line-in-multiple-files)
- [replace string multiple places in multiple files](#replace-string-multiple-places-in-multiple-files)
- [verify string not null](#verify-string-not-null)
- [Read contents in a file line by line](#read-contents-in-a-file-line-by-line)



## List only files in directory

```
for item in /etc/*
do
  if [ -f $item ]; then 
    echo ${item}
  fi
done
```
---

## Print sum of two integers as agrs from CLI and print error if more provided

```
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
---

## Print the lenght of array and how to access the elements

```
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

## How do you differentiate between at and star

$* and $@ when unquoted are identical and expand into the arguments.

"$*" is a single word, comprising all the arguments to the shell, joined together with spaces. For example '1 2' 3 becomes "1 2 3".

"$@" is identical to the arguments received by the shell, the resulting list of words completely match what was given to the shell. For example '1 2' 3 becomes "1 2" "3"

In short, $@ when quoted ("$@") breaking up the arguments if there are spaces in them. But "$*" does not breaking the arguments. 

[special variables script](../scripting/scripts/specialvars.sh)

```
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

---

## How to concatenate the two strings

```
a="Sunil"
b="Kumar"

echo $a $b
```

```
array=("Sunil" "kumar")

for i in ${array[@]}; do 
    strnew+="$i"
done 

echo $strnew
```

---

## How to define function and pass arguments to it

```
vim ./script Sunil
function f1(){
  echo "Hello $1"
}

f1 $1

$./script Sunil
```
---

##  How to return value to a function

```
function f1(){
  echo "Hello $1"
}

retval=$(f1 $1)
echo $retval

$./script Sunil 
```
---

## Identify the type of file

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

```
test -f ${FILE} && echo "File Exists" - Method 1 
[ -f ${FILE} ] && echo "File Exists" - Method 2 
                  OR 
[[ -f ${FILE} ]] && echo "File Exists"
```
---

## Print sum of odd/even numbers until number is 50

```
```

## Given the string, can you reverse the string

```
s="sunil"
for((i=${#s};i>=0;i--)); do 
    revstr=$revstr${s:$i:1}
done
```
---

## Explain **for** and **while** loop to print numbers from 1 to 10

```
for((i=1;i<=10;i++)); do 
  echo $i
done
```

```
i=0
while [ $i -le 10 ];  do 
    echo $i 
    ((i++))
done
```

---

## Print the factorial of the number

```
counter=5
factorial=1
while [ $counter -gt 0 ]; do
  factorial=$(($factorial * $counter))
  counter=$(($counter - 1))
done
echo "$factorial"
```
---

## Print list of even/odd numbers for a given integer number by reading from input

```
oddsum=0
for i in {1..5..2}
do
  oddsum=$((oddsum+i))
done

echo $oddsum
```

## print reverse of the number

```
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
---

## Print the sum of odd/even digits in a number

```
```

---

## Given the password as input from user, check for its strength

```
```

---

## Count the number of lines by providing a file as input

```
file="$1"
let count=0
while read line; do 
    ((count++))
done <$file

echo "Count:" $count
```
---

## Write a function to count the lines from a file and return as an argument

```
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
---

## Write a shell script that would discard the comments in a config file 

```
while read -r line
do
  [[ $line = \#* ]] && continue
  printf '%s\n' "$line"
done < ./passwd
```
---

## Write a script to retain the last 50 lines in a logfile 

[solution](../scripting/scripts/cleanup_logs.sh)

---

## Generate random number from 200-500. 

[solution](../scripting/scripts/random.sh)

---

## Email the disk alert if it exceeds the threshold. 
[solution](../scripting/scripts/disk_alert.sh)

---

## Fibonacci series
- [solution-1](../scripting/scripts/fibonacci_1.sh)
- [solution-2](../scripting/scripts/fibonacci_2.sh)

## delete last line in multiple files
```
for file in sub/*
  do
    if [ -f $file ]
    then
      vi -c '$d' -c 'wq' "$file"
    fi
  done
```

## replace string multiple places in multiple files

```
for file in ./*
  do
    if [ -f $file ]
    then
      sed -i 's/2018/2019/g' "$file"
    fi
  done
```

## verify string not null

```
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

```
for h in $(<hosts.txt)
do
  echo $h
done
```

