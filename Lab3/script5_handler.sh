#!/bin/bash
result=1
operation="+"
(tail -f "script5_infile") | while true; do
  read line
  case $line in
    "+") operation="+" ;;
    "*") operation="*" ;;
    "=") echo "result: $result" >> "script5_outfile" ;;
    [[:digit:]]*)
      if [ "$operation" = "+" ]; then let result=$result+$line; fi
      if [ "$operation" = "*" ]; then let result=$result\*$line; fi
    ;;
    "QUIT")
      echo "exit" >> "script5_outfile"
      killall tail
      exit
    ;;
  esac
done
