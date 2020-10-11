#!/bin/bash
set -x #echo on

sh '01 install_softwares.sh'
sh '02 install_packages.sh'

cp my_bash_profile.sh ~/my_bash_profile.sh
LINE="source ~/my_bash_profile.sh"
FILE=~/.zshrc
grep -q "$LINE" "$FILE" || echo "$LINE" >> "$FILE"