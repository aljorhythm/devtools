# link zshrc to my_bash_profile.sh
cp my_bash_profile.sh ~/my_bash_profile.sh
LINE="source ~/my_bash_profile.sh"
FILE=~/.zshrc
grep -q "$LINE" "$FILE" || echo "$LINE" >> "$FILE"