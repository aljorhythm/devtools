echo running my_bash_profile

# docker
echo docker shortcuts
alias docker-rmi='docker rmi $(docker images -a -q)'
alias docker-stop='docker stop $(docker ps -aq)'
alias docker-rmc='docker container rm $(docker container ls -aq)'
alias docker-reset='docker system prune -f && docker-stop && docker-rmc && docker-rmi'

# general shortcuts

alias ls-files='find $(pwd) -type f'
alias workspace="cd ~/git"
alias ws='cd ~/git'
alias icloud='cd ~/iCloud'
alias downloads="cd ~/Downloads"
alias copyssh='cat ~/.ssh/id_rsa.pub | pbcopy'
alias st='open -a /Applications/Sourcetree.app "$(git rev-parse --show-toplevel)"'
alias vs='open -a /Applications/Visual\ Studio\ Code.app/'
alias rbmine='open /Applications/RubyMine.app/'

# nvm
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
alias co="git checkout"
alias commit="git commit -m "
alias cm="git commit -m "
alias cmnv="git commit --no-verify -m"
alias push="git push"
alias pull="git pull"
alias add="git add"
alias status="git status"

# golang
alias go-clean="go clean -i -testcache -modcache -x -r -cache"

# make
alias mut="make unit_test"

cppath() {
    echo copying "$(pwd)"
    pwd | pbcopy
}

cphash() {
    echo copying $(git rev-parse --short HEAD)
    git rev-parse --short HEAD | pbcopy
}

cplast(){
    echo "!!" | pbcopy
    echo copied last cmd
}

cpbranch() {
    echo copying $(git branch --show-current)
    git branch --show-current | pbcopy
}

checkremotes() {
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