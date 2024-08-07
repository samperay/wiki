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
