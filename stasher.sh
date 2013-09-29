#!/bin/bash

# Look for uncommitted work
status=$(git status --short > /dev/null)
if [ $status -eq 0 ]
then
  echo "Working directory is clean!"
else
  echo "Working directory is not clean. Unclean! UNCLEAN!"
fi
