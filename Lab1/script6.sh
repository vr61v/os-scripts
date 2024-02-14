#!/bin/bash
dir="/var/log/anaconda/syslog"
warn="s/WARNING/Warning:/p"
info="s/INFO/Information:/"
sed $warn $dir | sed $info > full.log
