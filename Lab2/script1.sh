#!/bin/bash
ps -u | awk '{print $2 ":" $11}' > process.txt
process=$(cat process.txt | wc | awk '{print "Total user process: " $1 - 1}')
sed -i "1i$process" process.txt
