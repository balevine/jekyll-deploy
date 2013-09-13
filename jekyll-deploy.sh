#!/bin/bash

# A script to build a Jekyll site

# Make sure you're on the 'source' branch
git checkout source > /dev/null 2>&1

# Build the Jekyll site
jekyll build > /dev/null 2>&1

# Check for the existence of a config file.
if [ -f /config ]
then
  # If the config file exists, parse it and
  # extract the 'source' and 'built' branch names
  . ~/bin/blogdeploy/config-parser.sh
else
  # If the file doesn't exist, use these defaults
  source="source"
  built="master"
fi

# Get the latest commit SHA in 'source'
last_SHA=( $(git log -n 1 --pretty=oneline) )

# Stash any changes that haven't been committed
#git stash > /dev/null

# Copy the contents of the '_site' folder in the
# working directory to a temporary folder.
# The name of the temporary folder will be the
# last commit SHA, to prevent possible conflicts
# with other folder names.
tmp_dir="temp_$last_SHA"
mkdir ~/$tmp_dir
cp -r ./_site/* ~/$tmp_dir

# Switch to the Jekyll branch, in this case 'master'
git checkout master > /dev/null 2>&1
if [ $? -eq 1 ]
then
  # Branch does not exist. Create an orphan branch.
  git checkout --orphan master > /dev/null 2>&1
  git add .
  git commit -m "New branch" > /dev/null 2>&1
  echo "New site branch created"
fi

# Remove the current contents of the 'master' branch and
# replace them with the contents of the temp folder
current_dir=${PWD}
rm -r *
git rm -r --cached * > /dev/null 2>&1
cp -r ~/$tmp_dir/* $current_dir

# Commit the changes to 'master'
message="Updated built site from 'source' - $last_SHA"
git add .
git commit -m "$message" > /dev/null 2>&1

# Delete the temporary folder
rm -r ~/$tmp_dir

# Push new site to server
git push origin master > /dev/null 2>&1

# Switch back to source
git checkout source > /dev/null 2>&1

# Push the source to the server
git push origin source > /dev/null 2>&1
