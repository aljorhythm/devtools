echo running my_bash_profile

# docker
echo docker shortcuts
alias docker-rmi='docker rmi $(docker images -a -q)'
alias docker-stop='docker stop $(docker ps -aq)'
alias docker-rmc='docker container rm $(docker container ls -aq)'
alias docker-reset='docker-stop && docker-rmc && docker-rmi'

# general shortcuts

alias ls-files='find $(pwd) -type f'
alias workspace="cd ~/git"
ln -s ~/Library/Mobile\ Documents/com\~apple\~CloudDocs ~/iCloud
alias icloud='cd ~/iCloud'
alias downloads="cd ~/Downloads"
alias copyssh='cat ~/.ssh/id_rsa.pub | pbcopy'
alias copypath='pwd | pbcopy'

# nvm
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

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

# git
alias checkout="git checkout"

# flutter
export PATH="$PATH:~/git/flutter/bin"

# pyenv
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# rbenv
eval "$(rbenv init -)"

# ssh
eval "$(ssh-agent -s)"
ssh-add -K ~/.ssh/id_rsa
ssh-add -L

echo "calling circles_mbp.sh"
source ~/circles_mbp.sh