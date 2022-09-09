#!/bin/bash

cd monorepo || exit
mkdir ruby
echo "# Ruby project" >ruby/README.md
git add .
git commit --message "Add ruby"

mkdir php
echo "# PHP project" >php/README.md
git add .
git commit --message "Add php"
git tag "php-v1"

# run the tool
publish-to-subrepo php "$SUBREPO"
