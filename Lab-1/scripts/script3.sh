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
