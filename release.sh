#!/usr/bin/env bash


# Usage: ./release.sh 1.0.3

# Get version argument and verify
version=$1
if [ -z "$version" ]; then
  echo "Please specify a version"
  exit
fi

# Output
echo "Releasing version $version"
echo "-------------------------------------------------------------------------"

# Checkout develop branch and merge version branch into develop
git checkout develop
git pull

# Get current branch and checkout if needed
branch=$(git show-ref $version)
if [ -n "$branch"  ]; then
  echo 'branch exists!'
else
  git branch $version 
fi



# Checkout release branch
git checkout $version

# Ensure working directory in version branch clean
git update-index -q --refresh
if ! git diff-index --quiet HEAD --; then
  echo "Working directory not clean, please commit your changes first"
  exit
fi

git merge develop --no-ff --no-edit
git push -u origin $version

# Success
echo "-------------------------------------------------------------------------"
echo "Merge dev to release $version complete"