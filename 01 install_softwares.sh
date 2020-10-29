#!/bin/bash
# SIGN IN MANUALLY on App Store if you are on a mac before executing

set -x #echo on

#xcode
xcode-select --install

# brew
# https://brew.sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# python3
# https://docs.python-guide.org/starting/install3/osx/
brew install python

# yarn
brew install yarn

# postgresql
brew install postgresql

# python pyenv
brew install pyenv

# node
brew install node

# ffmpeg
brew install ffmpeg

# mas
# https://github.com/mas-cli/mas
brew install mas

# maven
brew install maven

#zsh
# https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH
brew install zsh

# ohmyzsh
# https://github.com/ohmyzsh/ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# node nvm
brew install nvm

# tree
brew install tree

# RVM experience was hell
brew install rbenv
rbenv init

# heroku
brew tap heroku/brew && brew install heroku

## LAST
# SIGN IN MANUALLY on App Store if you are on a mac before executing

# mac 
sh '01-01 install_mac_softwares.sh'
