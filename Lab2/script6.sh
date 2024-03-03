#!/bin/bash
process=$(ls /proc/ | grep '\<[0-9]*\>')
for i in $process; do
  if [[ ! -d /proc/$i ]]; then continue; fi
  mem=$(cat /proc/$i/status | grep -i VMSIZE | awk '{print $2}')
  echo $i " " $mem >> outFile6.txt
done
echo $(cat "outFile6.txt" | sort -rnk2 | head -n1); rm "outFile6.txt"

