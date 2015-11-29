#!/bin/bash
# usage: watch.sh <your_command> <sleep_duration>

while :;
  do
  clear;
  echo "$(date)"
  $1;
  sleep $2;
done