#!/bin/bash
date=$(date "+%F")
last=$(ls "$HOME" -1 | grep -E "Backup-[0-9]{4}-[0-9]{2}-[0-9]{2}" | sort -r -k2 | head -1)
let secons=$(date --date=$(ls "$HOME" -1 | grep -Eo "Backup-[0-9]{4}-[0-9]{2}-[0-9]{2}" | sort -r -k2 | head -1 | sed "s/^Backup-//") "+%s")
let difference=($(date --date=$date "+%s")-$secons)/60/60/24
if [ "$difference" -gt 7 ] || [ -z "$last" ]; then
    mkdir "$HOME/Backup-$date"
    backup="$HOME/Backup-$date/"
    echo "backup $date created in $HOME/source" >> "$HOME/backup-report"
    echo "files coppied: " >> "$HOME/backup-report"
    for file in $(echo "$(ls "$HOME/source")" | tr ' ' @); do
        newfile=$(echo $file | tr @ ' ')
        if [ -d "$HOME/source/$newfile" ]; then 
            echo "$newfile is dir"
            continue; 
        fi
        cp "$HOME/source/$newfile" "$backup/$newfile"
        echo "$file" >> "$HOME/backup-report"
    done
else
    backup="$HOME/$last/"
    echo "backup $backup updated in $date" >> "$HOME/backup-report"
    for file in $(echo "$(ls "$HOME/source")" | tr ' ' @); do
        newfile=$(echo $file | tr @ ' ')
        if [ -d "$HOME/source/$newfile" ]; then 
            echo "$newfile is dir"
            continue; 
        fi
        
        current=$backup$newfile
        if [ -f "$current" ]; then
            sourceSize=$(stat $"$HOME/source/$newfile" -c%s)
            currentSize=$(stat "$current" -c%s)
            if [ "$sourceSize" != "$currentSize" ]; then
                mv "$current" "$current.$date"
                cp "$HOME/source/$newfile" "$current"
                echo "replace $newfile.$date on $newfile" >> "$HOME/backup-report"
            fi
        else
            cp "$HOME/source/$newfile" "$backup"
            echo "coppy $newfile" >> "$HOME/backup-report"
        fi
    done
fi
