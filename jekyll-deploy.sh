#!/bin/bash

# A script to build a Jekyll site

# Check for the existence of a config file.
if [ -f ./config ]; then
  # If the config file exists, parse it and
  #   extract the SOURCE and SITE branch names
  scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  . $scriptdir/config-parser.sh
  echo "Config file found"
  echo "- Source branch is $SOURCE"
  echo "- Site branch is $SITE"
else
  # If the file doesn't exist, use these defaults
  SOURCE="source"
  SITE="master"
  echo "No config file found, use default config values"
fi

# Make sure on the SOURCE branch
git checkout $SOURCE > /dev/null 2>&1

# Check for a clean working directory
# If the working directory is NOT clean, will stash the changes
. $scriptdir/stasher.sh

# Get the latest commit SHA in SOURCE branch
last_SHA=( $(git log -n 1 --pretty=oneline) )

# The name of the temporary folder will be the
#   last commit SHA, to prevent possible conflicts
#   with other folder names.
tmp_dir="temp_$last_SHA"

# Build the Jekyll site directly to a temporary folder
jekyll build -d ~/$tmp_dir > /dev/null 2>&1
if [ $? = 0 ]; then
  echo "Jekyll build successful"
else
  echo "Jekyll build failed"
  exit 1
fi

# Switch to the SITE branch
git checkout $SITE > /dev/null 2>&1
if [ $? = 1 ]; then
  # Branch does not exist. Create an orphan branch.
  git checkout -b $SITE > /dev/null 2>&1
  git add --all .
  git commit -m "Initial commit" > /dev/null 2>&1
  echo "$SITE branch does not exist, created new"
fi

# Remove the current contents of the SITE branch and
#   replace them with the contents of the temp folder
current_dir=${PWD}
rm -r $current_dir/*
git rm -r --cached * > /dev/null 2>&1
cp -r ~/$tmp_dir/* $current_dir

# Commit the changes to the SITE branch
message="Updated $SITE site from $SOURCE ($last_SHA)"
git add --all .
git commit -m "$message" > /dev/null 2>&1

# Delete the temporary folder
rm -r ~/$tmp_dir

# Push latest SITE to server
git push -u origin $SITE > /dev/null 2>&1
if [ $? = 0 ]; then
  echo "Push $SITE successful"
else
  echo "Push $SITE failed"
fi

# Switch back to SOURCE branch
git checkout $SOURCE > /dev/null 2>&1

# Push the SOURCE to the server
git push -u origin $SOURCE > /dev/null 2>&1
if [ $? = 0 ]; then
  echo "Push $SOURCE successful"
else
  echo "Push $SOURCE failed"
fi

# If anything is stashed, let's get it back
if [ $stashed = 1 ]; then
  git stash apply
fi

