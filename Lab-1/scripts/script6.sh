#!/bin/bash
dir="/var/log/anaconda/X.log"
warn="s/(WW)/Warning:/p"
info="s/(II)/Information:/"
text=$(sed $warn $dir | sed $info)
grep "Information:" <<< $text > full.log
grep "Warning:" <<< $text >> full.log
cat full.log
