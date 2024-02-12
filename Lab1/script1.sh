#!/bin/bash
let max=0
for i in $1 $2 $3; do
  if [[ "$max" -lt "$i" ]]; then
    max=$i
  fi
done
echo $max
