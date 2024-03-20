### Script 1
Посчитать количество процессов, запущенных пользователем user, и вывести в файл получившееся
число, а затем пары PID:команда для таких процессов.
```
#!/bin/bash
outFile="outFile_1.txt"
ps -u | awk '{print $2 ":" $11}' > $outFile
process=$(cat $outFile | wc | awk '{print "Total user process: " $1 - 1}')
sed -i "1i$process" $outFile
```

### Script 2
Вывести в файл список PID всех процессов, которые были запущены командами, расположенными в
/sbin/
```
#!/bin/bash
ps -ef | awk '{print $2 ":" $8}' | grep ':/sbin/*' | awk -F: '{print $1}'
```

### Script 3
Вывести на экран PID процесса, запущенного последним (с последним временем запуска).
```
#!/bin/bash
ps -ef | sort -n -k5 | tail -n1 | awk '{print $2}'
```

### Script 4
Для всех зарегистрированных в данный момент в системе процессов определить среднее время
непрерывного использования процессора (CPU_burst) и вывести в один файл строки
ProcessID=PID : Parent_ProcessID=PPID : Average_Running_Time=ART.
Значения PPid взять из файлов status, которые находятся в директориях с названиями,
соответствующими PID процессов в /proc. Значения ART получить, разделив значение
sum_exec_runtime на nr_switches, взятые из файлов sched в этих же директориях.
Отсортировать эти строки по идентификаторам родительских процессов.
```
#!/bin/bash
outFile="outFile_4.txt"
outFileSorted="outFileSorted_4.txt"

process=$(ls /proc/ | grep '\<[0-9]*\>')
for i in $process; do
  if [[ ! -d /proc/$i ]]; then continue; fi
  ppid=$(cat /proc/$i/status | grep 'PPid' | awk '{print $2}')
  ser=$(cat /proc/$i/sched | grep 'sum_exec_runtime' | awk '{print $3}')
  ns=$(cat /proc/$i/sched | grep 'nr_switches' | awk '{print $3}')
  art=$(echo "$ser/$ns" | bc -l)
  nice=$(ps -p $i -o pid,ni --no-header | awk '{print $2}')
  echo "$i $ppid $art $nice" >> $outFile
done

sort $outFile -o $outFileSorted -nk2
awk '{print "ProcessID="$1" : Parent_ProcessID="$2" : Average_Running_Time="$3" : Nice="$4}' $outFileSorted > $outFile
rm $outFileSorted
```

### Script 5
В полученном на предыдущем шаге файле после каждой группы записей с одинаковым
идентификатором родительского процесса вставить строку вида Average_Running_Children_of_ParentID=N is M, где N = PPID, а M – среднее, посчитанное из ART для всех процессов этого родителя.
```
#!/bin/bash
currentPpid=0; sum=.0; count=0; i=0
while read line; do
  pid=$(echo $line | awk '{print $1}' | awk -F= '{print $2}')
  ppid=$(echo $line | awk '{print $3}' | awk -F= '{print $2}')
  art=$(echo $line | awk '{print $5}' | awk -F= '{print $2}')

  if [[ $currentPpid -ne $ppid ]]; then
    result=$(bc -l <<<"$sum/$count")
    echo "Average_Running_Children_of_ParentID=$currentPpid is $result" >> "outFile_5.txt"
    currentPpid=$ppid; sum=.0; count=0
  fi

  sum=$(bc<<<"$sum+$art")
  let count=$count+1
  let i=$i+1
  echo "ProcessID=$pid : Parent_ProcessID=$ppid : Average_Running_Time=$art" >> "outFile_5.txt"
done < "outFile_4.txt"
```

### Script 6
Используя псевдофайловую систему /proc найти процесс, которому выделено больше всего
оперативной памяти. Сравнить результат с выводом команды top.
```
#!/bin/bash
process=$(ls /proc/ | grep '\<[0-9]*\>')
for i in $process; do
  if [[ ! -d /proc/$i ]]; then continue; fi
  mem=$(cat /proc/$i/status | grep -i VMSIZE | awk '{print $2}')
  echo $i " " $mem >> outFile_6.txt
done
echo $(cat "outFile_6.txt" | sort -rnk2 | head -n1); rm "outFile_6.txt"
```

### Script 7
Написать скрипт, определяющий три процесса, которые за 1 минуту, прошедшую с момента запуска скрипта, считали максимальное количество байт из устройства хранения данных. Скрипт должен выводить PID, строки запуска и объем считанных данных, разделенные двоеточием.
```
#!/bin/bash
commands=$(ps aux | awk '{print $2 ":" $11}' | sed '/PID COMMAND/d')
for line in $commands; do
  pid=$(echo $line | awk -F: '{print $1}')
  if [[ ! -d /proc/$pid ]]; then continue; fi
  command=$(echo $line | awk -F: '{print $2}')
  startv=$(sudo cat /proc/$pid/io | grep "read_bytes" | awk '{print $2}')
  echo $pid $command $startv >> "outFile_7Buffer.txt"
done

sleep 30

while read line; do
  pid=$(echo $line | awk '{print $1}')
  if [[ ! -d /proc/$pid ]]; then continue; fi
  command=$(echo $line | awk '{print $2}')
  startv=$(echo $line | awk '{print $3}')
  endv=$(sudo cat /proc/$pid/io | grep "read_bytes" | awk '{print $2}')
  echo $pid $command $(($endv-$startv)) >> "outFile_7.txt"
done < "outFile_7Buffer.txt"
rm "outFile_7Buffer.txt"

echo $(cat "outFile_7.txt" | sort -rnk3 | head -n3 | awk '{print "PID:"$1" COMMAND:"$2 " VALUE:"$3}')
```