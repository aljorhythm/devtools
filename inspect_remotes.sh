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
