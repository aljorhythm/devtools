#!/bin/bash

# This script tries to fetch all remotes of all git repositories in a continuous loop
# It iterates over all folders in $HOME.
# If there's a .git folder, it tries to fetch the remote and stores the timestamp in a file (eg. /Users/joellim/devtools/fetch-all/timestamps/aljorhythm-ideas)
# A log is kept in this folder fetch-all.log
# if it hasn't been 10 minutes since the last fetch, it skips the fetch.
# If fetch failed, the timestamp file is deleted / not created.
# To run: sh fetch-all.sh
# Press Ctrl+C to stop the loop

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TIMESTAMPS_DIR="$SCRIPT_DIR/timestamps"
LOG_FILE="$SCRIPT_DIR/fetch-all.log"
FETCH_INTERVAL=600 # 10 minutes in seconds

# Create timestamps directory if it doesn't exist
mkdir -p "$TIMESTAMPS_DIR"

# Function to log messages
log_message() {
	echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Function to transform full path to safe filename
get_repo_id() {
	local repo_dir="$1"
	# Convert /Users/joellim/my-repo to Users_joellim_my-repo
	echo "$repo_dir" | sed 's/[\/]/_/g' | sed 's/^_//'
}

# Function to check if enough time has passed since last fetch
should_fetch() {
	local repo_id="$1"
	local timestamp_file="$TIMESTAMPS_DIR/$repo_id"

	if [[ ! -f "$timestamp_file" ]]; then
		return 0 # No timestamp file, should fetch
	fi

	local last_fetch=$(cat "$timestamp_file" 2>/dev/null)
	local current_time=$(date +%s)
	local time_diff=$((current_time - last_fetch))

	if [[ $time_diff -ge $FETCH_INTERVAL ]]; then
		return 0 # Enough time has passed, should fetch
	else
		return 1 # Not enough time has passed, skip fetch
	fi
}

# Function to update timestamp
update_timestamp() {
	local repo_id="$1"
	local timestamp_file="$TIMESTAMPS_DIR/$repo_id"
	date +%s >"$timestamp_file"
}

# Function to remove timestamp file
remove_timestamp() {
	local repo_id="$1"
	local timestamp_file="$TIMESTAMPS_DIR/$repo_id"
	rm -f "$timestamp_file"
}

# Main fetch function
run_fetch_all() {
	log_message "Starting fetch-all script"

	# Counter for statistics
	local total_repos=0
	local fetched_repos=0
	local skipped_repos=0
	local failed_repos=0

	# Iterate through all directories in $HOME
	for dir in "$HOME"/*; do
		if [[ -d "$dir" && -d "$dir/.git" ]]; then
			repo_id=$(get_repo_id "$dir")
			total_repos=$((total_repos + 1))

			# Check if we should fetch this repo
			if should_fetch "$repo_id"; then
				log_message "Fetching repository: $dir"

				# Change to the repository directory and fetch
				cd "$dir" || {
					log_message "ERROR: Could not change to directory $dir"
					failed_repos=$((failed_repos + 1))
					continue
				}

				# Attempt to fetch all remotes
				if git fetch --all &>/dev/null; then
					log_message "SUCCESS: Fetched $dir"
					update_timestamp "$repo_id"
					fetched_repos=$((fetched_repos + 1))
				else
					log_message "ERROR: Failed to fetch $dir"
					remove_timestamp "$repo_id"
					failed_repos=$((failed_repos + 1))
				fi
			else
				log_message "SKIPPED: $dir (last fetch was less than 10 minutes ago)"
				skipped_repos=$((skipped_repos + 1))
			fi
		fi
	done

	log_message "Fetch-all script completed"
	log_message "Statistics: Total repos: $total_repos, Fetched: $fetched_repos, Skipped: $skipped_repos, Failed: $failed_repos"

	# Return to original directory
	cd "$SCRIPT_DIR"
}

# Main execution - continuous loop
log_message "LOOP: Starting fetch-all loop with 5-second intervals"
log_message "LOOP: Press Ctrl+C to stop the loop"

while true; do
	run_fetch_all
	log_message "LOOP: Waiting 5 seconds before next run..."
	sleep 5
done
