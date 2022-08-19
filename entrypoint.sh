#!/bin/sh
set -e

working_directory=$1
token=$2

if [ -z "$token" ]
then
	echo "Please set the github-token input"
	exit 1
fi

target_repo="$GITHUB_REPOSITORY-$working_directory"
echo "Target repo: $target_repo"

# Avoid warning from git
git config --global --add safe.directory /github/workspace

# Create the subtree split branch in pwd directory
git subtree split --prefix="$working_directory" -b split

git config --global init.defaultBranch main
git init split
cd split
git config --global user.email "gitbot@github.com"
git config --global user.name "$GITHUB_ACTOR"
git pull ../ split

subrepo_url="https://$token@github.com/$target_repo.git"

echo "Testing connection to subrepo $subrepo_url"
git ls-remote "$subrepo_url"
# pull is OK, what about push?
git checkout --orphan test-push
git reset --hard
git commit --allow-empty --message "test push"
git push "$subrepo_url" test-push:refs/test/push || (echo -e "Unable to push to remote repo $subrepo_url\nCheck your token's permissions." && exit 1)
git push "$subrepo_url" :refs/test/push

git remote add subrepo "$subrepo_url"
git pull subrepo main --allow-unrelated-histories || echo "subrepo does not appear to have a main branch to pull from yet"
git lfs pull subrepo main
#push to subtree repo
git push subrepo main
echo sync success
