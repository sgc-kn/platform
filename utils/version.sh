#!/usr/bin/env bash

set -euo pipefail

# This script produces version numbers for this repository. The version number
# are not really semantic, but they fulfill the spec of semantic versioning:
# - major and minor version are defined as annotated git tag v[MAJOR].[MINOR]
# - the patch version is the number of commits since the last tag
# - we append the git hash as version metadata, separated by a plus sign
# - if we are off the main branch append ('.dev')
# - if there are uncommitted changes append ('.wip')
#
# To bump the version number run `git tag v[MAJOR].[MINOR] -a` and push.

description=$(git describe --long --abbrev=8 --match 'v[0-9]*.[0-9]*')
re='^v([0-9]+)\.([0-9]+)-([0-9]+)-g([0-9a-f]+)$'

if [[ $description =~ $re ]]; then
    ver_major="${BASH_REMATCH[1]}"
    ver_minor="${BASH_REMATCH[2]}"
    n_commits="${BASH_REMATCH[3]}"
    sha="${BASH_REMATCH[4]}"
else
    echo "Error: '${description}' didn't match regex"
    exit 1
fi

# are we on the main branch
branch=.$(git rev-parse --abbrev-ref HEAD)
if [ "${branch}" == ".main" ] ; then
  branch=""
fi

# are there local/staged changes?
dirty=$(git diff-index --quiet HEAD || echo ".dirty")

# merge everything into a "semantic" version number
echo "${ver_major}.${ver_minor}.${n_commits}+${sha}${branch}${dirty}"
