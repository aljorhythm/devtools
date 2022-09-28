git config --global merge.tool opendiff

git update-index --chmod=-x

for dir in wins*; do echo $dir; echo $(cd "$dir"; git clean -f; git checkout .; git clean -n); done;