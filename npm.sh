TEST_FILES=$(
	git diff --name-only origin/master
	git ls-files --others --exclude-standard
)
TEST_FILES=$(echo $TEST_FILES | grep 'spec')

# jest
function tdiff {
	TEST_FILES=$(git diff --name-only origin/master)

	if [[ -z "$TEST_FILES" ]]; then
		echo "No files changed against master"
	else
		TEST_PATH_ARGS=""
		while IFS= read -r file; do
			TEST_PATH_ARGS+=(--testPathPattern="$file")
		done <<<"$TEST_FILES"

		echo $TEST_PATH_ARGS
		npm run jest -- ${TEST_PATH_ARGS[@]} --watch --coverage=false
	fi
}

TEST_FILES=$(git diff --name-only origin/master && git ls-files --others --exclude-standard | grep 'spec.ts')

# mocha
function tdiff {
	TEST_FILES=$(git diff --name-only origin/master | grep 'spec')

	if [[ -z "$TEST_FILES" ]]; then
		echo "No test files changed against master"
	else
		GREP_PATTERN=""
		echo "$TEST_FILES" | while IFS= read -r file; do
			DESCRIPTION=$(awk -F'"' '/describe\(/ {print $2; exit}' "$file")
			GREP_PATTERN="${GREP_PATTERN}|${DESCRIPTION}"

		done
		# Remove the last '|' character
		GREP_PATTERN=${GREP_PATTERN#|}

		echo "Running tests with pattern: $GREP_PATTERN"
		cat .envrc.local
		source .envrc.local
		CMD="npm run test:only -- --grep='"$GREP_PATTERN"' --config .mocharc.js --config .mocharc.js;"
		npx nodemon --exec "$CMD" --ext '.spec.ts'
	fi
}
