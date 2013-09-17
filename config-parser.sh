#!/bin/bash

# Parse the config file

# Read the config file into separate lines
index=0
while read line
do
  text[$index]="$line"
  index=$[index+1]
done <./config

# For each line, read the individual words
index=0
for stuff in ${text[@]}
do
  configtext[index]=$stuff
  index=$[index+1]
done

# Match the keys to their values
index=0
for i in ${configtext[@]}
do
  next=$[index+1]
  case $i in
  source:)
    source=${configtext[$next]}
  ;;
  built:)
    built=${configtext[$next]}
  ;;
  esac
  index=$next
done
