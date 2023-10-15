#!/bin/bash

#######################################################################
## NOTE: This script originates from here but I tweaked the pull     ##
## command, changed default location for backup, and added a comment ##
## for reference later.                                              ##
#######################################################################

#####################################################################
### Please set the paths accordingly. In case you don't have all  ###
### the listed folders, just keep that line commented out.        ###
#####################################################################
### Path to your config folder you want to backup
config_folder=~/printer_data/config

# NOTE: The above should work for just about everyone, but a somewhat
# recent update to moonraker changed paths, etc. You can run the 
# provided moonraker script 'data-path-fix.sh' to fix/update
# older installs

### Path to your Klipper folder, by default that is '~/klipper'
klipper_folder=~/klipper

### Path to your Moonraker folder, by default that is '~/moonraker'
moonraker_folder=~/moonraker

### Path to your Mainsail folder, by default that is '~/mainsail'
#mainsail_folder=~/mainsail

### Path to your Fluidd folder, by default that is '~/fluidd'
fluidd_folder=~/fluidd

### The branch of the repository that you want to save your config
### By default that is 'main'
branch=main

#####################################################################
#####################################################################


#####################################################################
################ !!! DO NOT EDIT BELOW THIS LINE !!! ################
#####################################################################
grab_version(){
  if [ ! -z "$klipper_folder" ]; then
    cd "$klipper_folder"
    klipper_commit=$(git rev-parse --short=7 HEAD)
    klipper_commit_date=$(git log -n 1 --pretty=format:%cs)
#    m1="Klipper on commit: $klipper_commit"
    m1="Klipper: $klipper_commit_date ($klipper_commit)"
    cd ..
  fi
  if [ ! -z "$moonraker_folder" ]; then
    cd "$moonraker_folder"
    moonraker_commit=$(git rev-parse --short=7 HEAD)
    moonraker_commit_date=$(git log -n 1 --pretty=format:%cs)
#    m2="Moonraker on commit: $moonraker_commit"
    m2="Moonraker: $moonraker_commit_date ($moonraker_commit)"
    cd ..
  fi
  if [ ! -z "$mainsail_folder" ]; then
    mainsail_ver=$(head -n 1 $mainsail_folder/.version)
    m4="Mainsail version: $mainsail_ver"
  fi
  if [ ! -z "$fluidd_folder" ]; then
    fluidd_ver=$(head -n 1 $fluidd_folder/.version)
    fluidd_ver_date=$(date '+%F' -d "@$( stat -c '%Y' "$fluidd_folder/.version"; )")
    m3="Fluidd: $fluidd_ver_date ($fluidd_ver)"
  fi
}

# To fully automate this and not have to deal with auth issues, generate a legacy token on Github
# then update the command below to use the token. Run the command in your base directory and it will
# handle auth. This should just be executed in your shell and not committed to any files or
# Github will revoke the token. =)
# git remote set-url origin https://XXXXXXXXXXX@github.com/EricZimmerman/Voron24Configs.git/
# Note that that format is for changing things after the repository is in use, vs initially

push_config(){
  cd $config_folder
  git pull origin $branch --no-rebase
  git add .
  current_date=$(date +"%Y-%m-%d %T")
  git commit -m "Autocommit on $current_date" -m "$m1" -m "$m2" -m "$m3" -m "$m4"
  git push origin $branch
}
grab_version
push_config
