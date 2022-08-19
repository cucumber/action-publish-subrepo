#!/bin/sh
set -e

working_directory=$1
token=$2

# Check git token is set
if [ -z "$token" ]
then
	echo "Please set the github-token input"
	exit 1
fi

target_repo="$GITHUB_REPOSITORY-$working_directory"
echo "Target subrepo: $target_repo"

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

# Create subrepo if missing, or check access for token if it exists
subrepo_url="https://$token@github.com/$target_repo"
if ! curl --fail "$subrepo_url" > /dev/null; then
	# TODO: consider using --template here to have a template for read-only subrepos
	export GH_TOKEN="$token"
	gh repo create "$target_repo" --public --description "READ-ONLY mirror of $GITHUB_REPOSITORY $working_directory folder"
else
	echo "Testing connection to subrepo $subrepo_url"
	git ls-remote "$subrepo_url"
	# pull is OK, what about push?
	git checkout --orphan test-push
	git reset --hard
	git commit --allow-empty --message "test push"
	git push "$subrepo_url" test-push:refs/test/push || (echo -e "Unable to push to remote repo $subrepo_url\nCheck your token's permissions." && exit 1)
	git push "$subrepo_url" :refs/test/push
fi

# Pull from subrepo
git remote add subrepo "$subrepo_url"
git config pull.rebase true
git pull subrepo main --allow-unrelated-histories || echo "subrepo does not appear to have a main branch to pull from yet"
git lfs pull subrepo main

# Push the main branch and any tags referencing its commits
git push subrepo +refs/heads/main --follow-tags
