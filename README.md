This is a simple shell script for building a Jekyll site and deploying it to GitHub. If you prefer to build your site locally and push up the resulting files, this makes that possible with a single command.

## Requirements
* I'm assuming you're using Git and Jekyll. If not, then you're in the wrong place. This script will not install those things for you.
* You need to have a repository on GitHub for these Pages.
* Your Git remote has to be set. `git push origin master` needs a place to go.

## To use it
* Keep your Jekyll source files in a branch called `source`.
* Have Jekyll send your resulting files to the `_site` folder. This is the default, so just don't mess with it.
* Commit changes to your source files. Currently, this script requires that your working directory is clean when it runs.
* Run this script from the source directory.

## Using the config file
* Put a file in your Pages repository called `config`.
* In that file, you can set the source branch and the destination branch for the Jekyll build.
* Format the config file like this:
```
source: source-branch-name
built: destination-branch-name
```
* The `source:` and `built:` part have to be there, you can change the names of the branches all you want.
* If you choose not to use a config file, the defaults will be `source` and `master`.
* If you DO have a config file, both lines must be there and must be filled in with branch names.

## What it does
* Summons `jekyll build` to build the site files.
* Moves the contents of `_site` to the destination branch.
* Commits those changes in the destination branch.
* Pushes the source and destination branches to GitHub.

## Things you might want to change
* You can change the destination folder in your `_config.yml` file, but you'll need to change the folder in this script, too.
* Just about everything else, really.

## TODO
So so much.
* I want to add in more error handling.
* Move locations of some of the files. I actually use the `~/bin/blogdeploy/config-parser.sh` path in there, which is dumb.
* Create an installation script. There are currently three `.sh` files that this uses. It would be cool to have a `script/bootstrap` command that would load all this stuff up in the right places so you don't have to worry about that crap.
* Right now, I suppress all output, but I'd like to generate some useful feedback. Just a ton of things.

## Contributions are welcome!
* Just send me a Pull Request.
