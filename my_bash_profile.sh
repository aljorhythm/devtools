echo running my_bash_profile

# nvm
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

# ruby
export PATH="/usr/local/opt/ruby/bin:$PATH"
LDFLAGS="-L/usr/local/opt/ruby/lib"
CPPFLAGS="-I/usr/local/opt/ruby/include"
export PKG_CONFIG_PATH="/usr/local/opt/ruby/lib/pkgconfig"

# open applications
alias vscode="open -a /Applications/Visual\ Studio\ Code.app/"

# nodemon
monpy() {
    nodemon --watch "$1" --exec "python $1" 
}

nmongo() {
    nodemon --ext ".go" --exec "go run main.go"
}

monrb() {
    nodemon --ext ".rb" --exec "ruby $1"
}

# flutter
export PATH="$PATH:/Users/joellim/git/flutter/bin"

# pyenv
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi