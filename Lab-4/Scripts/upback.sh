#!/bin/bash
if [ ! -d "$HOME/restore/" ]; then mkdir "$HOME/restore/"; fi
backup="$(find "$HOME/Backup-"* -maxdepth 0 | sort -n | tail -n 1)/"
for file in $(ls "$backup" -1); do
  duplicate="$(echo "$file" | grep -Eo "$*.[0-9]{4}-[0-9]{2}-[0-9]{2}")"
  if [ -z "$duplicate" ]; then
    duplicates="$(ls "$backup" -1 | grep -Eo "$file.[0-9]{4}-[0-9]{2}-[0-9]{2}")"
    if [ -z "$duplicates" ]; then cp "$backup$file" "$HOME/restore/"; fi
  fi
done