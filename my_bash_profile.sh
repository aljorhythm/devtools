echo running my_bash_profile

alias e=exit
alias t="open -a /System/Applications/Utilities/Terminal.app ."

# docker
echo docker shortcuts
alias docker-rmi='docker rmi $(docker images -a -q)'
alias docker-stop='docker stop $(docker ps -aq)'
alias docker-rmc='docker container rm $(docker container ls -aq)'
alias docker-reset='docker system prune -f && docker-stop && docker-rmc && docker-rmi'
alias dcu="docker compose up"
alias dcd="docker compose down"

# general shortcuts

alias ls-files='find $(pwd) -type f'
alias workspace="cd ~/git"
alias ws='cd ~/git'
alias icloud='cd ~/iCloud'
alias downloads="cd ~/Downloads"
alias cpssh='cat ~/.ssh/id_rsa.pub | pbcopy'
alias st='open -a /Applications/Sourcetree.app "$(git rev-parse --show-toplevel)"'
alias vs='open -a /Applications/Visual\ Studio\ Code.app/'
alias rbmine='open /Applications/RubyMine.app/'
alias gop='git-open'
echo nvm
# nvm
# export NVM_DIR=$(brew --prefix nvm)
# source $NVM_DIR/nvm.sh
# export NVM_DIR=~/.nvm
# source $(brew --prefix nvm)/nvm.sh

# open applications
alias vscode="open -a /Applications/Visual\ Studio\ Code.app/"

# sourcetree
alias sourcetree="open -a /Applications/Sourcetree.app/"

# nodemon
monpy() {
    nodemon -L --watch "$1" --exec "python $1" 
}

monpy3() {
    nodemon -L --watch "$1" --exec "python3 $1" 
}

nmongo() {
    nodemon -L --ext ".go" --exec "go run main.go"
}

monrb() {
    nodemon -L --ext ".rb" --exec "ruby $1"
}

formatrb() {
    FILES="$(git diff --cached --name-only --diff-filter=AMC | grep "\.rb$" | tr '\n' ' ')"
    bin/bundle exec rubocop -a ${FILES}
}

# git
alias flyhome='cd "$(git rev-parse --show-toplevel)"'
alias checkout="git checkout"
alias co="git checkout"
alias fetch="git fetch"
alias commit="git commit -m "
alias stash="git stash"
alias pop="git stash pop"
alias merge="git merge"
alias m="git merge"
alias ms="git merge reset"
alias gpo="git pull origin"
alias gpod="git pull origin develop"

function upstream() {
    git push --set-upstream $1 $(git_current_branch)
}

# commit
function cm() {
    echo Commit message:
    read message
    git commit -m "${message}"
}

# commit push
alias cmgp="cm && p"
alias cgp="cm && p"

# commit force (no verify)
function cf() {
    echo Commit message:
    read message
    git commit -m "${message}" --no-verify
}

alias cfp="cf && p"

# push
alias push="git push"
alias p="git push"

# pull
alias pu="git pull"
alias gpl="git pull"
alias pull="git pull"
alias dl="git pull"

# add
alias add="git add"
alias sts="git status -sb"

function a() {
    git status -sb
    echo
    echo "---------------"
    echo
    git add . && git status -sb
}

# status
alias status="git status"
alias s="git status -sb"

# merge
alias gms="git merge --reset"

# golang
alias go-clean="go clean -i -testcache -modcache -x -r -cache"

# make
alias mut="make unit_test"
alias mr="make run"

cppath() {
    echo copying "$(pwd)"
    pwd | pbcopy
}

# copy hash copy branch
function cphash() {
    echo copying $(git rev-parse --short HEAD)
    git rev-parse --short HEAD | pbcopy
}

function cpbranch() {
    echo copying $(git branch --show-current)
    git branch --show-current | pbcopy
}

alias cph="cphash"
alias cpb="cpbranch"

function cphb() {
    cphash
    cpbranch
}

function checkremotes() {
    echo "checking git remotes"
    git fetch

    remote_origin_count=$(git remote | grep ^origin$ -c)
    branch_name=$(git branch | grep '*' | sed 's/* //' | tr '[:upper:]' '[:lower:]')

    if [ $remote_origin_count -eq "1" ]
    then
    git rev-list --left-right --count  origin/$branch_name...HEAD | awk '{print "You are behind tracked remote branch by "$1" commit(s), ahead by "$2" commit(s)"}'
    git rev-list --left-right --count  origin/develop...HEAD | awk '{print "You are behind develop by "$1" commit(s), ahead by "$2" commit(s)"}'
    git rev-list --left-right --count  origin/master...HEAD | awk '{print "You are behind master by "$1" commit(s), ahead by "$2" commit(s)"}'
    git rev-list --left-right --count  origin/develop...origin/staging | awk '{print "origin/staging is behind origin/develop by "$1" commit(s), ahead by "$2" commit(s)"}'
    git rev-list --left-right --count  origin/master...origin/develop | awk '{print "origin/develop is behind origin/master by "$1" commit(s), ahead by "$2" commit(s)"}'
    git rev-list --left-right --count  origin/master...origin/staging | awk '{print "origin/staging is behind origin/master by "$1" commit(s), ahead by "$2" commit(s)"}'
    else
    echo "warning: remote origin does not exist"
    fi
}

# flutter
export PATH="$PATH:~/git/flutter/bin"

# pyenv
# if command -v pyenv 1>/dev/null 2>&1; then
#   eval "$(pyenv init -)"
# fi

# rbenv
eval "$(rbenv init -)"
# export PATH="$PATH:~/.gem/ruby/2.6.0/bin"

# ssh
eval "$(ssh-agent -s)"
ssh-add -K ~/.ssh/id_rsa
ssh-add -L

source $HOME/.cargo/env

# circles
function addcl() {
    fn=unreleased_changes/$(git branch --show-current).md
    touch $fn
    echo "* Features" > $fn
    echo "    *" $(git branch --show-current) >> $fn
}