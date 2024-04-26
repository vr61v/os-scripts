## Эксперимент №1

### Информация о системе
```
vr61v@localhost ~]$ free
               total        used        free      shared  buff/cache   available
Mem:         1679284     1271808       61952       91656      527292      407476
Swap:        4149244        9984     4139260
```

```
[vr61v@localhost ~]$ cat /proc/meminfo
MemTotal:        1679284 kB
MemFree:           51596 kB
MemAvailable:     393260 kB
Buffers:               0 kB
Cached:           455928 kB
SwapCached:         1432 kB
Active:           571008 kB
Inactive:         780248 kB
Active(anon):     432708 kB
Inactive(anon):   556992 kB
Active(file):     138300 kB
Inactive(file):   223256 kB
Unevictable:       76672 kB
Mlocked:              48 kB
SwapTotal:       4149244 kB
SwapFree:        4139260 kB
Zswap:                 0 kB
Zswapped:              0 kB
Dirty:                12 kB
Writeback:             0 kB
AnonPages:        960948 kB
Mapped:           197852 kB
Shmem:             94372 kB
KReclaimable:      70220 kB
Slab:             132416 kB
SReclaimable:      70220 kB
SUnreclaim:        62196 kB
KernelStack:        8048 kB
PageTables:        17176 kB
SecPageTables:         0 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     4988884 kB
Committed_AS:    4007188 kB
VmallocTotal:   133141626880 kB
VmallocUsed:       21620 kB
VmallocChunk:          0 kB
Percpu:              968 kB
HardwareCorrupted:     0 kB
AnonHugePages:    167936 kB
ShmemHugePages:        0 kB
ShmemPmdMapped:        0 kB
FileHugePages:         0 kB
FilePmdMapped:         0 kB
CmaTotal:              0 kB
CmaFree:               0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
Hugetlb:               0 kB
```

### Подготовительный этап:
Создайте скрипт mem.bash, реализующий следующий сценарий. Скрипт выполняет бесконечный цикл. Перед началом выполнения цикла создается пустой массив и счетчик шагов, инициализированный нулем. На каждом шаге цикла в конец массива добавляется последовательность из 10 элементов, например, (1 2 3 4 5 6 7 8 9 10). Каждый 100000-ый шаг в файл report.log добавляется строка с текущим значением размера массива (перед запуском скрипта, файл обнуляется).
```
#!/bin/bash
if [[ -e report.log ]]; then rm report.log; fi
echo "$$"
array=()
i=0
while true; do
    array+=(1 2 3 4 5 6 7 8 9 10)
    let "++i"
    let "c=i % 100000"
    if [[ "$c" -eq 0 && $i -gt 1000 ]]; then
        echo ${#array[@]} >> report.log
    fi
done
```

### Первый этап:
- Запустите созданный скрипт mem.bash. Дождитесь аварийной остановки процесса и вывода в консоль последних сообщений системного журнала. Зафиксируйте в отчете последнюю запись журнала - значения параметров, с которыми произошла аварийная остановка процесса. Также зафиксируйте значение в последней строке файла report.log.
```
[vr61v@localhost Scripts]$ bash mem.bash 
3749
Killed
[vr61v@localhost Scripts]$ tail -n1 report.log
56000000
```

- Посмотрите с помощью команды dmesg | grep "mem.bash" последние две записи о скрипте в системном журнале и зафиксируйте их в отчете. Также зафиксируйте значение в последней строке файла report.log.
```
[vr61v@localhost Scripts]$ dmesg | grep 3749
[    0.003749] alternatives: applying system-wide alternatives
[  223.119371] [   3749]  1000  3749  1157980   325376  8916992   777120           200 bash
[  223.119377] oom-kill:constraint=CONSTRAINT_NONE,nodemask=(null),cpuset=/,mems_allowed=0,
global_oom,task_memcg=/user.slice/user-1000.slice/user@1000.service/app.slice/app-org.gnome.
Terminal.slice/vte-spawn-c43c2bc4-eff7-4abf-b585-f21dd1830fcb.scope,task=bash,pid=3749,uid=1000
[  223.119395] Out of memory: Killed process 3749 (bash) total-vm:4631920kB, anon-rss:1301504kB, 
file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:8708kB oom_score_adj:200
```

