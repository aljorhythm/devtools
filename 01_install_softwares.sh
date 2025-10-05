#!/bin/bash
# SIGN IN MANUALLY on App Store if you are on a mac before executing

set -x #echo on

#xcode
xcode-select --install

# ohmyzsh
# https://github.com/ohmyzsh/ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/joel.lim/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

sh 'backup_install.sh'

## LAST
# SIGN IN MANUALLY on App Store if you are on a mac before executing

# mac
sh '01-01_install_mac_softwares.sh'
