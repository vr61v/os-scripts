#!/bin/bash
process=$(ls /proc/ | grep '\<[0-9]*\>')
echo "" > script4OUT.txt
for i in $process; do
  ppid=$(cat /proc/$i/status | grep 'PPid' | awk '{print $2}')
  ser=$(cat /proc/$i/sched | grep 'sum_exec_runtime' | awk '{print $3}')
  ns=$(cat /proc/$i/sched | grep 'nr_switches' | awk '{print $3}')
  art=$(echo "$ser/$ns" | bc -l)
  echo "$i $ppid 0$art" >> script4Out.txt
done
sort script4OUT.txt -o "script4SortedOut.txt" -nk2
