This is a simple shell script for building a Jekyll site and deploying it to GitHub. If you prefer to build your site locally and push up the resulting files, this makes that possible with a single command.

## Requirements
* I'm assuming you're using Git and Jekyll. If not, then you're in the wrong place. This script will not install those things for you.
* You need to have a repository on GitHub for these Pages.
* Your Git remote has to be set. `git push origin master` needs a place to go.

## To use it
* Keep your Jekyll source files in a branch called `source`.
* Have Jekyll send your resulting files to the `_source` folder. This is the default, so just don't mess with it.
* Commit changes to your source files. Currently, this script requires that your working directory is clean when it runs.
* Run this script from the source directory.

## What it does
* Summons `jekyll build` to build the site files.
* Moves the contents of `_site` to the `master` branch.
* Commits those changes in `master`.
* Pushes `source` and `master` to GitHub.

## Things you might want to change
* If you're using a Project Page, change `master` to `gh-pages`.
* You can change the destination folder in your `_config.yml` file, but you'll need to change the folder in this script, too.
* Just about everything else, really.

## TODO
So so much.
* I'd like to make this more generalized, probably with a config file that it reads from. I have a config file there that I was messing around with, but it's not actually being used yet. Don't be fooled.
* I also want to add in more error handling.
* Right now, I suppress all output, but I'd like to generate some useful feedback. Just a ton of things.
