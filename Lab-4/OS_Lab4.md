# Лабораторная работа №4.
## Работа с файлово-каталожной системой в ОС Linux.

### Script rmtrash
- Скрипту передается один параметр – имя файла в текущем каталоге вызова скрипта.
- Скрипт проверяет, создан ли скрытый каталог trash в домашнем каталоге пользователя. Если он
не создан – создает его.
- После этого скрипт создает в этом каталоге жесткую ссылку на переданный файл с уникальным
именем (например, присваивает каждой новой ссылке имя, соответствующее следующему
натуральному числу) и удаляет файл в текущем каталоге.
- Затем в скрытый файл trash.log в домашнем каталоге пользователя помещается запись,
содержащая полный исходный путь к удаленному файлу и имя созданной жесткой ссылки.
```
#!/bin/bash
file=$RANDOM
if [ $# -ne 1 ]; then exit 1; fi
if ! [ -f "$1" ]; then exit 1; fi
if ! [ -d "$HOME/.trash" ]; then mkdir "$HOME/.trash"; fi

ln "$1" "$HOME/.trash/$file"
rm "$1"

if ! [ -e "$HOME/trash.log" ]; then touch "$HOME/trash.log"; fi
echo "$PWD/$1:$file" >> "$HOME/trash.log"
```


### Script untrash
- Скрипту передается один параметр – имя файла, который нужно восстановить (без полного пути –
только имя).
- Скрипт по файлу trash.log должен найти все записи, содержащие в качестве имени файла
переданный параметр, и выводить по одному на экран полные имена таких файлов с запросом
подтверждения.
- Если пользователь отвечает на подтверждение положительно, то предпринимается попытка
восстановить файл по указанному полному пути (создать в соответствующем каталоге жесткую
ссылку на файл из trash и удалить соответствующий файл из trash). Если каталога, указанного
в полном пути к файлу, уже не существует, то файл восстанавливается в домашний каталог
пользователя с выводом соответствующего сообщения. При невозможности создать жесткую
ссылку, например, из-за конфликта имен, пользователю предлагается изменить имя
восстанавливаемого файла.
```
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
```


### Script backup
- Скрипт создаст в /home/user/ каталог с именем Backup-YYYY-MM-DD, где YYYY-MM-DD –
дата запуска скрипта, если в /home/user/ нет каталога с именем, соответствующим дате,
отстоящей от текущей менее чем на 7 дней. Если в /home/user/ уже есть «действующий»
каталог резервного копирования (созданный не ранее 7 дней от даты запуска скрипта), то новый
каталог не создается. Для определения текущей даты можно воспользоваться командой date.
- Если новый каталог был создан, то скрипт скопирует в этот каталог все файлы из каталога
/home/user/source/ (для тестирования скрипта создайте такую директорию и набор файлов в
ней). После этого скрипт выведет в режиме дополнения в файл /home/user/backup-report
следующую информацию: строка со сведениями о создании нового каталога с резервными
копиями с указанием его имени и даты создания; список файлов из /home/user/source/,
которые были скопированы в этот каталог.
- Если каталог не был создан (есть «действующий» каталог резервного копирования), то скрипт
должен скопировать в него все файлы из /home/user/source/ по следующим правилам: если
файла с таким именем в каталоге резервного копирования нет, то он копируется из
/home/user/source. Если файл с таким именем есть, то его размер сравнивается с размером
одноименного файла в действующем каталоге резервного копирования. Если размеры совпадают,
файл не копируется. Если размеры отличаются, то файл копируется c автоматическим созданием
версионной копии, таким образом, в действующем каталоге резервного копирования появляются
обе версии файла (уже имеющийся файл переименовывается путем добавления дополнительного
расширения «.YYYY-MM-DD» (дата запуска скрипта), а скопированный сохраняет имя). После
окончания копирования в файл /home/user/backup-report выводится строка о внесении
изменений в действующий каталог резервного копирования с указанием его имени и даты
внесения изменений, затем строки, содержащие имена добавленных файлов с новыми именами, а
затем строки с именами добавленных файлов с существовавшими в действующем каталоге
резервного копирования именами с указанием через пробел нового имени, присвоенного
предыдущей версии этого файла.
```
#!/bin/bash
date=$(date "+%F")
last=$(ls "$HOME" -1 | grep -E "Backup-[0-9]{4}-[0-9]{2}-[0-9]{2}" | sort -r -k2 | head -1)
let secons=$(date --date=$(ls "$HOME" -1 | grep -Eo "Backup-[0-9]{4}-[0-9]{2}-[0-9]{2}" | sort -r -k2 | head -1 | sed "s/^Backup-//") "+%s")
let difference=($(date --date=$date "+%s")-$secons)/60/60/24
echo "$difference"
if [ "$difference" -gt 7 ] || [ -z "$last" ]; then
    mkdir "$HOME/Backup-$date"
    backup="$HOME/Backup-$date/"
    echo "backup $date created in $HOME/source" >> "$HOME/backup-report"
    echo "files coppied: " >> "$HOME/backup-report"
    for file in $(ls "$HOME/source" -1); do
        cp "$HOME/source/$file" "$backup$file"
        echo "$file" >> "$HOME/backup-report"
    done
else
    backup="$HOME/$last/"
    echo "backup $backup updated in $date" >> "$HOME/backup-report"
    for file in $(ls "$HOME/source" -1); do
        current=$backup$file
        echo "$current"
        if [ -f "$current" ]; then
            sourceSize=$(stat $"$HOME/source/$file" -c%s)
            currentSize=$(stat "$current" -c%s)
            if [ "$sourceSize" != "$currentSize" ]; then
                mv "$current" "$current.$date"
                cp "$HOME/source/$file" "$current"
                echo "replace $file.$date on $file" >> "$HOME/backup-report"
            fi
        else
            cp "$HOME/source/$file" "$backup"
            echo "coppy $file" >> "$HOME/backup-report"
        fi
    done
fi
```


### Script upback
- Скрипт должен скопировать в каталог /home/user/restore/ все файлы из актуального на
данный момент каталога резервного копирования (имеющего в имени наиболее свежую дату), за
исключением файлов с предыдущими версиями.
```
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
```