#!/bin/bash
outFile="outFile_4.txt"
outFileSorted="outFileSorted_4.txt"

process=$(ls /proc/ | grep '\<[0-9]*\>')
for i in $process; do
  if [[ ! -d /proc/$i ]]; then continue; fi
  ppid=$(cat /proc/$i/status | grep 'PPid' | awk '{print $2}')
  ser=$(cat /proc/$i/sched | grep 'sum_exec_runtime' | awk '{print $3}')
  ns=$(cat /proc/$i/sched | grep 'nr_switches' | awk '{print $3}')
  art=$(echo "$ser/$ns" | bc -l)
  nice=$(ps -p $i -o pid,ni --no-header | awk '{print $2}')
  echo "$i $ppid $art $nice" >> $outFile
done

sort $outFile -o $outFileSorted -nk2
awk '{print "ProcessID="$1" : Parent_ProcessID="$2" : Average_Running_Time="$3" : Nice="$4}' $outFileSorted > $outFile
rm $outFileSorted
