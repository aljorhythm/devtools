#!/bin/bash
set -x #echo on

# node

npm install -g nodemon youtube-dl create-react-app git-open gitignore bitbucket-open jest
npm i -g tldr

# python3

pyenv install 3.7.2
pyenv which python

# ruby

rvm install 2.7.2
rvm use 2.7.2