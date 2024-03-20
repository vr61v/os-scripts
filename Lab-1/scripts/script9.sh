#!/bin/bash
files=`ls /var/log/*.log`
wc -l $files | tail -n1 | awk '{print $1}'
