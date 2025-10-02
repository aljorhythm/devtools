# link zshrc to my_bash_profile.sh
SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
FILE=$SCRIPT_PATH/.zshrc.out

LINE="if [[ -f \"$SCRIPT_PATH/.this_profile.sh\" ]]; then source \"$SCRIPT_PATH/.this_profile.sh\"; fi"
grep -q "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

LINE="if [[ -f \"$SCRIPT_PATH/my_bash_profile.sh\" ]]; then source \"$SCRIPT_PATH/my_bash_profile.sh\"; fi"

echo $LINE
echo appending to zshrc $FILE
grep -q "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

cat "$FILE"
echo "------"
