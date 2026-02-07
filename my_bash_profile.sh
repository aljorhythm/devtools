#─────────────────────────────────
# General
#─────────────────────────────────
echo "[my_bash_profile.sh] running"
alias o='open .'
alias e=exit
alias dls='cd ~/Downloads'
alias t="open -a /System/Applications/Utilities/Terminal.app ."
alias it="open -a /Applications/iTerm.app ."
alias mk="make"
alias mks="make setup"
alias mut="make unit_test"
alias mr="make run"
alias mdev="make dev"
alias mf="make format"
alias ls1="ls"
alias cdg='cd ~/git'
alias cdh='cd ~'
alias h="cd ~"
alias workspace="cd ~/git"
alias ws='cd ~/git'
alias icloud='cd ~/iCloud'
alias downloads="cd ~/Downloads"
alias path=cppath
alias temperature='sudo powermetrics --samplers smc |grep -i "CPU die temperature"'
alias pingg='ping www.google.com'
function mkdiri() {
	echo Enter directory:
	read dir
	mkdir -p "$dir"
}
function archive_downloads() {
	local date_folder=$(date +%Y%m%d)
	local archive_path=~/Documents/downloads/$date_folder
	mkdir -p "$archive_path"
	mv ~/Downloads/* "$archive_path"
	ls "$archive_path"
}
function cppath() {
	echo copying "$(pwd)"
	pwd | pbcopy
}
function search() { grep -nrw . -e "$1" --exclude='.*'; }

#─────────────────────────────────
# Docker
#─────────────────────────────────
alias docker-rmi='docker rmi -f $(docker images -a -q)'
alias docker-stop='docker stop $(docker ps -aq)'
alias cont-reset='docker-stop && docker-rmc'
alias docker-rmc='docker container rm --force $(docker container ls -aq)'
alias docker-rmv='docker volume rm -f $(docker volume ls -q)'
alias dcu="docker compose up"
alias dcd="docker compose down"
alias container='docker container'
alias cont='docker container'
alias images='docker images'
alias imgs='docker images'
alias dozzle-pull="docker pull amir20/dozzle:latest"
alias dozzle-up="docker run --name dozzle -d --volume=/var/run/docker.sock:/var/run/docker.sock -p 8888:8080 amir20/dozzle:latest"
alias odocker="open -a Docker"
function docker-clean() {
	docker-stop
	docker-rmc
	docker-rmi
	docker-rmv
	docker system prune -f
	docker volume prune -f
	echo "\nRemaining images:"
	docker images
	echo "\nRemaining containers:"
	docker container ls
	echo "\nRemaining volumes:"
	docker volume ls
}

#─────────────────────────────────
# Git
#─────────────────────────────────
export PATH="$PATH:~/git/flutter/bin"
alias se='source .envrc'
alias cnvs='git commit --no-verify -S'
alias acnv='git add . && git commit --no-verify'
alias ggraph='git log --all --decorate --oneline --graph -6'
alias flyhome='cd "$(git rev-parse --show-toplevel)"'
alias fhome='cd "$(git rev-parse --show-toplevel)"'
alias vshome='vs "$(git rev-parse --show-toplevel)"'
alias checkout="git checkout"
alias cherry-pick="git cherry-pick"
alias reflog="git reflog | head -n 15"
alias gmf="git merge --ff-only"
alias co="git checkout"
alias clone='git clone'
alias cob="git checkout -b"
alias fetch="git fetch"
alias commit="git commit -m "
alias stash="git stash"
alias pop="git stash pop"
alias merge="git merge"
alias cam="git commit --amend"
alias m="git merge"
alias ms="git merge --reset"
alias gpo="git pull origin"
alias gpod="git pull origin develop"
alias gsubco="git submodule update --init --recursive"
alias lcm="git log -1 --pretty=%B | pbcopy"
alias rcm="git log -1 --pretty=%B @{u} | pbcopy"
alias flcm="git log -1 --pretty=%B | head -n1 | awk '{print $1;}'"
alias h="cd ~"
alias f='git fetch'
alias bd='git branch -D'
alias add="git add"
alias sts="git status -sb"
alias status="git status"
alias s="git status -sb"
alias gms="git merge --reset"
alias push="git push"
alias P="u"
alias p="git pull"
alias pu="git pull"
alias gpl="git pull"
alias pull="git pull"
alias dl="git pull"
alias prb="git pull --rebase"
alias grc="git rebase --continue"
alias cnv='git commit --no-verify'
alias pnv='git push --no-verify'
alias branch='git branch'
alias gpnv='git push --no-verify'
alias cph="cphash"
alias cpb="cpbranch"
alias fh="fetchhash"
alias b='cbranch'
alias cmgp="cm && P"
alias cgp="cm && P"
alias cfP="cf && P"
alias c="git commit"
alias cP="s && a && cm && P"
alias acfp="a && cfP"
alias acfep="a && git commit -m 'edit' --no-verify && P"
function acp {
	echo "➕ adding all changes"
	git add . || return 1
	echo "✏️ committing changes"
	git commit || return 1
	echo "🚀 pushing changes"
	git push || return 1
}
function sync-remote() {
	local current_branch=$(git branch --show-current)
	if [ -z "$current_branch" ]; then
		echo "Error: Could not determine the current branch."
		return 1
	fi
	local current_sha=$(git rev-parse HEAD)
	if [ -z "$current_sha" ]; then
		echo "Error: Could not determine the current commit SHA."
		return 1
	fi
	git checkout $current_sha
	git branch -D "$current_branch"
	git fetch origin
	git checkout "$current_branch"
}
function git-discard {
	local timestamp=$(date +%Y%m%d_%H%M%S)
	local patch_file="/tmp/git-discard-${timestamp}.patch"
	git reset
	echo "💾 Saving patch to: $patch_file"
	git diff >"$patch_file"
	git checkout .
	git clean -fd
	echo "✅ Changes discarded. Patch saved to: $patch_file"
	echo "📝 Writing directory to $patch_file.meta"
	pwd >"$patch_file.meta"
}
function trunk {
	local main_branch=$(git_main_branch)
	if [ -n "$main_branch" ]; then
		echo "Checking out $main_branch..."
		git checkout "$main_branch"
	else
		echo "Could not determine main branch"
		return 1
	fi
}
function open-remote { if [[ -f "dev/.remote" ]]; then open $(cat dev/.remote); else git remote -v | awk '/origin.*\(push\)/ {print $2}' | xargs open; fi; }
function amd { git commit --amend --no-verify; }
function amdne { git commit --amend --no-verify --no-edit; }
function aamdne { git add . && git commit --amend --no-verify --no-edit; }
function amdp {
	git add .
	git commit --amend --no-verify --no-edit
	gpfnv
}
function addFromHome() { (cd "$(git rev-parse --show-toplevel)" && git add .); }
function upstream() { git push --set-upstream $1 $(git_current_branch); }
function u() {
	REMOTE=$(git remote | head -n 1 | awk '{print $1}')
	git push --set-upstream $REMOTE $(git_current_branch) --no-verify
}
function uf() {
	REMOTE=$(git remote | head -n 1 | awk '{print $1}')
	git push --set-upstream $REMOTE $(git_current_branch) --no-verify --force
}
function stashgprom {
	stash
	gprom
	stash pop
}
function sync-master {
	stash
	gprom
	stash pop
}
function cm() { git commit; }
function cf() { git commit --no-verify; }
function a() {
	git status -sb
	echo
	echo "---------------"
	echo
	git add . && git status -sb
}
function cphash() {
	echo copying $(git rev-parse --short HEAD)
	git rev-parse --short HEAD | pbcopy
}
function fetchhash() {
	git fetch
	echo copying
	git rev-parse --short $1 | tee /dev/tty | pbcopy
}
function cpbranch() {
	echo copying $(git branch --show-current)
	git branch --show-current | tee /dev/tty | pbcopy
}
function cphb() {
	cphash
	cpbranch
}
function checkremotes() {
	echo "checking git remotes"
	git fetch
	remote_origin_count=$(git remote | grep ^origin$ -c)
	branch_name=$(git branch | grep '*' | sed 's/* //' | tr '[:upper:]' '[:lower:]')
	if [ $remote_origin_count -eq "1" ]; then
		git rev-list --left-right --count origin/$branch_name...HEAD | awk '{print "You are behind tracked remote branch by "$1" commit(s), ahead by "$2" commit(s)"}'
		git rev-list --left-right --count origin/develop...HEAD | awk '{print "You are behind develop by "$1" commit(s), ahead by "$2" commit(s)"}'
		git rev-list --left-right --count origin/master...HEAD | awk '{print "You are behind master by "$1" commit(s), ahead by "$2" commit(s)"}'
		git rev-list --left-right --count origin/develop...origin/staging | awk '{print "origin/staging is behind origin/develop by "$1" commit(s), ahead by "$2" commit(s)"}'
		git rev-list --left-right --count origin/master...origin/develop | awk '{print "origin/develop is behind origin/master by "$1" commit(s), ahead by "$2" commit(s)"}'
		git rev-list --left-right --count origin/master...origin/staging | awk '{print "origin/staging is behind origin/master by "$1" commit(s), ahead by "$2" commit(s)"}'
	else echo "warning: remote origin does not exist"; fi
}
function cbranch() { git switch "$(git branch --format="%(refname:short)" | fzf)"; }
function gpfnv {
	branch=$(git rev-parse --abbrev-ref HEAD)
	main_branch=$(git_main_branch)
	if [ "$branch" = "main" ] || [ "$branch" = "master" ] || [ "$branch" = "$main_branch" ]; then
		echo "❌ Error: You are on the default branch (current: $branch)."
		return 1
	fi
	git push --force --no-verify
}
function git-sync {
	echo git checkout HEAD^
	git checkout HEAD^
	echo git branch -D $1
	git branch -D $1
	echo git fetch
	git fetch
	echo git checkout $1
	git checkout $1
}
function dbranch-merged() {
	local main_branch=$(git_main_branch)
	git fetch --prune
	local merged_remote_branches=($(git branch -r --merged origin/$main_branch | grep -v "origin/$main_branch" | grep -v "origin/master" | grep -v "origin/develop" | grep -v "origin/HEAD" | sed 's|origin/||' | tr -d ' '))
	local merged_local_branches=($(git branch --merged $main_branch | grep -v "^\*" | grep -v "$main_branch" | grep -v "master" | grep -v "develop" | tr -d ' '))
	local all_branches=()
	for branch in "${merged_remote_branches[@]}"; do all_branches+=("remote: $branch"); done
	for branch in "${merged_local_branches[@]}"; do all_branches+=("local: $branch"); done
	if [ ${#all_branches[@]} -eq 0 ]; then
		echo "No merged branches found"
		return 0
	fi
	echo "Merged branches (local and remote):"
	local choice=$(printf '%s\n' "${all_branches[@]}" | fzf --prompt="Select branch to delete: ")
	if [ -n "$choice" ]; then
		local branch_type=$(echo "$choice" | cut -d: -f1)
		local branch_name=$(echo "$choice" | cut -d: -f2 | tr -d ' ')
		if [ "$branch_type" = "remote" ]; then
			echo "Deleting remote branch: $branch_name"
			git push origin --delete "$branch_name" --no-verify
		elif [ "$branch_type" = "local" ]; then
			echo "Deleting local branch: $branch_name"
			git branch -D "$branch_name"
		fi
	else echo "No branch selected"; fi
}

function update-gitrepos() {
	echo "Scanning for git repositories..."
	find "$HOME" -mindepth 1 -maxdepth 1 -type d -exec sh -c 'test -d "$1/.git" && echo "$1"' sh {} \; >~/.gitrepos
	echo "Updated ~/.gitrepos with $(wc -l <~/.gitrepos) repositories"
}

function repo() {
	local dir
	dir=$(cat ~/.gitrepos 2>/dev/null | fzf --prompt="Select git repository: ")
	if [ -n "$dir" ]; then
		(cd "$dir" && git-open)
	else
		echo "No directory selected."
	fi
}

function ovs() {
	local dir
	dir=$(cat ~/.gitrepos 2>/dev/null | fzf --prompt="Select git repository: ")
	if [ -n "$dir" ]; then
		open -a /Applications/Visual\ Studio\ Code.app "$dir"
	else
		echo "No directory selected."
	fi
}

function sync-remote() {
	local current_branch=$(git branch --show-current)

	if [ -z "$current_branch" ]; then
		echo "Error: Could not determine the current branch."
		return 1
	fi

	# git stash

	local current_sha=$(git rev-parse HEAD)
	if [ -z "$current_sha" ]; then
		echo "Error: Could not determine the current commit SHA."
		return 1
	fi
	git checkout $current_sha

	git branch -D "$current_branch"

	git fetch origin

	git checkout "$current_branch"
	# git stash pop
}

alias firstlinkinreadme="grep -oE 'http[s]?://\S+' README.md | head -1 | xargs open"
alias openlink="firstlinkinreadme"
alias firstlinkindev="grep -oE 'http[s]?://\S+' dev/link | head -1 | xargs open"
alias fuck='thefuck'
alias fk='thefuck'
alias lg='lazygit'
alias ls-files='find $(pwd) -type f'
alias workspace="cd ~/git"
alias ws='cd ~/git'
alias icloud='cd ~/iCloud'
alias downloads="cd ~/Downloads"
alias cpssh='cat ~/.ssh/id_rsa.pub | pbcopy'
alias st='open -a /Applications/Sourcetree.app "$(git rev-parse --show-toplevel)"'
alias vs='open -a /Applications/Visual\ Studio\ Code.app/'
alias cursor='open -a /Applications/Cursor.app/'
alias rbmine='open /Applications/RubyMine.app/'
alias gop='git-open'
alias bd='git branch -D'

function git-discard {
	local timestamp=$(date +%Y%m%d_%H%M%S)
	local patch_file="/tmp/git-discard-${timestamp}.patch"

	git reset
	echo "💾 Saving patch to: $patch_file"
	git diff >"$patch_file"
	git checkout .
	git clean -fd
	echo "✅ Changes discarded. Patch saved to: $patch_file"
	echo "📝 Writing directory to $patch_file.meta"
	pwd >"$patch_file.meta"
}

function trunk {
	local main_branch=$(git_main_branch)
	if [ -n "$main_branch" ]; then
		echo "Checking out $main_branch..."
		git checkout "$main_branch"
	else
		echo "Could not determine main branch"
		return 1
	fi
}

function open-remote {
	if [[ -f "dev/.remote" ]]; then
		open $(cat dev/.remote)
	else
		git remote -v | awk '/origin.*\(push\)/ {print $2}' | xargs open
	fi
}

function amd {
	# git commit -S --amend --no-verify
	git commit --amend --no-verify
}

function amdne {
	# git commit -S --amend --no-verify --no-edit
	git commit --amend --no-verify --no-edit
}

function aamdne {
	# git add . && git commit -S --amend --no-verify --no-edit
	git add . && git commit --amend --no-verify --no-edit
}

function amdp {
	git add .
	# git commit -S --amend --no-verify --no-edit
	git commit --amend --no-verify --no-edit
	gpfnv
}

function nvmuse {
	export NVM_DIR=~/.nvm
	source $(brew --prefix nvm)/nvm.sh
	nvm use
}

function nvmuseifnot {
	if [[ ! -f ".nvmrc" ]]; then
		return
	fi
	required_version=$(cat .nvmrc)

	# Get the currently active Node version
	current_version=$(node -v)

	# Compare the current version with the required version
	if [[ "$current_version" != "$required_version"* ]]; then
		export NVM_DIR=~/.nvm
		source $(brew --prefix nvm)/nvm.sh
		nvm use
	fi
}

#─────────────────────────────────
# Node / NVM / JS
#─────────────────────────────────
alias nr='npm run'
function nvmuse {
	export NVM_DIR=~/.nvm
	source $(brew --prefix nvm)/nvm.sh
	nvm use
}
function nvmuseifnot {
	if [[ ! -f ".nvmrc" ]]; then return; fi
	required_version=$(cat .nvmrc)
	current_version=$(node -v)
	if [[ "$current_version" != "$required_version"* ]]; then
		export NVM_DIR=~/.nvm
		source $(brew --prefix nvm)/nvm.sh
		nvm use
	fi
}
function fnm-setup {
	eval "$(fnm env --use-on-cd --shell zsh)"
	fnm use
}
function v() {
	set -x
	node -v
	npm -v
	mvn -v
}

#─────────────────────────────────
# Applications
#─────────────────────────────────
alias vscode="open -a /Applications/Visual\ Studio\ Code.app/"
alias goland="open -a Goland"
alias odocker="open -a Docker"
alias sourcetree="open -a /Applications/Sourcetree.app/"
alias st='open -a /Applications/Sourcetree.app "$(git rev-parse --show-toplevel)"'
alias vs='open -a /Applications/Visual\ Studio\ Code.app/'
alias cursor='open -a /Applications/Cursor.app/'
alias rbmine='open /Applications/RubyMine.app/'

#─────────────────────────────────
# Python
#─────────────────────────────────
function monpy() { nodemon -L --watch "$1" --exec "python $1"; }
function monpy3() { nodemon -L --watch "$1" --exec "python3 $1"; }

#─────────────────────────────────
# Ruby
#─────────────────────────────────
function monrb() { nodemon -L --watch "$1" --exec "ruby $1"; }
function formatrb() {
	FILES="$(git diff --cached --name-only --diff-filter=AMC | grep "\.rb$" | tr '\n' ' ')"
	bin/bundle exec rubocop -a ${FILES}
}

#─────────────────────────────────
# Golang
#─────────────────────────────────
function nmongo() { nodemon -L --ext ".go" --exec "go run main.go"; }
alias go-clean="go clean -i -testcache -modcache -x -r -cache"

#─────────────────────────────────
# SSH
#─────────────────────────────────
alias cpssh='cat ~/.ssh/id_rsa.pub | pbcopy'
function do-ssh-agent {
	ssh-add --apple-load-keychain
	ssh-add --apple-use-keychain /Users/joel.lim/.ssh/post_nx
}

#─────────────────────────────────
# Prompt / UI
#─────────────────────────────────
function my_prompt() {
	local current_branch=''
	if [ -d .git ]; then
		echo "%{$reset_color%}$(git log --color=always --pretty=format:"%C(yellow)%h%Creset %ad | %Cgreen%s%Creset %Cred%d%Creset %Cblue[%an]" --date=short -n 4 2>/dev/null)\n\n%{$fg_bold[cyan]%}$(git --no-pager status -sb 2>/dev/null)\n"
		current_branch="$(my_current_branch)"
		remote_tracking=$(git rev-parse --abbrev-ref --symbolic-full-name ${current_branch}@{u})
		if [ -n "$remote_tracking" ]; then echo "$(git rev-list --left-right --count origin/${current_branch}...HEAD | awk -v branch="$current_branch" '{print "You are behind origin/" branch " by " $1 " commit(s), ahead by " $2 " commit(s)"}')"; fi
		main_branch=$(git_main_branch)
		echo "$(git rev-list --left-right --count origin/${main_branch}...HEAD | awk -v branch="$main_branch" '{print "You are behind origin/" branch " by " $1 " commit(s), ahead by " $2 " commit(s)"}')"
	fi
	echo "%{$fg_bold[red]%}$(ssh_connection)%{$fg_bold[green]%}%n@%m%{$reset_color%}\n[${ret_status}] %{$fg[green]%} %~ %{$reset_color%} @ %{$fg[green]%} $current_branch %{$reset_color%}\n%{$fg_bold[black]%}ENTER CMD > %{$reset_color%} "
}
function prompt_main_branch() { if [ -d .git ]; then
	main_branch=$(git_main_branch)
	behind_count=$(git rev-list --left-right --count origin/${main_branch}...HEAD | awk -v branch="$main_branch" '{print $1}')
	if [ "$behind_count" -gt 0 ]; then echo "%F{red}You are behind origin/$main_branch by $behind_count commit(s)\n - "; fi
	current_branch="$(my_current_branch)"
	remote_tracking=$(git rev-parse --abbrev-ref --symbolic-full-name ${current_branch}@{u})
	if [ -n "$remote_tracking" ]; then
		behind_count=$(git rev-list --left-right --count ${remote_tracking}...HEAD | awk -v branch="$remote_tracking" '{print $1}')
		if [ "$behind_count" -gt 0 ]; then echo "%F{red}You are behind ${remote_tracking} by $behind_count commit(s)\n - "; fi
		echo "\n"
	fi
	if [[ -f ".track-branches" ]]; then while IFS= read -r line || [ -n "$line" ]; do
		remote_branch="$line"
		echo "$(git rev-list --left-right --count origin/${remote_branch}...HEAD | awk -v branch="$remote_branch" '{print "You are behind origin/" branch " by " $1 " commit(s), ahead by " $2 " commit(s)"}')"
		echo "\n"
	done <".track-branches"; fi
fi; }
function envString() { if [ -n "$ENV" ]; then echo " ENV: $ENV"; fi; }
function get_last_commit_msg() { if git rev-parse --is-inside-work-tree &>/dev/null; then git log -1 --pretty=%s 2>/dev/null; fi; }
function git_ahead_behind_summary() { if [ -d .git ]; then
	local branch track track_counts track_behind track_ahead track_str
	local target target_counts target_behind target_ahead target_str
	branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
	track=$(git rev-parse --abbrev-ref --symbolic-full-name ${branch}@{u} 2>/dev/null)
	# Determine target branch: use target_branch function if it exists, otherwise git default branch
	if command -v target_branch &>/dev/null; then
		target=$(target_branch)
	else
		target=$(git_main_branch)
	fi
	track_behind=0
	track_ahead=0
	target_behind=0
	target_ahead=0
	if [ -n "$track" ]; then
		track_counts=$(git rev-list --left-right --count ${track}...HEAD 2>/dev/null)
		track_behind=$(echo $track_counts | awk '{print $1}')
		track_ahead=$(echo $track_counts | awk '{print $2}')
	fi
	if [ -n "$target" ] && git show-ref --verify --quiet refs/remotes/origin/$target; then
		target_counts=$(git rev-list --left-right --count origin/$target...HEAD 2>/dev/null)
		target_behind=$(echo $target_counts | awk '{print $1}')
		target_ahead=$(echo $target_counts | awk '{print $2}')
	fi
	track_str="%F{yellow}track:%f %F{red}-$track_behind%f %F{green}+${track_ahead}%f"
	target_str="%F{yellow}$target:%f %F{red}-$target_behind%f %F{green}+${target_ahead}%f"
	echo " | $track_str | $target_str | "
fi; }
PROMPT_FULL=$'%{$fg_bold[white]%}%{$bg[red]%} END %{$reset_color%}\n$(my_prompt)'
PROMPT_SHORT=$'%F{green}%*%f %F{blue}%~%f %F{red}${vcs_info_msg_0_}%f%F{green}$(my_current_branch) $(git_prompt_short_sha) %F{red}$(get_last_commit_msg)%f$(git_ahead_behind_summary)%F{blue}$(envString)%f %F{yellow}%?%f $ '
PROMPT=$PROMPT_SHORT

#─────────────────────────────────
# Shortcuts / Miscellaneous
#─────────────────────────────────
alias firstlinkinreadme="grep -oE 'http[s]?://\S+' README.md | head -1 | xargs open"
alias openlink="firstlinkinreadme"
alias firstlinkindev="grep -oE 'http[s]?://\S+' dev/link | head -1 | xargs open"
alias fuck='thefuck'
alias fk='thefuck'
alias lg='lazygit'
alias gop='git-open'
alias ls-files='find $(pwd) -type f'
alias wci='gh run watch -i1 --exit-status'
alias vci='gh run view --web'
alias omr='glab mr view --web'
alias thanks='echo Thanks for reaching out I am unavailable at this moment. Keep in touch | pbcopy'
alias me-linkedin='echo https://www.linkedin.com/in/joel-lim-jing/ | pbcopy'
alias open-linkedin='open https://www.linkedin.com/in/joel-lim-jing'
alias me-github='open https://github.com/aljorhythm'
alias me-medium='echo https://medium.com/aljorhythm/latest | pbcopy'
function lci() { gh run view $(gh run list --limit 1 --json databaseId --jq '.[0].databaseId') --log; }
function gitignore-init() {
	FILE=.gitignore
	IGNORES=("*.idea" "*.tmp" "*.temp" "*.out" ".vscode")
	echo $IGNORES
	for LINE in ${IGNORES[@]}; do grep -q "$LINE" "$FILE" || echo "$LINE" >>"$FILE"; done
}
function setup-sign-commit() { export GPG_TTY=$(tty); }
setup-sign-commit
function temp {
	touch /tmp/tempfile.txt
	vs /tmp/tempfile.txt
}
function tempjson {
	touch /tmp/tempfile.json
	vs /tmp/tempfile.json
}


function envrciffound() { if [[ -f ".envrc" ]]; then
	echo sourcing .envrc
	source .envrc
else echo no .envrc found; fi; }
function run_start_hook() { [[ -f ".on-cd.sh" ]] && source .on-cd.sh; }
run_start_hook
chpwd_functions+=("run_start_hook")
if command -v mcfly &>/dev/null; then eval "$(mcfly init zsh)"; fi

#─────────────────────────────────
# End of File
#─────────────────────────────────
