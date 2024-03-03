#!/bin/bash
outFile="outFile_1.txt"
ps -u | awk '{print $2 ":" $11}' > $outFile
process=$(cat $outFile | wc | awk '{print "Total user process: " $1 - 1}')
sed -i "1i$process" $outFile
