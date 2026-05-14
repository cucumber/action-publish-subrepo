#!/bin/bash
set -e

# Read args
working_directory=$1
token=$2

# Check git token is set
if [ -z "$token" ]; then
	echo "Please set the github-token input"
	exit 1
fi

subrepo_name="$GITHUB_REPOSITORY-$working_directory"
echo "Target subrepo: $subrepo_name"

# Avoid 'dubious ownership' warning from git
git config --global --add safe.directory /github/workspace
git config --global --add safe.directory /github/workspace/.git

# debug
git tag --list
git show-ref

# Check if subrepo exists and can be accessed
subrepo_url="https://$token@github.com/$subrepo_name"
if ! curl --fail "$subrepo_url" >/dev/null; then
  echo "Subrepo $subrepo_name does not exist! You can use this command to create it:"
  echo
  echo "gh repo create $subrepo_name --public --description 'READ-ONLY mirror of $GITHUB_REPOSITORY $working_directory folder'"
  exit 1
else
	echo "Testing connection to subrepo $subrepo_url"
	# This won't catch everything. Push is affected by token permissions, rulesets, ect.
	# Overall these are too complicated to check and aren't often wrong.
	# So good enough for now.
	git ls-remote "$subrepo_url" || (echo -e "Unable to read $subrepo_url\nCheck your token's permissions and target repos rules." && exit 1)
fi

"$(dirname "$0")"/publish-to-subrepo "$working_directory" "$subrepo_url"
