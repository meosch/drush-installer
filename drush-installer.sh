#!/bin/sh
# IMPORTANT. You must have curl, wget, php and git installed
PS4=':${LINENO} + '
#set -x
function check_dependencies(){
if ! type php > /dev/null; then
  echo "php is not installed. Aborting." >&2;
  exit 1;
fi

if ! type curl > /dev/null; then
  echo "curl is not installed. Aborting." >&2;
  exit 1;
fi

if ! type wget > /dev/null; then
  echo "wget is not installed. Aborting." >&2;
  exit 1;
fi

if ! type git > /dev/null; then
  echo "git is not installed. Abording." >&2;
  exit 1;
fi
}

function switch_shell(){
# Use Bash as command line (if you like you can use your own CL too!)
chsh -s "$(command -v bash)" "$USER"
}

function get_info(){
# Enter Drush version (branch from Github)
# Notice that you need Drush 7.x (branch master) to be able to work with Drupal 8.x
echo -n "Please enter the Drush version (eg 7.x - Defaults to dev-master): "
read drushbranch
if [ -z $drushbranch ]; then
  $drushbranch="dev-master"
fi

}

function install_composer(){
# Install Composer
if [ ! -d "~/bin" ]; then
mkdir ~/bin
fi
curl -sS https://getcomposer.org/installer | php -- --install-dir=bin
mv composer.phar ~/bin/composer
}


function add_composer_to_path(){
# Add export of path to .bashrc
# We do this in ~/.bashrc but source it from our ~/.bash_profile
# See http://www.joshstaiger.org/archives/2005/07/bash_profile_vs.html 
# for more info and code you can add to your ~/.bash_profile file.
echo "Adding line to ~/.bashrc to add the path to composer"
touch ~/.bash_profile
echo echo 'export PATH="$HOME/.composer/vendor/bin:$PATH"' > ~/.bashrc
# Source the changed .bash_profile or restart ssh session
source ~/.bash_profile
}

function install_drush(){
   composer global require drush/drush:${drushbranch}
}

function finished(){
echo "Drush installation finished! Run Drush to test it."
}

### MAIN PROGRAM
check_dependencies
switch_shell
get_info
install_composer
add_composer_to_path
install_drush
finished
