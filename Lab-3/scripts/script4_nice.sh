#!/bin/bash
bash script4_while.sh&pid1=$!
bash script4_while.sh&pid2=$!
bash script4_while.sh&pid3=$!
while true; do
  cpu=$(ps -p $pid1 -o pcpu | tail -n 1)
  if (( $(echo "$cpu > 10.0" | bc -l) )); then
    ni=$(ps -p $pid1 -o ni | tail -n 1)
    if [ $ni -le 19 ]; 
      then ni=$(($ni+1))
      renice -n $ni -p $pid1
    fi
  fi
done
