#!/bin/bash
echo $$ > $1
x=1
while true; do
  x=$(($x + 1))
done
