#!/bin/bash

# Look for uncommitted work
status=$(git status)
echo $status | grep -qF 'working directory clean'
if [ $? = 0 ]; then
  # The working directory is clean
  # We can move on
  exit 0
else
  # The working directory is NOT clean
  # We're gonna need to stash some shit
  # Then we can move on
  git stash

  # Lets use the exit code 99
  # This will mean there's something stashed
  exit 99
fi
