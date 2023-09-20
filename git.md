git config --global merge.tool opendiff
	git config core.hooksPath .githooks

git update-index --chmod=-x

git update-index --assume-unchanged /src/test/resources/application.properties
git update-index --no-assume-unchanged /src/test/resources/application.properties


# loop directories and do something

for dir in wins*; do echo $dir; echo $(cd "$dir"; git clean -f; git checkout .; git clean -n); done;