#!/bin/bash
if [[ "$PWD" == *"$HOME"* ]]; then
  echo $HOME
  exit 0
fi
echo "Error: PWD is not in HOME"
exit 1
