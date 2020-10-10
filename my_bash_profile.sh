echo running my_bash_profile

# nvm
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

# ruby
export PATH="/usr/local/opt/ruby/bin:$PATH"
LDFLAGS="-L/usr/local/opt/ruby/lib"
CPPFLAGS="-I/usr/local/opt/ruby/include"
export PKG_CONFIG_PATH="/usr/local/opt/ruby/lib/pkgconfig"