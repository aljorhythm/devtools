# brew

brew bundle dump --force

# npm

npm list --global --parseable --depth=0 | grep -v wins | sed '1d' | awk '{gsub(/\/.*\//,"",$1); print}' >npm.global.txt
