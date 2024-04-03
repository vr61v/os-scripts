#!/bin/bash
if [ $# -ne 1 ]; then exit 1; fi

files=$(grep -h "$1" "$HOME"/trash.log)
echo "$files"
for i in $files; do
  oldpath=$(echo "$i" | awk -F ":" '{print $1}')
  newpath=$(echo "$i" | awk -F ":" '{print $2}')
  removed=$HOME/.trash/$newpath
  echo "restore the $oldpath (y/n)?"
  read -r answer
  if [ "$answer" == "y" ]; then
    directory=$(dirname "$oldpath")
    if [ -d "$directory" ]; then
      if [ -e "$oldpath" ]; then
        echo "a file with that name already exists, enter a new name: "
        read -r name
        ln "$removed" "$directory/$name"
      else
        ln "$removed" "$oldpath"
      fi
    else
      echo "the $directory no exists, the file has been saved in $HOME"
      ln "$removed" "$HOME"/"$1"
    fi
    rm "$removed"
  fi
done