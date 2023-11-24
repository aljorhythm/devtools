# link zshrc to my_bash_profile.sh
SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
LINE="source $SCRIPT_PATH/my_bash_profile.sh"
FILE=$SCRIPT_PATH/.zshrc.out
echo $LINE
echo appending to zshrc $FILE
grep -q "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

LINE="source $SCRIPT_PATH/.this_profile.sh"
grep -q "$LINE" "$FILE" || echo "$LINE" >> "$FILE"
