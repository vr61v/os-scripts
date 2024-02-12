#!/bin/bash
string=""
buffer=""
while [[ "$buffer" != "q" ]]; do
  read buffer
  string="$string $buffer"
done
echo $string
