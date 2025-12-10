# link zshrc to my_bash_profile.sh
SCRIPT_PATH="$(
	cd -- "$(dirname "$0")" >/dev/null 2>&1
	pwd -P
)"
FILE=$SCRIPT_PATH/.zshrc.out

LINE="if [[ -f \"$SCRIPT_PATH/.this_profile.sh\" ]]; then source \"$SCRIPT_PATH/.this_profile.sh\"; fi"
grep -q "$LINE" "$FILE" || echo "$LINE" >>"$FILE"

LINE="if [[ -f \"$SCRIPT_PATH/my_bash_profile.sh\" ]]; then source \"$SCRIPT_PATH/my_bash_profile.sh\"; fi"

echo $LINE
echo appending to zshrc $FILE
grep -q "$LINE" "$FILE" || echo "$LINE" >>"$FILE"

cat "$FILE"
echo "------"

# Only move espanso config if directory exists
if [ -d "$HOME/Library/Application Support/espanso/match" ]; then
	cp $SCRIPT_PATH/espanso/match/base.yml "$HOME/Library/Application Support/espanso/match/base.yml"
	cp $SCRIPT_PATH/espanso/default.yml "$HOME/Library/Application Support/espanso/default.yml"
	echo "✅ Moved espanso config to $HOME/Library/Application Support/espanso/match/base.yml"
	echo "✅ Moved espanso config to $HOME/Library/Application Support/espanso/default.yml"

	# Restart espanso if command exists
	if command -v espanso &> /dev/null; then
		echo "🔄 Restarting espanso..."
		espanso restart
	fi
else
	echo "⚠️ Espanso directory not found, skipping espanso config setup"
fi
