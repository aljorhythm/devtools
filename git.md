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

`git log --all --decorate --oneline --graph -6`

git config --global --unset diff.tool
git config --global --unset merge.tool 
git config --global --unset interactive.difffilter
git config --global --unset core.pager

git config --global commit.gpgsign true
git config --global tag.gpgSign true
git reset --hard @{u}

git fetch --prune
git branch -r --merged origin/master | grep -v 'origin/master' | grep -v 'origin/HEAD'

git branch -r --merged origin/master | \
grep -v 'origin/master' | \
grep -v 'origin/HEAD' | \
sed 's|origin/||' | \
xargs -n 1 -I % git push origin --delete %

git archive --format=zip -o $(basename $(pwd)).zip master && mv $(basename $(pwd)).zip ~/Downloads