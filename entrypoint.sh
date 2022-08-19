#!/bin/sh
set -e

TARGET_REPO=${GITHUB_REPOSITORY}-${INPUT_WORKING_DIRECTORY}
echo target repo:"$TARGET_REPO"

git config --global --add safe.directory /github/workspace

# Create the subtree split branch in pwd directory
git subtree split --prefix="${INPUT_WORKING_DIRECTORY}" -b split

git config --global init.defaultBranch main
git init split
cd split
git config --global user.email "gitbot@github.com"
git config --global user.name "$GITHUB_ACTOR"
git pull ../ split
subrepo_url="https://${INPUT_GITHUB_TOKEN}@github.com/${TARGET_REPO}.git"
echo "Testing connection to subrepo $subrepo_url"
git ls-remote subrepo_url
git remote add subrepo $subrepo_url
git pull subrepo main --allow-unrelated-histories
git lfs pull subrepo main
#push to subtree repo
git push subrepo main
echo sync success
