# Лабораторная работа №1. 
## Основы использования консольного интерфейса ОС Linux и интерпретатора bash.
### Script 1
В параметрах при запуске скрипта передаются три целых числа. Вывести максимальное из них.
```
#!/bin/bash
let max=0
for i in $1 $2 $3; do
  if [[ "$max" -lt "$i" ]]; then
    max=$i
  fi
done
echo $max
```

### Script 2
Считывать строки с клавиатуры, пока не будет введена строка "q". После этого вывести
последовательность считанных строк в виде одной строки.
```
#!/bin/bash
string=""
buffer=""
while [[ "$buffer" != "q" ]]; do
  read buffer
  string="$string $buffer"
done
echo $string
```

### Script 3
Создать текстовое меню с четырьмя пунктами. При вводе пользователем номера пункта меню
происходит запуск редактора nano, редактора vi, браузера links или выход из меню.
```
#!/bin/bash
item=""
while [[ "$item" != "4" ]]; do
  echo "1-nano 2-vi 3-links 4-exit"
  read item
  case $item in
  "1") nano "test" ;;
  "2") vi "test" ;;
  "3") links http://google.com ;;
  esac
done
```

### Script 4
Если скрипт запущен из домашнего директория, вывести на экран путь к домашнему директорию и
выйти с кодом 0. В противном случае вывести сообщение об ошибке и выйти с кодом 1.
```
#!/bin/bash
if [[ "$PWD" == "$HOME" ]]; then
  echo $HOME
  exit 0
fi
echo "Error: PWD is not in HOME"
exit 1
```

### Script 5
Создать файл info.log, в который поместить все строки из файла /var/log/anaconda/syslog,
второе поле в которых равно INFO.
```
#!/bin/bash
awk {'if ($2 == "INFO") print '} /var/log/anaconda/syslog > info.log
```

### Script 6
Создать full.log, в который вывести строки файла /var/log/anaconda/X.log, содержащие
предупреждения и информационные сообщения, заменив маркеры предупреждений и
информационных сообщений на слова Warning: и Information:, чтобы в получившемся файле
сначала шли все предупреждения, а потом все информационные сообщения. Вывести этот файл на
экран.
```
#!/bin/bash
dir="/var/log/anaconda/X.log"
warn="s/(WW)/Warning:/p"
info="s/(II)/Information:/"
text=$(sed $warn $dir | sed $info)
grep "Information:" <<< $text > full.log
grep "Warning:" <<< $text >> full.log
cat full.log
```

### Script 7
Создать файл emails.lst, в который вывести через запятую все адреса электронной почты,
встречающиеся во всех файлах директории /etc.
```
#!/bin/bash
dir="/etc/"
pattern="[a-zA-Z0-9]\+@[a-zA-Z0-9]\+\.[a-zA-Z0-9]\+"
grep --no-messages --no-filename --only-matching -r $pattern $dir | tr '\n' ',' > emails.lst
```

### Script 8
Вывести список пользователей системы с указанием их UID, отсортировав по UID. Сведения о
пользователей хранятся в файле /etc/passwd. В каждой строке этого файла первое поле – имя
пользователя, третье поле – UID. Разделитель – двоеточие.
```
#!/bin/bash
dir="/etc/passwd"
awk -F: '{print $1, $3}' $dir | sort -n -k2
```

### Script 9
Подсчитать общее количество строк в файлах, находящихся в директории /var/log/ и имеющих
расширение log.
```
#!/bin/bash
files=`ls /var/log/*.log`
wc -l $files | tail -n1 | awk '{print $1}'
```

### Script 10
Вывести три наиболее часто встречающихся слова из man по команде bash длиной не менее четырех
символов.
```
#!/bin/bash
echo $(man bash) | grep -o --color '[a-zA-Z0-9]\{4,\}' | sort | uniq -c | sort -r -k1 -n | head -n3 | awk {'print $2'} 
```