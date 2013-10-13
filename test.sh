#!/bin/bash

# Run some roundup tests for jekyll-deploy.
#
# This file was lifted from holman's spark test.

roundup=$(which roundup)

[ ! -z $roundup ] || {
  echo "Sorry, buddy, you don't have roundup."
  echo "Go to https://github.com/bmizerany/roundup to get it."

  exit 1;
}

$roundup ./*-test.sh
