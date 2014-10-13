#!/bin/sh

i=1

while true; do
  echo $((i*10))
  sleep 10
  i=$((i+1))
done
