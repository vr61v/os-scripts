#!/bin/bash
currentPpid=0; sum=.0; count=0; i=0
while read line; do
  pid=$(echo $line | awk '{print $1}' | awk -F= '{print $2}')
  ppid=$(echo $line | awk '{print $3}' | awk -F= '{print $2}')
  art=$(echo $line | awk '{print $5}' | awk -F= '{print $2}')

  if [[ $currentPpid -ne $ppid ]]; then
    result=$(bc -l <<<"$sum/$count")
    echo "Average_Running_Children_of_ParentID=$ppid is $result" >> "outFile_5.txt"
    currentPpid=$ppid; sum=.0; count=0
  fi

  sum=$(bc<<<"$sum+$art")
  let count=$count+1
  let i=$i+1
  echo "ProcessID=$pid : Parent_ProcessID=$ppid : Average_Running_Time=$art" >> "outFile_5.txt"
done < "outFile_4.txt"
