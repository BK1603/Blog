#!/bin/sh

# If a command fails then the deploy stops
set -e

printf "\033[0;32mDeploying updates to GitHub...\033[0m\n"

# Build the project.
hugo

# Go to public folder and commit changes
cd public
git add .
msg="rebuilding site${date}"
if [ -n "$*" ]; then
  msg="$*"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin master
