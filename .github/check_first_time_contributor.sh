#!/bin/bash
# Check if First-Time Contributor
# This script determines if the issue author is creating their first issue and has no PRs

set -e  # Exit on error

AUTHOR="$1"
REPO="$2"

echo "Checking if $AUTHOR is a first-time contributor..."

# Check if user has any previous issues (excluding this one)
ISSUE_COUNT=$(gh issue list --repo "$REPO" --author "$AUTHOR" --state all --limit 1000 --json number | jq 'length')

# Check if user has any PRs
PR_COUNT=$(gh pr list --repo "$REPO" --author "$AUTHOR" --state all --limit 1000 --json number | jq 'length')

echo "Issues by $AUTHOR: $ISSUE_COUNT"
echo "PRs by $AUTHOR: $PR_COUNT"

# If this is their first issue (count=1) and they have no PRs (count=0), they're a first-timer
if [ "$ISSUE_COUNT" -eq 1 ] && [ "$PR_COUNT" -eq 0 ]; then
  echo "is_first_time=true"
  echo "🎉 First-time contributor detected!"
  exit 0
else
  echo "is_first_time=false"
  echo "Returning contributor"
  exit 1
fi
