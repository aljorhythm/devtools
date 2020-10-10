#!/bin/bash
set -x #echo on

sh software_install.sh
sh package_install.sh

cp my_bash_profile.sh ~/my_bash_profile.sh
LINE="source ~/my_bash_profile.sh"
FILE=~/.zshrc
grep -q "$LINE" "$FILE" || echo "$LINE" >> "$FILE"