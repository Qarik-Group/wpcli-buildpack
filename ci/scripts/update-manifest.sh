#!/bin/bash

set -eu

version=$(cat wp-cli/version)
sha=$(sha256sum wp-cli/wp-cli*.phar | awk '{print $1}')

git clone git pushme

cat > pushme/manifest.yml <<YAML
---
language: wp-cli
default_versions:
- name: wp-cli
  version: ${version}
dependency_deprecation_dates: []

include_files:
  - README.md
  - VERSION
  - bin/supply
  - manifest.yml
pre_package: scripts/build.sh

dependencies:
- name: wp-cli
  version: ${version}
  uri: https://github.com/wp-cli/wp-cli/releases/download/v${version}/wp-cli-${version}.phar
  sha256: ${sha}
  cf_stacks:
  - cflinuxfs2
  - cflinuxfs3
YAML

pushd pushme

if [[ "$(git status -s)X" != "X" ]]; then
  set +e
  if [[ -z $(git config --global user.email) ]]; then
    git config --global user.email "drnic+bot@starkandwayne.com"
  fi
  if [[ -z $(git config --global user.name) ]]; then
    git config --global user.name "CI Bot"
  fi

  set -e
  echo ">> Running git operations as $(git config --global user.name) <$(git config --global user.email)>"
  echo ">> Getting back to master (from detached-head)"
  git merge --no-edit master
  git status
  git --no-pager diff
  git add manifest.yml
  git commit -m "Updated wp-cli to v${version}"
else
  echo ">> No update needed"
fi

popd
