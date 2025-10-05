function get_diff {
	# Prompt
	# this file has diff from master, suggest a commit message

	mkdir -p dev
	git diff origin/master >dev/diff.txt
	git ls-files --others --exclude-standard | while read -r file; do
		echo untracked file "$file"
		echo -e "\n--- $file ---" >>dev/diff.txt
		cat "$file" >>dev/diff.txt
	done
}
