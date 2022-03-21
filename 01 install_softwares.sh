#!/bin/bash
# SIGN IN MANUALLY on App Store if you are on a mac before executing

set -x #echo on

#xcode
xcode-select --install

# ohmyzsh
# https://github.com/ohmyzsh/ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# rust
brew install lazygit

## LAST
# SIGN IN MANUALLY on App Store if you are on a mac before executing

# mac 
sh '01-01 install_mac_softwares.sh'
