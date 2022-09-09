#!/bin/bash

pushd monorepo || exit
mkdir ruby
echo "# Ruby project" >ruby/README.md
git add .
git commit --message "Add ruby"

mkdir php
echo "# PHP project" >php/README.md
git add .
git commit --message "Add php"

echo "# An amazing PHP project" >php/README.md
git add .
git commit --message "Update php readme"

# run the tool
publish-to-subrepo php "$SUBREPO"
