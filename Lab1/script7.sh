#!/bin/bash
dir="/etc/"
pattern="[a-zA-Z0-9]\+@[a-zA-Z0-9]\+\.[a-zA-Z0-9]\+"
grep --no-messages --no-filename --only-matching -r $pattern $dir | tr '\n' ',' > emails.lst
