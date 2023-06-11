#!/bin/bash

# we could write the help menu in the different way rather than "help.sh" mentioned
# in this repository. 

#:Syntax: ./script <arg> [-h|-v]
#:  options:
#:    -h:  Print this Help
#:    -v:  Print software version and exit.

[[ -z "$1" ]] && grep "^#:" $0 | sed -e 's/#://' && exit
[[ "$1" == '-h' ]] && grep "^#:" $0 | sed -e 's/#://' && exit
[[ "$1" == '-v' ]] && echo "12.10.10" || echo "Error: Invalid Option" && exit
