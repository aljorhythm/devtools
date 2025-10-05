#!/bin/bash

# Get files changed in the last commit
FILES=$(git diff --name-only HEAD^ HEAD | grep '\.\(js\|jsx\|ts\|tsx\)$')

# Check if any files are found
if [ -z "$FILES" ]; then
	echo "No JavaScript/TypeScript files to lint."
else
	# Run ESLint to fix issues
	echo "Linting files:"
	echo $FILES
	echo ""
	echo $FILES | xargs eslint --fix
fi
