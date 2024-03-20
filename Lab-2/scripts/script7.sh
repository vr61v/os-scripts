#!/bin/bash
commands=$(ps aux | awk '{print $2 ":" $11}' | sed '/PID COMMAND/d')
for line in $commands; do
  pid=$(echo $line | awk -F: '{print $1}')
  if [[ ! -d /proc/$pid ]]; then continue; fi
  command=$(echo $line | awk -F: '{print $2}')
  startv=$(sudo cat /proc/$pid/io | grep "read_bytes" | awk '{print $2}')
  echo $pid $command $startv >> "outFile_7Buffer.txt"
done

sleep 30

while read line; do
  pid=$(echo $line | awk '{print $1}')
  if [[ ! -d /proc/$pid ]]; then continue; fi
  command=$(echo $line | awk '{print $2}')
  startv=$(echo $line | awk '{print $3}')
  endv=$(sudo cat /proc/$pid/io | grep "read_bytes" | awk '{print $2}')
  echo $pid $command $(($endv-$startv)) >> "outFile_7.txt"
done < "outFile_7Buffer.txt"
rm "outFile_7Buffer.txt"

echo $(cat "outFile_7.txt" | sort -rnk3 | head -n3 | awk '{print "PID:"$1" COMMAND:"$2 " VALUE:"$3}')

