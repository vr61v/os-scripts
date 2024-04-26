#!/bin/bash
if [[ -e report.log ]]; then rm report.log; fi
if [[ -e memory.csv ]]; then rm memory.csv; fi
echo "Iteration;Array size;Memory size" >> memory.csv
echo "$$"
array=()
i=0
while true; do
    array+=(1 2 3 4 5 6 7 8 9 10)
    let "++i"
    let "c=i % 100000"
    if [[ "$c" -eq 0 ]]; then
        echo ${#array[@]} >> report.log
        size=$(cat "/proc/$$/status" | grep "VmSize" | awk '{print $2}')
        echo "$i;${#array[@]};$size" >> memory.csv
    fi
done
