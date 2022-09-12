#!/bin/bash
set -e

pushd monorepo || exit
mkdir ruby
echo "# Ruby project" >ruby/README.md
git add .
git commit --message "Add ruby"

mkdir php
echo "# PHP project" >php/README.md
git add .
git commit --message "Add php"
popd || exit

# make a shallow clone and move into its folder
git clone --depth 1 "file://$(realpath monorepo)" "$(realpath monorepo-clone)" --quiet
pushd monorepo-clone || exit

# run the tool
publish-to-subrepo ruby "$SUBREPO"
