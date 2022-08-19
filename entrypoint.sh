#!/bin/bash
set -e

# Read args
working_directory=$1
token=$2
create_subrepo_if_missing=$3

# Check git token is set
if [ -z "$token" ]
then
	echo "Please set the github-token input"
	exit 1
fi

subrepo_name="$GITHUB_REPOSITORY-$working_directory"
echo "Target subrepo: $subrepo_name"

# Avoid 'dubious ownership' warning from git
git config --global --add safe.directory /github/workspace

# debug
git tag --list
git show-ref

# Set up git author
git config --global user.email "gitbot@github.com"
git config --global user.name "$GITHUB_ACTOR"

# Get any tag pointing to current commit
tag="$(git tag --points-at "$GITHUB_REF")"

# Create the subtree split branch and pull into main branch of a new repo
git subtree split --prefix="$working_directory" -b split
monorepo=$(pwd)
git init /tmp/split -b main
cd /tmp/split
git pull "$monorepo" split:main

# Create subrepo if missing, or check access for token if it exists
subrepo_url="https://$token@github.com/$subrepo_name"
if ! curl --fail "$subrepo_url" > /dev/null; then
	if [ "$create_subrepo_if_missing" = 'true' ]; then
		# TODO: consider using --template here to have a template for read-only subrepos
		export GH_TOKEN="$token"
		gh repo create "$subrepo_name" --public --description "READ-ONLY mirror of $GITHUB_REPOSITORY $working_directory folder"
	else
		echo "Subrepo $subrepo_name does not exist! You can use this command to create it:"
		echo
		echo "gh repo create $subrepo_name --public --description 'READ-ONLY mirror of $GITHUB_REPOSITORY $working_directory folder'"
		exit 1
	fi
else
	echo "Testing connection to subrepo $subrepo_url"
	git ls-remote "$subrepo_url"
	# pull is OK, what about push?
	git checkout --orphan test-push
	git reset --hard
	git commit --allow-empty --message "test push"
	git push "$subrepo_url" test-push:refs/test/push || (echo -e "Unable to push to remote repo $subrepo_url\nCheck your token's permissions." && exit 1)
	git push "$subrepo_url" :refs/test/push
	git checkout main
fi

# tag the commit on main
if [ -n "$tag" ]; then
	git tag "$tag" main
fi

# Pull older commits from remote
git pull "$subrepo_url" main --rebase

# Push the main branch and any tags referencing its commits
git push "$subrepo_url" main "$tag" --force
