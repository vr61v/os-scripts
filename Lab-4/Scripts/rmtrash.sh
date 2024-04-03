#!/bin/bash
file=$RANDOM
if [ $# -ne 1 ]; then exit 1; fi
if ! [ -f "$1" ]; then exit 1; fi
if ! [ -d "$HOME/.trash" ]; then mkdir "$HOME/.trash"; fi

ln "$1" "$HOME/.trash/$file"
rm "$1"

if ! [ -e "$HOME/trash.log" ]; then touch "$HOME/trash.log"; fi
echo "$PWD/$1:$file" >> "$HOME/trash.log"