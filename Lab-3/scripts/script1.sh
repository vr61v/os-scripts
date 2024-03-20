#!/bin/bash
date=$(date "+%d.%m.%y_%H:%M:%S")
message="catalog test was created successfuly"
error="$date error: www.net_nikogo.ru is unavailable"
mkdir ~/test && echo $message >> ~/report && touch ~/test/$date.tmp
ping www.net_nikogo.ru || echo $error >> ~/report
