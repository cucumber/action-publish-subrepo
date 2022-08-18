#!/bin/sh

TARGET_REPO=${GITHUB_REPOSITORY}-${INPUT_WORKING_DIRECTORY}
echo target repo:"$TARGET_REPO"

# Create the subtree split branch in pwd directory
git subtree split --prefix="${INPUT_WORKING_DIRECTORY}" -b split

git config --global init.defaultBranch main
git init split
cd split
git config --global user.email "gitbot@github.com"
git config --global user.name "$GITHUB_ACTOR"
git pull ../ split
git remote add subrepo "git@github.com:${GITHUB_REPOSITORY}-${INPUT_WORKING_DIRECTORY}.git"
git pull subrepo main --allow-unrelated-histories
git lfs pull subrepo main
#push to subtree repo
git push subrepo main
echo sync success
