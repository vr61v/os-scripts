#!/bin/bash
if [ ! -d "$HOME/restore/" ]; then mkdir "$HOME/restore/"; fi
backup="$(find "$HOME/Backup-"* -maxdepth 0 | sort -n | tail -n 1)/"
for file in $(echo "$(ls "$backup")" | tr ' ' @); do
  newfile=$(echo $file | tr @ ' ')
  duplicate="$(echo "$newfile" | grep -Eo "$*.[0-9]{4}-[0-9]{2}-[0-9]{2}")"
  if [ -z "$duplicate" ]; then
    if [[ "$newfile" =~ '|' ]]; then newfile="$(echo "$newfile" | tr '|' '\|')"; fi
    duplicates="$(ls "$backup" -1 | grep -Eo "$(echo "$newfile").[0-9]{4}-[0-9]{2}-[0-9]{2}")"
    if [ -z "$duplicates" ]; then cp "$backup$newfile" "$HOME/restore/"; fi
  fi
done