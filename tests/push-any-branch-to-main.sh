#!/bin/bash

pushd monorepo || exit

git checkout -b release/v1.0.0

mkdir ruby
echo "# Ruby project" >ruby/README.md
git add .
git commit --message "Add ruby"

mkdir php
echo "# PHP project" >php/README.md
git add .
git commit --message "Add php"

# run the tool
publish-to-subrepo php "$SUBREPO"
