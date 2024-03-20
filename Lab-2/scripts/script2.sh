#!/bin/bash
ps -ef | awk '{print $2 ":" $8}' | grep ':/sbin/*' | awk -F: '{print $1}'