### Второй этап:
Создайте копию скрипта, созданного на предыдущем этапе, в файл mem2.bash. Настройте её на запись в файл report2.log. Создайте скрипт, который запустит немедленно друг за другом оба скрипта в фоновом режиме.
```
#!/bin/bash
./mem.bash&
./mem2.bash&
```
Посмотрите с помощью команды dmesg | grep "mem[2]*.bash" последние записи о скриптах в системном журнале и зафиксируйте их в отчете. Также зафиксируйте значения в последних строках файлов report.log и report2.log.
```
[vr61v@localhost Scripts]$ sudo bash runmem.bash 
6308
6309
[vr61v@localhost Scripts]$ tail -n1 report.log 
61000000
[vr61v@localhost Scripts]$ tail -n1 report2.log 
30000000
```
```
[vr61v@localhost Scripts]$ dmesg | grep 6308
[    0.006308] ASID allocator initialised with 256 entries
[   12.463086] systemd[1]: systemd 252-27.el9 running in system mode (+PAM +AUDIT +SELINUX 
-APPARMOR +IMA +SMACK +SECCOMP +GCRYPT +GNUTLS +OPENSSL +ACL +BLKID +CURL +ELFUTILS -FIDO2 
+IDN2 -IDN -IPTC +KMOD +LIBCRYPTSETUP +LIBFDISK +PCRE2 -PWQUALITY +P11KIT -QRENCODE +TPM2 
+BZIP2 +LZ4 +XZ +ZLIB +ZSTD -BPF_FRAMEWORK +XKBCOMMON +UTMP +SYSVINIT default-hierarchy=unified)
[ 1060.280951] [   6308]     0  6308   651001   156800  4849664   438688           200 mem.bash
[ 1109.285849] CPU: 0 PID: 6308 Comm: mem.bash Kdump: loaded Tainted: P           OE     -------  ---  5.14.0-427.el9.aarch64 #1
[ 1109.286643] [   6308]     0  6308  1256056   324256  9699328   876352           200 mem.bash
[ 1109.286652] oom-kill:constraint=CONSTRAINT_NONE,nodemask=(null),cpuset=/,mems_allowed=
0,global_oom,task_memcg=/user.slice/user-1000.slice/user@1000.service/app.slice/app-org.gnome.
Terminal.slice/vte-spawn-70ef2b05-97f2-4648-b725-e846130522d8.scope,task=mem.bash,pid=6308,uid=0
[ 1109.286717] Out of memory: Killed process 6308 (mem.bash) total-vm:5024224kB, anon-rss:1296896kB, 
file-rss:128kB, shmem-rss:0kB, UID:0 pgtables:9472kB oom_score_adj:200
[vr61v@localhost Scripts]$ dmesg | grep 6309
[ 1060.280952] [   6309]     0  6309   660109   161088  4919296   443456           200 mem2.bash
[ 1060.280957] oom-kill:constraint=CONSTRAINT_NONE,nodemask=(null),cpuset=/,mems_allowed=0,
global_oom,task_memcg=/user.slice/user-1000.slice/user@1000.service/app.slice/app-org.gnome.
Terminal.slice/vte-spawn-70ef2b05-97f2-4648-b725-e846130522d8.scope,task=mem2.bash,pid=6309,uid=0
[ 1060.280980] Out of memory: Killed process 6309 (mem2.bash) total-vm:2640436kB, anon-rss:644352kB, 
file-rss:0kB, shmem-rss:0kB, UID:0 pgtables:4804kB oom_score_adj:200
[ 1109.286309]  el0_ia+0xd4/0x1a0
```