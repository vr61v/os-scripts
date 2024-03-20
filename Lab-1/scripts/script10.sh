#!/bin/bash
echo $(man bash) | grep -o --color '[a-zA-Z0-9]\{4,\}' | sort | uniq -c | sort -r -k1 -n | head -n3 | awk {'print $2'} 
