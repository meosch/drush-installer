#!/bin/bash
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
curl -sS https://getcomposer.org/installer | php
mv composer.phar ~/bin/composer
}


function add_composer_to_path(){
# Add export of path to .bashrc
# We do this in ~/.bashrc but source it from our ~/.bash_profile
# See http://www.joshstaiger.org/archives/2005/07/bash_profile_vs.html 
# for more info and code you can add to your ~/.bash_profile file.
echo "Adding line to ~/.bashrc to add the path to composer"
touch ~/.bashrc
echo echo 'export PATH="$HOME/.composer/vendor/bin:$PATH"' >> ~/.bashrc
# Source the changed .bash_profile or restart ssh session
source ~/.bashrc
}

function install_drush(){
  composer global require drush/drush:${drushbranch}
}

function install_drush_recipes(){
  drush -y dl drush_recipes
# Now get our cookbook
  mkdir ~/.drush/drecipes
  cd ~/.drush/drecipes
  git clone https://github.com/meosch/drushcookbook.git
  drush cc drush
# Now install drush extensions not available via composer
  drush -y cook drush_extensions
}

function install_drush_extensions_via_composer(){
  cd ~/.drush
  composer require davereid/drush-patchfile:dev-master
  composer require drupal/site_audit:dev-7.x-1
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
install_drush_recipes
install_drush_extensions_via_composer
finished
