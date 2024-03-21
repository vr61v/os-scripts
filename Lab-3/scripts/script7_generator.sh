#!/bin/bash
while true; do
  read line
  echo "$line" >> "script7_infile"
done
rm "script7_infile"
