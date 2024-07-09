`git config --global merge.tool opendiff`
`git config core.hooksPath .githooks`

`git update-index --chmod=-x`

`git update-index --assume-unchanged /src/test/resources/application.properties`
`git update-index --no-assume-unchanged /src/test/resources/application.properties`


# loop directories and do something

for dir in wins*; do echo $dir; echo $(cd "$dir"; git clean -f; git checkout .; git clean -n); done;

To remove the most recent commit but keep the changes in your working directory, use:

`git reset --soft HEAD~1`
`git reset HEAD^`

`git rebase --autosquash origin/master`

`git log feature/orm-to-sql..HEAD --oneline | tail -1`

`git rebase --exec 'git commit --amend --no-edit -n -S' -i origin/master`

`git rebase --exec 'git commit --amend -n -S' -i origin/master`


oneline
`git log --all --decorate --oneline --graph`