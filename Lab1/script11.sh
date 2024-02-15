#!/bin/bash
max=0
maxString=""
for string in $1 $2 $3; do
  if [[ $max -lt ${#string} ]]; then
    max=${#string}
    maxString=$string
  fi
done
echo $maxString $max
