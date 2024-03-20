#!/bin/bash
echo $$ > .pid
val=1
mode=""
usr1() { mode="sum"; }
usr2() { mode="mult"; }
sigtrem() { mode="sigtrem"; exit; } 
trap 'usr1' USR1
trap 'usr2' USR2
trap 'sigtrem' SIGTREM
while true; do
  case $mode in
    "sum") let val=$val+2 ;;
    "mult") let val=$val*2 ;;
  esac
  echo $val
  sleep 1
done
