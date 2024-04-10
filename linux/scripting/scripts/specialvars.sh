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