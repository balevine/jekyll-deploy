#!/bin/bash

# A script to build a Jekyll site

# Check for the existence of a config file.
if [ -f ./config ]
then
  # If the config file exists, parse it and
  # extract the 'source' and 'built' branch names
  scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  . $scriptdir/config-parser.sh
  echo "Config file found"
  echo $source
  echo $built
else
  # If the file doesn't exist, use these defaults
  source="source"
  built="master"
  echo "No config file found"
  echo "Using default config values"
fi

# Make sure you're on the 'source' branch
git checkout $source > /dev/null 2>&1

# Let's check for a clean working directory
# If the working directory is NOT clean, we'll stash the changes
. $scriptdir/stasher.sh
if [ $? = 99 ]; then
  # Something is stashed
  stashed=1
else
  # Nothing is stashed
  stashed=0
fi

# Build the Jekyll site
jekyll build > /dev/null 2>&1
if [ $? = 0 ]
then
  echo "Jekyll build successful"
else
  echo "Jekyll build failed"
  exit 1
fi

# Get the latest commit SHA in 'source'
last_SHA=( $(git log -n 1 --pretty=oneline) )

# Copy the contents of the '_site' folder in the
# working directory to a temporary folder.
# The name of the temporary folder will be the
# last commit SHA, to prevent possible conflicts
# with other folder names.
tmp_dir="temp_$last_SHA"
mkdir ~/$tmp_dir
cp -r ./_site/* ~/$tmp_dir

# Switch to the Jekyll branch
git checkout $built > /dev/null 2>&1
if [ $? -eq 1 ]
then
  # Branch does not exist. Create an orphan branch.
  git checkout --orphan $built > /dev/null 2>&1
  git add .
  git commit -m "New branch" > /dev/null 2>&1
  echo "New site branch created"
fi

# Remove the current contents of the built branch and
# replace them with the contents of the temp folder
current_dir=${PWD}
rm -r $current_dir/*
git rm -r --cached * > /dev/null 2>&1
cp -r ~/$tmp_dir/* $current_dir

# Commit the changes to the built branch
message="Updated built site from 'source' - $last_SHA"
git add .
git commit -m "$message" > /dev/null 2>&1

# Delete the temporary folder
rm -r ~/$tmp_dir

# Push new site to server
git push origin $built > /dev/null 2>&1
if [ $? = 0 ]
then
  echo "Site push successful"
else
  echo "Site push failed"
fi

# Switch back to source
git checkout $source > /dev/null 2>&1

# Push the source to the server
git push origin $source > /dev/null 2>&1
if [ $? = 0 ]
then
  echo "Source push successful"
else
  echo "Source push failed"
fi

# If anything is stashed, let's get it back
if [ $stashed = 1 ]; then
  git stash apply
fi
