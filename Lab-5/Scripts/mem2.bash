#!/bin/bash
if [[ -e report2.log ]]; then rm report2.log; fi
if [[ -e memory2.csv ]]; then rm memory2.csv; fi
echo "Iteration;Array size;memory2 size" >> memory2.csv
echo "$$"
array=()
i=0
while true; do
    array+=(1 2 3 4 5 6 7 8 9 10)
    let "++i"
    let "c=i % 100000"
    if [[ "$c" -eq 0 ]]; then
        echo ${#array[@]} >> report2.log
        size=$(cat "/proc/$$/status" | grep "VmSize" | awk '{print $2}')
        echo "$i;${#array[@]};$size" >> memory2.csv
    fi
done
