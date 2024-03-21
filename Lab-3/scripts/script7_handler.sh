#!/bin/bash
word=$(shuf -i 10000-100000 -n 1)
try=0
echo $word
(tail -f "script7_infile") | while true; do
  read line
  result=""
  for i in 0 1 2 3 4; do
    if [ "${line:$i:1}" == "${word:$i:1}" ]; then 
      result="$result$i"
    fi
  done
  echo "result: $result"
  
  let try=$try+1
  if [ "$result" == "01234" ]; then echo "try: $try"; exit; fi
done
